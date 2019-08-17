namespace KeyTutor {
    public class MainWindow : Gtk.Window {
        private Gtk.Grid view;
        private Widgets.Welcome welcome_widget;
        private Widgets.Header header_bar;

        private Services.Lessons lessons_manager;

        public MainWindow (KeyTutorApp app) {
            set_application (app);
            window_position = Gtk.WindowPosition.CENTER;
            set_default_size (1150, 650);
            set_size_request (1150, 650);

            lessons_manager = Services.Lessons.get_default ();
            lessons_manager.generate_keys_map ();

            header_bar = new Widgets.Header ();
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

            welcome_widget.set_activate (0);
            add_main_widget (welcome_widget);
        }

        private void on_welcome_activate (int index) {
            switch (index) {
                case 0:
                    var lessons_widget = new Widgets.Lessons (lessons_manager.get_lessons_list ());
                    lessons_widget.run_lesson.connect ((index, name) => {
                        on_run_lesson (index, name);
                        header_bar.show_nav_btn (true);
                    });

                    welcome_widget.attach (lessons_widget, 2, 0);
                    break;
            }
        }

        private void on_nav_clicked () {
            init_welcome ();
        }

        private void on_run_lesson (uint8 index, string course_name) {
            //
        }
    }
}
