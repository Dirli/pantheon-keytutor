namespace KeyTutor {
    public class Widgets.Preferences : Gtk.Dialog {
        public signal void change_level ();
        public signal void clear_history ();

        public GLib.Settings settings {
            get;
            construct set;
        }

        public string[] locales_list {
            get;
            construct set;
        }

        private bool changed_level = false;

        public Preferences (KeyTutor.MainWindow window, string[] l_list, GLib.Settings s) {
            Object (resizable: false,
                deletable: false,
                transient_for: window,
                modal: true,
                title: "Preferences",
                locales_list: l_list,
                settings: s);

        }

        construct {
            // set_default_size (300, 150);

            var data_path = "/usr/share/io.elementary.keytutor/layout/";

            //Create UI
            var layout = new Gtk.Grid ();
            layout.valign = Gtk.Align.CENTER;
            layout.column_spacing = 12;
            layout.row_spacing = 12;
            layout.margin = 12;

            Gtk.Label locales_label = new Gtk.Label (_("Locales:"));
            locales_label.halign = Gtk.Align.END;

            var locales_exist = new Gtk.ComboBoxText ();
            locales_exist.halign = Gtk.Align.START;

            Json.Parser parser = new Json.Parser ();
            string locale_name;
            foreach (var locale in locales_list) {
                locale_name = locale;
                try {
                    parser.load_from_file (data_path + @"$locale.json");
                    Json.Node node = parser.get_root ();

                    if (node.get_node_type () == Json.NodeType.OBJECT) {
                        var obj = node.get_object ();
                        locale_name = obj.get_string_member ("name");
                    }

                } catch (Error e) {
                    warning (e.message);
                }

                locales_exist.append (locale, locale_name);
            }

            settings.bind("locale", locales_exist, "active_id", SettingsBindFlags.DEFAULT);

            Gtk.Label accuracy_label = new Gtk.Label (_("Accuracy:"));
            accuracy_label.halign = Gtk.Align.END;
            var accuracy_val = new Gtk.SpinButton.with_range (60, 100, 1);
            settings.bind("accuracy", accuracy_val, "value", SettingsBindFlags.DEFAULT);
            accuracy_val.set_halign (Gtk.Align.START);
            accuracy_val.set_width_chars (3);
            accuracy_val.value_changed.connect (on_value_changed);

            Gtk.Label speed_label = new Gtk.Label (_("Speed:"));
            speed_label.halign = Gtk.Align.END;
            var speed_val = new Gtk.SpinButton.with_range (60, 200, 1);
            settings.bind("speed", speed_val, "value", SettingsBindFlags.DEFAULT);
            speed_val.set_halign (Gtk.Align.START);
            speed_val.set_width_chars (3);
            speed_val.value_changed.connect (on_value_changed);

            var new_str_label = new Gtk.Label (_("Next line:"));
            new_str_label.halign = Gtk.Align.CENTER;
            var new_str_btn = new Granite.Widgets.ModeButton ();
            new_str_btn.hexpand = true;
            new_str_btn.orientation = Gtk.Orientation.HORIZONTAL;
            new_str_btn.append_text ("Auto");
            new_str_btn.append_text ("Space");
            new_str_btn.append_text ("Enter");
            settings.bind("new-line", new_str_btn, "selected", SettingsBindFlags.DEFAULT);

            Gtk.Label errors_label = new Gtk.Label (_("Correction errors"));
            errors_label.halign = Gtk.Align.END;
            var errors_switch = new Gtk.Switch ();
            errors_switch.tooltip_text = _("Require error correction");
            errors_switch.halign = Gtk.Align.START;
            settings.bind ("correct-error", errors_switch, "active", GLib.SettingsBindFlags.DEFAULT);

            layout.attach (locales_label,  0, 0);
            layout.attach (locales_exist,  1, 0);
            layout.attach (accuracy_label, 0, 1);
            layout.attach (accuracy_val,   1, 1);
            layout.attach (speed_label,    0, 2);
            layout.attach (speed_val,      1, 2);
            layout.attach (new_str_label,  0, 3, 2, 1);
            layout.attach (new_str_btn,    0, 4, 2, 1);
            layout.attach (errors_label,   0, 5);
            layout.attach (errors_switch,  1, 5);

            Gtk.Box content = this.get_content_area () as Gtk.Box;
            content.valign = Gtk.Align.START;
            content.border_width = 6;
            content.add (layout);

            //Actions
            var clear_button = add_button (_("Clear"), 1);
            clear_button.tooltip_text = _("Attention, the whole story will be cleared!");
            add_button (_("Close"), Gtk.ResponseType.CLOSE);
            response.connect ((source, response_id) => {
                switch (response_id) {
                    case Gtk.ResponseType.CLOSE:
                        if (changed_level) {
                            change_level ();
                        } else {
                            destroy ();
                        }

                        break;
                    case 1:
                        clear_history ();
                        break;

                }
            });
        }

        private void on_value_changed () {
            changed_level = true;
        }
    }
}
