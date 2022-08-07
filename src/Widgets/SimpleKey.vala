namespace KeyTutor {
    public class Widgets.SimpleKey : Gtk.Label {
        private int cus_height;
        public int cus_width {
            get;
            construct set;
        }

        public SimpleKey (string btn_label, int btn_width = 60) {
            Object (cus_width: btn_width,
                    label: btn_label,
                    valign: Gtk.Align.CENTER,
                    halign: Gtk.Align.CENTER);
        }

        construct {
            get_style_context ().add_class ("box");
            cus_height = 60;
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
