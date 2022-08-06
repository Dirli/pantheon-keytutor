namespace KeyTutor {
    public class Widgets.Header : Gtk.HeaderBar {
        public signal void back_clicked ();
        public signal void show_preferences ();

        private Gtk.Button nav_button;

        public Header () {
            Object (show_close_button: true,
                    has_subtitle: false,
                    title: "KeyTutor");
        }

        construct {
            nav_button = new Gtk.Button.with_label ("back") {
                valign = Gtk.Align.CENTER,
                can_focus = false,
                vexpand = false
            };
            nav_button.get_style_context ().add_class (Granite.STYLE_CLASS_BACK_BUTTON);
            nav_button.clicked.connect (() => {
                back_clicked ();
            });

            //Create menu
            Gtk.Menu menu = new Gtk.Menu ();
            var pref_item = new Gtk.MenuItem.with_label (_("Preferences"));
            var about_item = new Gtk.MenuItem.with_label (_("About"));
            menu.add (pref_item);
            menu.add (about_item);

            pref_item.activate.connect (() => {
                show_preferences ();
            });
            about_item.activate.connect (() => {
                // var about = new KeyTutor.Widgets.About ();
                // about.show ();
            });

            var menu_button = new Gtk.MenuButton ();
            menu_button.popup = menu;
            menu_button.tooltip_text = _("Menu");
            menu_button.image = new Gtk.Image.from_icon_name ("open-menu-symbolic", Gtk.IconSize.BUTTON);
            menu.show_all ();

            pack_start (nav_button);
            pack_end (menu_button);
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
