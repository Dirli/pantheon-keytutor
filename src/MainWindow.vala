namespace KeyTutor {
    public class MainWindow : Gtk.Window {
        public MainWindow (KeyTutorApp app) {
            set_application (app);
            window_position = Gtk.WindowPosition.CENTER;
            set_default_size (1150, 650);
            set_size_request (1150, 650);
        }
    }
}
