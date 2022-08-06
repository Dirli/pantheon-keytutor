namespace KeyTutor {
    public class Views.Welcome : Gtk.Box {
        public signal void welcome_activate (int index);

        private Granite.Widgets.Welcome welcome;

        public Welcome () {
            Object (orientation: Gtk.Orientation.HORIZONTAL,
                    spacing: 10);
        }

        construct {
            welcome = new Granite.Widgets.Welcome (_("Keyboard tutor"), _("Trains typing skills on the keyboard."));
            welcome.append ("media-playback-start", "Run exercise", "Start improving your skills");
            welcome.append ("keytutor-graphic", "Show statistic", "Here you can follow your progress.");

            welcome.activated.connect ((index) => {
                welcome_activate (index);
            });

            add (welcome);
            add (new Gtk.Separator (Gtk.Orientation.VERTICAL));
        }

        public void set_activate (int val) {
            welcome.activated (val);
        }
    }
}
