namespace KeyTutor {
    public class Widgets.Welcome : Gtk.Grid {
        public signal void welcome_activate (int index);

        private Granite.Widgets.Welcome welcome;

        public Welcome () {
            welcome = new Granite.Widgets.Welcome (_("Keyboard tutor"), _("Trains typing skills on the keyboard."));
            welcome.activated.connect ((index) => {
                var exist_widget = get_child_at (2, 0);
                if (exist_widget != null) {
                    exist_widget.destroy ();
                }

                welcome_activate (index);
            });


            attach (welcome, 0, 0);
            attach (new Gtk.Separator (Gtk.Orientation.VERTICAL), 1, 0);
        }


    }
}
