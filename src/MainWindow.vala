namespace KeyTutor {
    public class MainWindow : Gtk.Window {
        public MainWindow (KeyTutorApp app) {
            set_application (app);
            window_position = Gtk.WindowPosition.CENTER;
            set_default_size (1150, 650);
            set_size_request (1150, 650);

            var header_bar = new Widgets.Header ();
            header_bar.nav_clicked.connect (on_nav_clicked);

            set_titlebar (header_bar);

            show_all ();

            GLib.Idle.add (() => {
                header_bar.show_nav_btn (false);
                return false;
            });
        }

        private void on_nav_clicked () {
            //
        }
    }
}
