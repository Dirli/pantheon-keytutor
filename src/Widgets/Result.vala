namespace KeyTutor {
    public class Widgets.Result : Gtk.Box {
        public signal void clicked_ev (string ev_name);

        private Widgets.CustomButton next_lesson_btn;
        private Widgets.CustomButton prev_lesson_btn;
        private Widgets.Info accuracy_widget;
        private Widgets.Info speed_widget;

        public Result (double accuracy, uint16 speed, bool accuracy_state, bool speed_state) {
            Object (orientation: Gtk.Orientation.VERTICAL,
                    vexpand: true,
                    hexpand: true,
                    valign: Gtk.Align.CENTER,
                    halign: Gtk.Align.CENTER,
                    margin: 20,
                    spacing: 30);

            speed_widget = new Widgets.Info ("Speed", speed_state ? "passed-box" : "failed-box");
            speed_widget.set_new_val ("%hu ch/m".printf (speed));
            accuracy_widget = new Widgets.Info ("Accuracy", accuracy_state ? "passed-box" : "failed-box");
            accuracy_widget.set_new_val ("%.1f %%".printf (accuracy));

            Gtk.Box info_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
            info_box.halign = Gtk.Align.CENTER;
            info_box.valign = Gtk.Align.START;
            info_box.add (speed_widget);
            info_box.add (accuracy_widget);

            var repeat_btn = new Widgets.CustomButton ("view-refresh", _("Repeat lesson"));
            prev_lesson_btn = new Widgets.CustomButton ("go-previous", _("Run previous lesson"));
            next_lesson_btn = new Widgets.CustomButton ("go-next", _("Run next lesson"));
            var stats_btn = new Widgets.CustomButton ("keytutor-graphic", _("Show statistics"));

            prev_lesson_btn.clicked.connect (() => {
                clicked_ev ("previous");
            });

            next_lesson_btn.clicked.connect (() => {
                clicked_ev ("next");
            });

            repeat_btn.clicked.connect (() => {
                clicked_ev ("repeat");
            });

            stats_btn.clicked.connect (() => {
                clicked_ev ("statistic");
            });

            var btns_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 10);
            btns_box.halign = Gtk.Align.CENTER;
            btns_box.valign = Gtk.Align.START;
            btns_box.hexpand = false;

            btns_box.add (prev_lesson_btn);
            btns_box.add (repeat_btn);
            btns_box.add (next_lesson_btn);
            btns_box.add (stats_btn);

            add (info_box);
            add (btns_box);
        }

        public void activate_man_btns (bool prev, bool next) {
            prev_lesson_btn.sensitive = prev;
            next_lesson_btn.sensitive = next;
        }
    }
}
