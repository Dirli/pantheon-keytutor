namespace KeyTutor.Widgets {
    public class Lesson : Gtk.Box {
        public signal void end_task (double accuracy, uint16 chars_per_min);

        private uint8 arr_offset;
        private int iter_inc;
        private uint16 total_chars = 0;
        private string[] text_arr;

        private Widgets.Info time_widget;
        private Widgets.Info accuracy_widget;
        private Widgets.Info speed_widget;

        private Services.Accuracy accuracy_service;
        private Services.Timer timer_service;

        private Gtk.TextBuffer text_buf;
        private Gtk.TextIter iter_str;
        private Gtk.TextIter iter_str_next;

        ~Lesson () {
            timer_service.stop_timer ();
        }

        public Lesson (string[] lesson_task, Gee.HashMap<string, uint16> chars_map) {
            Object (orientation: Gtk.Orientation.VERTICAL,
                    hexpand: true,
                    margin: 20,
                    valign: Gtk.Align.FILL,
                    spacing: 30);

            arr_offset = 0;
            iter_inc = 0;

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

            pack_start (info_box, true, true, 0);
            pack_start (text_widget, true, true, 0);
        }

        private void offset_line () {
            text_buf.get_iter_at_line_offset (out iter_str, 0, iter_inc);
            ++iter_inc;
            text_buf.get_iter_at_line_offset (out iter_str_next, 0, iter_inc);
            text_buf.apply_tag_by_name ("green_background", iter_str, iter_str_next);
        }
    }
}
