namespace KeyTutor {
    public class MainWindow : Gtk.Window {
        private Gtk.Grid view;
        private Widgets.Welcome welcome_widget;
        private Widgets.Header header_bar;
        private Widgets.Lesson? lesson_widget;

        private Services.DBManager db_conn;
        private Services.Lessons lessons_manager;
        private GLib.Settings settings;

        private string[] locales_list;
        private string _locale;
        private string locale {
            get {
                return _locale;
            }
            set {
                _locale = value;
                lessons_manager.generate_keys_map (_locale);
            }
        }

        public MainWindow (KeyTutorApp app) {
            set_application (app);
            window_position = Gtk.WindowPosition.CENTER;
            set_default_size (1150, 650);
            set_size_request (1150, 650);

            Gtk.CssProvider provider = new Gtk.CssProvider();
            provider.load_from_resource ("/io/elementary/keytutor/application.css");
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            Gtk.IconTheme.get_default().add_resource_path("/io/elementary/keytutor/icons");

            settings = Services.Settings.get_default ();
            db_conn = Services.DBManager.get_default ();
            lessons_manager = Services.Lessons.get_default ();

            locales_list = {};

            try {
                GLib.Dir dir = GLib.Dir.open ("/usr/share/io.elementary.keytutor/layout/", 0);
                while ((name = dir.read_name ()) != null) {
                    locales_list += name.split(".")[0];
                }
            } catch (Error e) {
                warning (e.message);
            }

            if (!("en" in locales_list)) {
                //
            }

            if (!(settings.get_string ("locale") in locales_list)) {
                settings.set_string ("locale", "en");
            }

            header_bar = new Widgets.Header ();
            header_bar.nav_clicked.connect (on_nav_clicked);
            header_bar.menu_select.connect (on_menu_select);

            set_titlebar (header_bar);

            view = new Gtk.Grid ();
            view.expand = true;
            view.halign = view.valign = Gtk.Align.FILL;

            on_locale_change ();
            add (view);

            GLib.Idle.add (() => {
                header_bar.show_nav_btn (false);
                return false;
            });

            settings.changed["locale"].connect (on_locale_change);
        }

        private void on_locale_change () {
            locale = settings.get_string ("locale");
            init_welcome ();
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
            lesson_widget = null;

            welcome_widget = new Widgets.Welcome ();
            welcome_widget.welcome_activate.connect (on_welcome_activate);

            welcome_widget.set_activate (0);
            add_main_widget (welcome_widget);
        }

        private void on_welcome_activate (int index) {
            switch (index) {
                case 0:
                    var lessons_widget = new Widgets.Lessons (lessons_manager.get_lessons_list (),
                                                              db_conn.get_level (locale));
                    lessons_widget.run_lesson.connect ((index, name) => {
                        on_run_lesson (index, name);
                        header_bar.show_nav_btn (true);
                    });

                    welcome_widget.attach (lessons_widget, 2, 0);
                    break;
                case 1:
                    show_statistic ();
                    break;
            }
        }

        private void show_statistic (uint8 level_index = 0, string course_name = "letters") {
            var stats_widget = new Widgets.Statistic (locale, level_index, course_name);
            add_main_widget (stats_widget);
        }

        private void on_nav_clicked () {
            key_release_event.disconnect (on_key_release);
            init_welcome ();
            header_bar.show_nav_btn (false);
        }

        private void on_menu_select (string row_name) {
            switch (row_name) {
                case "preferences":
                    var preferences = new KeyTutor.Widgets.Preferences (this, locales_list);
                    preferences.change_level.connect (() => {
                        var new_speed = settings.get_int ("speed");
                        var new_accuracy = settings.get_int ("accuracy");
                        db_conn.level_reload (locale, new_speed, new_accuracy);
                        init_welcome ();
                        preferences.destroy ();
                    });
                    preferences.clear_history.connect (() => {
                        db_conn.reset_database ();
                        init_welcome ();
                    });
                    preferences.run ();
                    break;
                case "about":
                    // var about = new KeyTutor.Widgets.About ();
                    // about.show ();
                    break;

            }
        }

        private void on_run_lesson (uint8 index, string course_name) {
            string[]? text_arr = null;

            switch (course_name) {
                case "letters":
                    text_arr = lessons_manager.generate_lesson (index);
                    break;
            }

            if (text_arr != null && text_arr.length > 0) {
                lesson_widget = new Widgets.Lesson (text_arr, lessons_manager.get_chars_map ());
                lesson_widget.end_task.connect ((accuracy, speed) => {
                    lesson_widget = null;
                    key_release_event.disconnect (on_key_release);
                    // write rules for passing
                    bool accuracy_state = accuracy > settings.get_int ("accuracy");
                    bool speed_state = speed > settings.get_int ("speed");
                    var result_widget = new Widgets.Result (accuracy, speed, accuracy_state, speed_state);

                    bool passed_level = (index < (lessons_manager.get_lessons_length () - 1)
                                         && accuracy_state
                                         && speed_state);

                    result_widget.activate_man_btns (index > 0, passed_level);

                    if (passed_level && course_name == "letters" && db_conn.get_level (locale) == index) {
                        db_conn.level_up (locale);
                    }

                    add_main_widget (result_widget);

                    db_conn.add_lesson_result (locale, course_name, index, speed, accuracy);

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
                            case "statistic":
                                show_statistic (index, course_name);
                                break;
                        }
                    });
                });

                add_main_widget (lesson_widget);
                key_release_event.connect (on_key_release);
                // add pause on mouse click
                // button_release_event.connect (on_button_release);
            }
        }

        // private bool on_button_release () {
        //     return true;
        // }

        private bool on_key_release (Gdk.EventKey event) {
            if (event.length > 0 && lesson_widget != null) {
                lesson_widget.key_press_ev (event);
            }

            return true;
        }
    }
}
