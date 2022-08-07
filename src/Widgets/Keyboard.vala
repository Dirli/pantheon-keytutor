namespace KeyTutor {
    public class Widgets.Keyboard : Gtk.Box {
        private Gee.HashMap<uint16, Widgets.SimpleKey> keys_map;

        private Gtk.Box line1;
        private Gtk.Box line2;
        private Gtk.Box line3;
        private Gtk.Box line4;
        private Gtk.Box line5;

        public Keyboard () {
            Object (orientation: Gtk.Orientation.VERTICAL,
                    valign: Gtk.Align.END,
                    halign: Gtk.Align.CENTER,
                    spacing: 8);
        }

        construct {
            keys_map = new Gee.HashMap<uint16, Widgets.SimpleKey> ();

            line1 = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8);
            line2 = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8);
            line3 = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8);
            line4 = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8);
            line5 = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 8);

            add (line1);
            add (line2);
            add (line3);
            add (line4);
            add (line5);
        }

        public void select_press_btn (uint16 keycode) {
            if (keys_map.has_key (keycode)) {
                keys_map[keycode].get_style_context ().add_class ("key-cur");
            }
        }

        public void unselect_release_btn (uint16 keycode) {
            if (keys_map.has_key (keycode)) {
                keys_map[keycode].get_style_context ().remove_class ("key-cur");
            }
        }

        private void clear_line (Gtk.Box line) {
            line.@foreach ((w) => {
                w.destroy ();
            });
        }

        public void init_keys (Gee.HashMap<uint16, string> k_map) {
            clear_line (line1);
            string[] line_keys = {"49:60", "10:60", "11:60", "12:60", "13:60", "14:60", "15:60", "16:60", "17:60", "18:60", "19:60", "20:60", "21:60", "22:120"};
            for (uint8 i = 0; i < line_keys.length; i++) {
                var key_desc = line_keys[i].split (":");
                uint16 key_uint = (uint16) int.parse (key_desc[0]);
                var key_btn = new SimpleKey (k_map[key_uint], int.parse (key_desc[1]));
                keys_map[key_uint] = key_btn;
                line1.add (key_btn);
            }

            clear_line (line2);
            line_keys = {"23:90", "24:60", "25:60", "26:60", "27:60", "28:60", "29:60", "30:60", "31:60", "32:60", "33:60", "34:60", "35:60", "51:90"};
            for (uint8 i = 0; i < line_keys.length; i++) {
                var key_desc = line_keys[i].split (":");
                uint16 key_uint = (uint16) int.parse (key_desc[0]);
                var key_btn = new SimpleKey (k_map[key_uint], int.parse (key_desc[1]));
                keys_map[key_uint] = key_btn;
                line2.add (key_btn);
            }

            clear_line (line3);
            line_keys = {"66:115", "38:60", "39:60", "40:60", "41:60", "42:60", "43:60", "44:60", "45:60", "46:60", "47:60", "48:60", "36:133"};
            for (uint8 i = 0; i < line_keys.length; i++) {
                var key_desc = line_keys[i].split (":");
                uint16 key_uint = (uint16) int.parse (key_desc[0]);
                var key_btn = new SimpleKey (k_map[key_uint], int.parse (key_desc[1]));
                keys_map[key_uint] = key_btn;
                line3.add (key_btn);
            }

            clear_line (line4);
            line_keys = {"50:140", "52:60", "53:60", "54:60", "55:60", "56:60", "57:60", "58:60", "59:60", "60:60", "61:60", "62:176"};
            for (uint8 i = 0; i < line_keys.length; i++) {
                var key_desc = line_keys[i].split (":");
                uint16 key_uint = (uint16) int.parse (key_desc[0]);
                var key_btn = new SimpleKey (k_map[key_uint], int.parse (key_desc[1]));
                keys_map[key_uint] = key_btn;
                line4.add (key_btn);
            }

            clear_line (line5);
            line_keys = {"37:128", "64:120", "65:476", "113:120", "105:128"};
            for (uint8 i = 0; i < line_keys.length; i++) {
                var key_desc = line_keys[i].split (":");
                uint16 key_uint = (uint16) int.parse (key_desc[0]);
                var key_btn = new SimpleKey (k_map[key_uint], int.parse (key_desc[1]));
                keys_map[key_uint] = key_btn;
                line5.add (key_btn);
            }

            show_all ();
        }
    }
}
