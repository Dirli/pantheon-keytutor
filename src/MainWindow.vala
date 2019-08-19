namespace KeyTutor {
    public class MainWindow : Gtk.Window {
        private Gtk.Grid view;
        private Widgets.Welcome welcome_widget;
        private Widgets.Header header_bar;
        private Widgets.Lesson? lesson_widget;

        private Services.Lessons lessons_manager;

        private Gee.HashMap<string, uint16> chars_map;

        public MainWindow (KeyTutorApp app) {
            set_application (app);
            window_position = Gtk.WindowPosition.CENTER;
            set_default_size (1150, 650);
            set_size_request (1150, 650);

            Gtk.CssProvider provider = new Gtk.CssProvider();
            provider.load_from_resource ("/io/elementary/keytutor/application.css");
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            lessons_manager = Services.Lessons.get_default ();
            chars_map = lessons_manager.generate_keys_map ();

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
            lesson_widget = null;
            key_release_event.disconnect (on_key_release);
            init_welcome ();
            header_bar.show_nav_btn (false);
        }

        private void on_run_lesson (uint8 index, string course_name) {
            string[]? text_arr = null;

            switch (course_name) {
                case "letters":
                    text_arr = lessons_manager.generate_lesson (index);
                    break;
            }

            if (text_arr != null && text_arr.length > 0) {
                lesson_widget = new Widgets.Lesson (text_arr, chars_map);
                lesson_widget.end_task.connect ((accuracy, speed) => {
                    lesson_widget = null;
                    key_release_event.disconnect (on_key_release);
                    // write rules for passing
                    var result_widget = new Widgets.Result (accuracy, speed, true, true);

                    bool passed_level = true;

                    passed_level = (passed_level && index < (lessons_manager.get_lessons_length () - 1));

                    result_widget.activate_man_btns (index > 0, passed_level);

                    add_main_widget (result_widget);
                    result_widget.clicked_ev.connect ((ev_name) => {
                        switch (ev_name) {
                            case "next":
                                if (passed_level) {
                                    on_run_lesson (index + 1, course_name);
                                }
                                break;
                            case "previous":
                                if (index > 0) {
                                    index -= 1;
                                }
                                on_run_lesson (index, course_name);
                                break;
                            case "repeat":
                                on_run_lesson (index, course_name);
                                break;
                        }
                    });
                });

                add_main_widget (lesson_widget);
                key_release_event.connect (on_key_release);
            }
        }

        private bool on_key_release (Gdk.EventKey event) {
            if (event.length > 0 && lesson_widget != null) {
                lesson_widget.key_press_ev (event);
            }

            return true;
        }
    }
}
