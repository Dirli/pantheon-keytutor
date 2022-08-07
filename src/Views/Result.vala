namespace KeyTutor {
    public class Views.Result : Gtk.Box {
        public signal void choosed_action (string ev_name);

        private Gtk.Button next_lesson_btn;
        private Gtk.Button prev_lesson_btn;

        private Widgets.Info accuracy_widget;
        private Widgets.Info speed_widget;

        public Result () {
            Object (orientation: Gtk.Orientation.VERTICAL,
                    vexpand: true,
                    hexpand: true,
                    valign: Gtk.Align.CENTER,
                    halign: Gtk.Align.CENTER,
                    margin: 20,
                    spacing: 30);
        }

        construct {
            speed_widget = new Widgets.Info ("Speed");
            accuracy_widget = new Widgets.Info ("Accuracy");

            Gtk.Box info_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10) {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.START
            };

            info_box.add (speed_widget);
            info_box.add (accuracy_widget);

            prev_lesson_btn = create_button ("go-previous", _("Run previous lesson"));
            prev_lesson_btn.clicked.connect (() => {
                choosed_action ("previous");
            });

            next_lesson_btn = create_button ("go-next", _("Run next lesson"));
            next_lesson_btn.clicked.connect (() => {
                choosed_action ("next");
            });

            var repeat_btn = create_button ("view-refresh", _("Repeat lesson"));
            repeat_btn.clicked.connect (() => {
                choosed_action ("repeat");
            });

            var stats_btn = create_button ("keytutor-graphic", _("Show statistics"));
            stats_btn.clicked.connect (() => {
                choosed_action ("statistic");
            });

            var btns_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10) {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.START,
                hexpand = false
            };

            btns_box.add (prev_lesson_btn);
            btns_box.add (repeat_btn);
            btns_box.add (next_lesson_btn);
            btns_box.add (stats_btn);

            add (info_box);
            add (btns_box);
        }

        public void update_info (double accuracy, uint16 speed, bool accuracy_state, bool speed_state) {
            speed_widget.set_new_info ("%hu ch/m".printf (speed));
            speed_widget.update_style (speed_state);

            accuracy_widget.set_new_info ("%.1f %%".printf (accuracy));
            accuracy_widget.update_style (accuracy_state);
        }

        public void activate_man_btns (bool prev, bool next) {
            prev_lesson_btn.sensitive = prev;
            next_lesson_btn.sensitive = next;
        }

        private Gtk.Button create_button (string icon_name, string btn_title) {
            Gtk.Image button_image = new Gtk.Image.from_icon_name (icon_name, Gtk.IconSize.DIALOG) {
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.CENTER,
                use_fallback = true
            };
            button_image.set_pixel_size (48);

            Gtk.Label button_title = new Gtk.Label (btn_title) {
                halign = Gtk.Align.START,
                valign = Gtk.Align.CENTER
            };
            button_title.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);

            Gtk.Box button_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);

            button_box.add (button_image);
            button_box.add (button_title);

            var btn = new Gtk.Button ();
            btn.add (button_box);

            return btn;
        }
    }
}
