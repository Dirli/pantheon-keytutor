namespace KeyTutor {
    public class MainWindow : Gtk.Window {
        private Gtk.Grid view;
        private Widgets.Welcome welcome_widget;

        public MainWindow (KeyTutorApp app) {
            set_application (app);
            window_position = Gtk.WindowPosition.CENTER;
            set_default_size (1150, 650);
            set_size_request (1150, 650);

            var header_bar = new Widgets.Header ();
            header_bar.nav_clicked.connect (on_nav_clicked);

            set_titlebar (header_bar);


            view = new Gtk.Grid ();
            view.expand = true;
            view.halign = view.valign = Gtk.Align.FILL;

            init_welcome ();
            add (view);
            GLib.Idle.add (() => {
                header_bar.show_nav_btn (false);
                return false;
            });
        }

        private void add_main_widget (Gtk.Widget new_widget) {
            var exist_widget = view.get_child_at (0, 0);

            if (exist_widget != null) {
                exist_widget.destroy ();
            }

            view.attach (new_widget, 0, 0);
            show_all ();
        }

        private void init_welcome () {
            welcome_widget = new Widgets.Welcome ();
            welcome_widget.welcome_activate.connect (on_welcome_activate);

            add_main_widget (welcome_widget);
        }

        private void on_welcome_activate (int index) {
            //
        }

        private void on_nav_clicked () {
            init_welcome ();
        }
    }
}
