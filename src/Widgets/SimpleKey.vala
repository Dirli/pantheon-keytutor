namespace KeyTutor {
    public class Widgets.SimpleKey : Gtk.Label {
        private int cus_width;
        private int cus_height;

        public SimpleKey (string btn_label, int btn_width = 60) {
            get_style_context ().add_class ("box");
            cus_width = btn_width;
            cus_height = 60;
            label = btn_label;
            valign = halign = Gtk.Align.CENTER;
        }

        public override void get_preferred_width (out int minimum_width, out int natural_width) {
            minimum_width = cus_width;
            natural_width = cus_width;
        }

        public override void get_preferred_height (out int minimum_height, out int natural_height) {
            minimum_height = cus_height;
            natural_height = cus_height;
        }
    }
}
