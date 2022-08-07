namespace KeyTutor {
    public class MainWindow : Gtk.Window {
        private Gtk.Stack main_stack;
        private Gtk.Box welcome_view;

        private Views.Task task_view;
        private Views.Result result_view;
        private Views.Statistic stats_view;

        private Widgets.Tasks tasks_widget;
        private Widgets.Header header_bar;

        private GLib.Settings settings;
        private Services.DBManager db_conn;
        private Services.Lessons lessons_manager;

        private string[] locales_list;
        private string locale;

        public MainWindow (KeyTutorApp app) {
            Object (window_position: Gtk.WindowPosition.CENTER,
                    application: app);
        }

        construct {
            set_default_size (1150, 650);
            set_size_request (1150, 650);

            Gtk.CssProvider provider = new Gtk.CssProvider();
            provider.load_from_resource ("/io/elementary/keytutor/application.css");
            Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            Gtk.IconTheme.get_default().add_resource_path("/io/elementary/keytutor/icons");

            db_conn = new Services.DBManager ();
            lessons_manager = new Services.Lessons ();

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

            settings = new GLib.Settings ("io.elementary.keytutor");
            if (!(settings.get_string ("locale") in locales_list)) {
                settings.set_string ("locale", "en");
            }

            header_bar = new Widgets.Header ();
            header_bar.back_clicked.connect (on_back_clicked);
            header_bar.show_preferences.connect (on_show_preferences);

            set_titlebar (header_bar);

            var welcome_widget = new Granite.Widgets.Welcome (_("Keyboard tutor"), _("Trains typing skills on the keyboard."));
            welcome_widget.append ("media-playback-start", "Run exercise", "Start improving your skills");
            welcome_widget.append ("keytutor-graphic", "Show statistic", "Here you can follow your progress.");
            welcome_widget.activated.connect (on_welcome_activate);

            tasks_widget = new Widgets.Tasks ();

            welcome_view = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);

            welcome_view.add (welcome_widget);
            welcome_view.add (new Gtk.Separator (Gtk.Orientation.VERTICAL));
            welcome_view.add (tasks_widget);

            var size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
            size_group.add_widget (welcome_widget);
            size_group.add_widget (tasks_widget);

            task_view = new Views.Task ();
            task_view.end_task.connect (on_end_task);

            result_view = new Views.Result ();
            result_view.choosed_action.connect (on_choosed_action);

            stats_view = new Views.Statistic ();
            stats_view.change_level.connect (change_stats_level);

            main_stack = new Gtk.Stack () {
                transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT
            };

            main_stack.add_named (welcome_view, "welcome");
            main_stack.add_named (task_view, "task");
            main_stack.add_named (result_view, "result");
            main_stack.add_named (stats_view, "stats");

            main_stack.notify["visible-child-name"].connect (on_changed_child);

            on_locale_change ();
            add (main_stack);

            GLib.Idle.add (() => {
                header_bar.show_nav_btn (false);
                return false;
            });

            settings.changed["locale"].connect (on_locale_change);
        }

        private void on_locale_change () {
            locale = settings.get_string ("locale");
            lessons_manager.generate_keys_map (locale);

            task_view.init_keyboard (lessons_manager.get_chars_map (),
                                     lessons_manager.get_keys_map ());

            var tasks_list = lessons_manager.get_lessons_list ();

            tasks_widget.update_tasks_list (tasks_list, db_conn.get_level (locale));
            stats_view.init_tasks_list (tasks_list);
        }

        private void on_changed_child () {
            var w_name = main_stack.get_visible_child_name ();
            if (w_name == null) {
                return;
            }

            header_bar.show_nav_btn (w_name != "welcome");
        }

        private void on_welcome_activate (int index) {
            switch (index) {
                case 0:
                    run_task ();
                    break;
                case 1:
                    stats_view.select_level (0);
                    break;
            }
        }

        private void on_back_clicked () {
            key_release_event.disconnect (on_key_release);

            var w_name = main_stack.get_visible_child_name ();
            if (w_name != null && w_name == "task") {
                task_view.reset_state ();
            }

            main_stack.set_visible_child_name ("welcome");
        }

        private void on_show_preferences () {
            var preferences = new KeyTutor.Widgets.Preferences (this, locales_list, settings);
            preferences.change_level.connect (() => {
                var new_speed = settings.get_int ("speed");
                var new_accuracy = settings.get_int ("accuracy");
                db_conn.level_reload (locale, new_speed, new_accuracy);
                //
                preferences.destroy ();
            });
            preferences.clear_history.connect (() => {
                db_conn.reset_database ();
                //
            });

            preferences.show_all ();
            preferences.run ();
        }

        private void on_choosed_action (string action) {
            switch (action) {
                case "next":
                    tasks_widget.select_task (1);
                    run_task ();
                    break;
                case "previous":
                    tasks_widget.select_task (-1);
                    run_task ();
                    break;
                case "repeat":
                    run_task ();
                    break;
                case "statistic":
                    var task_index = tasks_widget.get_selected_task ();
                    change_stats_level (int.max (task_index, 0));
                    break;
            }
        }

        private void on_end_task (double accuracy, uint16 speed) {
            key_release_event.disconnect (on_key_release);

            // write rules for passing
            bool accuracy_state = accuracy > settings.get_int ("accuracy");
            bool speed_state = speed > settings.get_int ("speed");

            var task_index = tasks_widget.get_selected_task ();
            var task_type = tasks_widget.get_task_type ();
            bool passed_level = db_conn.get_level (locale) > task_index
                                ? true
                                : (task_index < (lessons_manager.get_lessons_length () - 1) && accuracy_state && speed_state);

            result_view.update_info (accuracy, speed, accuracy_state, speed_state);
            result_view.activate_man_btns (task_index > 0, passed_level);

            if (passed_level && task_type == "letters" && db_conn.get_level (locale) == task_index) {
                db_conn.level_up (locale);
                tasks_widget.open_next_task (task_index + 1);
            }

            main_stack.set_visible_child_name ("result");

            db_conn.add_lesson_result (locale, task_type, (uint8) task_index, speed, accuracy);
        }

        private void change_stats_level (int l) {
            var level_res = db_conn.get_lesson_results (locale, "letters", (uint8) l);
            stats_view.show_statistic (level_res);

            main_stack.set_visible_child_name ("stats");
        }

        private void run_task () {
            var task_index = tasks_widget.get_selected_task ();

            if (task_index < 0) {
                return;
            }

            string[]? text_arr = null;
            switch (tasks_widget.get_task_type ()) {
                case "letters":
                    text_arr = lessons_manager.generate_lesson ((uint8) task_index);
                    break;
            }

            if (text_arr != null && text_arr.length > 0 && task_view.set_task_body (text_arr)) {
                key_release_event.connect (on_key_release);
                // add pause on mouse click
                // button_release_event.connect (on_button_release);

                main_stack.set_visible_child_name ("task");
            }
        }

        // private bool on_button_release () {
        //     return true;
        // }

        private bool on_key_release (Gdk.EventKey event) {
            if (event.length > 0) {
                task_view.key_press_ev (event);
            }

            return true;
        }
    }
}
