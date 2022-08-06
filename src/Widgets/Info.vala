namespace KeyTutor {
    public class Widgets.Info : Gtk.Box {
        private Gtk.Label info_val;

        public string head_name {
            get;
            construct;
        }

        public Info (string h_name) {
            Object (orientation: Gtk.Orientation.VERTICAL,
                    spacing: 10,
                    halign: Gtk.Align.CENTER,
                    head_name: h_name);
        }

        construct {
            get_style_context ().add_class ("info");

            Gtk.Label info_label = new Gtk.Label (head_name);
            info_val = new Gtk.Label ("");

            add (info_label);
            add (info_val);
        }

        public override void get_preferred_width (out int minimum_width, out int natural_width) {
            minimum_width = 250;
            natural_width = 250;
        }

        public void set_new_info (string new_val) {
            info_val.label = @"$new_val";
        }

        public void update_style (bool pass) {
            var s_context = get_style_context ();
            if (s_context.has_class (!pass ? "passed-box" : "failed-box")) {
                s_context.remove_class (!pass ? "passed-box" : "failed-box");
            }

            s_context.add_class (pass ? "passed-box" : "failed-box");
        }
    }
}
