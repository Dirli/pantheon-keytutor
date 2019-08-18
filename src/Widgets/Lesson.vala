namespace KeyTutor.Widgets {
    public class Lesson : Gtk.Box {
        public signal void end_task (double accuracy, uint16 chars_per_min);

        private uint8 arr_offset;
        private int iter_inc;
        private uint16 total_chars = 0;
        private string[] text_arr;
        private bool _timer_run = false;

        public bool timer_run {
            get {
                return _timer_run;
            }
            set {
                _timer_run = value;
                if (value) {
                    timer_service.start_timer ();
                } else {
                    timer_service.stop_timer ();
                }
            }
        }

        private Widgets.Keyboard keyboard_widget;
        private Widgets.Info time_widget;
        private Widgets.Info accuracy_widget;
        private Widgets.Info speed_widget;

        private Services.Accuracy accuracy_service;
        private Services.Timer timer_service;

        private Gtk.TextBuffer text_buf;
        private Gtk.TextIter iter_str;
        private Gtk.TextIter iter_str_next;

        private Gee.HashMap<string, uint16> chars_map;

        ~Lesson () {
            if (timer_run) {
                timer_service.stop_timer ();
            }
        }

        public Lesson (string[] lesson_task, Gee.HashMap<string, uint16> chars_map) {
            Object (orientation: Gtk.Orientation.VERTICAL,
                    hexpand: true,
                    margin: 20,
                    valign: Gtk.Align.FILL,
                    spacing: 30);

            arr_offset = 0;
            iter_inc = 0;

            this.chars_map = chars_map;

            time_widget = new Widgets.Info ("Time");
            speed_widget = new Widgets.Info ("Speed");
            accuracy_widget = new Widgets.Info ("Accuracy");

            accuracy_service = new Services.Accuracy ();
            timer_service = new Services.Timer ();
            timer_service.pasted_time.connect ((ptime) => {
                int min = ptime / 60;
                int sec = ptime % 60;

                if (ptime > 0) {
                    speed_widget.set_new_val ("%d ch/m".printf (60 * total_chars / ptime));
                }

                time_widget.set_new_val ("%d:%2.2d ".printf (min, sec) + _("s."));
            });

            var info_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
            info_box.halign = Gtk.Align.CENTER;
            info_box.valign = Gtk.Align.START;
            info_box.add (time_widget);
            info_box.add (speed_widget);
            info_box.add (accuracy_widget);

            text_arr = lesson_task;

            text_buf = new Gtk.TextBuffer (null);
            text_buf.create_tag ("green_background", "background", "LightSeaGreen");
            text_buf.create_tag ("correct_in", "foreground", "DimGrey");
            text_buf.create_tag ("uncorrect_in", "background", "DeepPink");
            text_buf.set_text (text_arr[0]);

            var text_widget = new Gtk.TextView.with_buffer (text_buf);
            text_widget.get_style_context ().add_class ("text");
            text_widget.margin_top = text_widget.margin_bottom = 30;
            text_widget.set_size_request (-1, 32);
            text_widget.hexpand = text_widget.vexpand = true;
            text_widget.valign = Gtk.Align.CENTER;
            text_widget.set_justification (Gtk.Justification.CENTER);
            text_widget.can_focus = false;

            offset_line ();

            keyboard_widget = new Widgets.Keyboard (Services.Lessons.get_default ().get_keys_map ());
            keyboard_widget.select_press_btn (this.chars_map[iter_str.get_char ().to_string ()]);

            pack_start (info_box, true, true, 0);
            pack_start (text_widget, true, true, 0);
            pack_start (keyboard_widget, true, true, 0);
        }

        private void offset_line () {
            text_buf.get_iter_at_line_offset (out iter_str, 0, iter_inc);
            ++iter_inc;
            text_buf.get_iter_at_line_offset (out iter_str_next, 0, iter_inc);
            text_buf.apply_tag_by_name ("green_background", iter_str, iter_str_next);
        }

        private string? get_next_str () {
            if (arr_offset < text_arr.length) {
                arr_offset++;
                return text_arr[arr_offset];
            } else {
                return null;
            }
        }

        public void key_press_ev (Gdk.EventKey event) {
            text_buf.remove_tag_by_name ("green_background", iter_str, iter_str_next);

            total_chars++;

            if (!timer_run) {
                timer_run = true;
            }

            keyboard_widget.unselect_release_btn (chars_map[iter_str.get_char ().to_string ()]);

            string tag_name;
            var expected_char = iter_str.get_char ().to_string ();

            if (expected_char == event.str) {
                tag_name = "correct_in";
            } else {
                tag_name = "uncorrect_in";
                accuracy_service.add_err ();
            }

            text_buf.apply_tag_by_name (
                tag_name,
                iter_str,
                iter_str_next
            );

            offset_line ();

            accuracy_widget.set_new_val ("%.1f %%".printf (accuracy_service.get_accuracy (total_chars)));

            if (iter_inc > iter_str_next.get_line_offset ()) {
                string? new_str = get_next_str ();
                if (null != new_str) {
                    iter_inc = 0;
                    text_buf.set_text (new_str);
                    offset_line ();
                } else {
                    timer_run = false;
                    end_task (accuracy_service.get_accuracy (total_chars),
                              (uint16) (60 * total_chars / timer_service.get_full_time ()));
                    return;
                 }
            }

            keyboard_widget.select_press_btn (chars_map[iter_str.get_char ().to_string ()]);
        }
    }
}
