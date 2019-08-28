namespace KeyTutor {
    public class Widgets.Header : Gtk.HeaderBar {
        public signal void nav_clicked ();
        public signal void menu_select (string row_name);

        private Gtk.Button nav_button;

        construct {
            show_close_button = true;
            has_subtitle = false;
            title = "KeyTutor";
        }

        public Header () {
            nav_button = new Gtk.Button ();
            nav_button.can_focus = false;
            nav_button.label = "back";
            nav_button.valign = Gtk.Align.CENTER;
            nav_button.vexpand = false;
            nav_button.get_style_context ().add_class ("back-button");
            nav_button.clicked.connect (() => {
                nav_button.hide ();
                nav_clicked ();
            });

            //Create menu
            Gtk.Menu menu = new Gtk.Menu ();
            var pref_item = new Gtk.MenuItem.with_label (_("Preferences"));
            var about_item = new Gtk.MenuItem.with_label (_("About"));
            menu.add (pref_item);
            menu.add (about_item);
            pref_item.activate.connect (() => {
                menu_select ("preferences");
            });
            about_item.activate.connect (() => {
                menu_select ("about");
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
