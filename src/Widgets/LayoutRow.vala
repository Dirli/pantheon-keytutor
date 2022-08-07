namespace KeyTutor {
    public class Widgets.LayoutRow : Gtk.ListBoxRow {
        private Gtk.Image lock_icon = null;

        public LayoutRow (string t_name, bool lock_row = false) {
            Gtk.Label row_label = new Gtk.Label (t_name);

            var row_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10) {
                margin_start = 12,
                margin_end = 12,
                margin_top = 6,
                margin_bottom = 6
            };

            row_box.add (row_label);

            if (lock_row) {
                sensitive = false;
                lock_icon = new Gtk.Image.from_icon_name ("system-lock-screen-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
                row_box.add (lock_icon);
            }

            add (row_box);
        }

        public void set_active () {
            if (lock_icon != null) {
                lock_icon.destroy ();
            }

            sensitive = true;
        }

    }
}
