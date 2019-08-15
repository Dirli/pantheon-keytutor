namespace KeyTutor {
    public class Widgets.Header : Gtk.HeaderBar {
        public signal void nav_clicked ();

        private Gtk.Button nav_button;

        construct {
            show_close_button = true;
            has_subtitle = false;
            title = "KeyTutor";
        }

        public Header () {
            nav_button = new Gtk.Button ();
            nav_button.can_focus = false;
            nav_button.label = "back";
            nav_button.valign = Gtk.Align.CENTER;
            nav_button.vexpand = false;
            nav_button.get_style_context ().add_class ("back-button");
            nav_button.clicked.connect (() => {
                nav_button.hide ();
                nav_clicked ();
            });

            pack_start (nav_button);
        }

        public void show_nav_btn (bool show_nav) {
            if (show_nav) {
                nav_button.show ();
            } else {
                nav_button.hide ();
            }
        }
    }
}
