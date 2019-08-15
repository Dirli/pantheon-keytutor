namespace KeyTutor {
    public class KeyTutorApp : Gtk.Application {
        public MainWindow window;

        public KeyTutorApp () {
            application_id = "io.elementary.keytutor";
            flags |= GLib.ApplicationFlags.FLAGS_NONE;
        }

        public override void activate () {
            if (get_windows () == null) {
                window = new MainWindow (this);
                window.show_all ();
            } else {
                window.present ();
            }
        }

    }
}

public static void main (string [] args) {
    var app = new KeyTutor.KeyTutorApp ();
    app.run (args);
}
