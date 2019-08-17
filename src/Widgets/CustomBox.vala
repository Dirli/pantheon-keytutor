namespace KeyTutor.Widgets {
    public class CustomBox : Gtk.Box {
        public CustomBox () {
            Object (orientation: Gtk.Orientation.VERTICAL);
            spacing = 20;
            expand = true;
        }

        public override void get_preferred_width (out int minimum_width, out int natural_width) {
            minimum_width = 250;
            natural_width = 300;
        }
    }
}
