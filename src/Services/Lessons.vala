namespace KeyTutor {
    public class Services.Lessons : GLib.Object {
        private Gee.HashMap<uint16, string> keys_map;
        private Gee.HashMap<string, uint16> chars_map;

        private string data_path;

        private string[] lessons_list;
        public string[] get_lessons_list () {
            return lessons_list;
        }

        public Lessons () {
            data_path = "/usr/share/io.elementary.keytutor/layout/";
            keys_map = new Gee.HashMap<uint16, string> ();
            chars_map = new Gee.HashMap<string, uint16> ();
        }

        public int get_lessons_length () {
            return lessons_list.length;
        }

        public Gee.HashMap<uint16, string> get_keys_map () {
            return keys_map;
        }

        public Gee.HashMap<string, uint16> get_chars_map () {
            return chars_map;
        }

        public string[] generate_lesson (uint8 lesson_level) {
            var let_occurrences = "";
            if (lessons_list.length > lesson_level) {
                for (uint8 i = 0; i <= lesson_level; i++) {
                    let_occurrences += lessons_list[i] + "|";
                }
            }

            let_occurrences += " ";

            return get_generated_arr (let_occurrences);
        }

        private string[] get_generated_arr (string letters_occurrences) {
            var let_split = letters_occurrences.split ("|");
            var les_length = let_split.length - 1;
            string[] gen_lesson = new string[3];
            int new_index;
            for (uint8 i = 0; i < 3; i++) {
                string new_str = "";
                int space_counter = GLib.Random.int_range (4, 10);
                int space_iter = 0;

                for (uint8 j = 0; j < 60; j++) {
                    if (space_iter == space_counter) {
                        if (j != 0 && j != 59) {
                            new_str += " ";
                        } else {
                            j--;
                        }

                        space_counter = GLib.Random.int_range (4, 10);
                        space_iter = 0;
                        continue;
                     }

                    space_iter++;

                    new_index = GLib.Random.int_range (0, les_length);
                    new_str += let_split[new_index];
                }

                gen_lesson[i] = new_str;
            }

            return gen_lesson;
        }

        // init common chars_map
        public void generate_keys_map (string locale) {
            keys_map.clear ();
            chars_map.clear ();
            lessons_list = {};

            init_common_btns ();

            Json.Object? locale_object = get_json_object (locale);
            if (locale_object != null) {
                Json.Array letters_list = locale_object.get_array_member ("letters");
                letters_list.foreach_element ((letters_list, index, elem) => {
                    var letter_iter = elem.get_object ();
                    var key_name = letter_iter.get_string_member ("letter");
                    if (key_name != "|") {
                        uint16 key_code = (uint16) letter_iter.get_int_member ("keycode");

                        chars_map[key_name] = key_code;

                        if (letter_iter.has_member ("widget") && letter_iter.get_boolean_member ("widget")) {
                            keys_map[key_code] = key_name;
                        }
                    }
                });


                Json.Object lessons_object = locale_object.get_object_member ("lessons");
                for (uint i = 0; i < lessons_object.get_size (); i++) {
                    lessons_list += lessons_object.get_string_member (i.to_string ());
                }
            }
        }

        private Json.Object? get_json_object (string locale) {
            Json.Parser parser = new Json.Parser ();
            try {
                parser.load_from_file (data_path + @"$locale.json");
                Json.Node node = parser.get_root ();

                if (node.get_node_type () == Json.NodeType.OBJECT) {
                    return node.get_object ();
                }

            } catch (Error e) {
                warning (e.message);
            }

            return null;
        }

        private void init_common_btns () {
             keys_map[49] = "~";
             keys_map[10] = "1";
             keys_map[11] = "2";
             keys_map[12] = "3";
             keys_map[13] = "4";
             keys_map[14] = "5";
             keys_map[15] = "6";
             keys_map[16] = "7";
             keys_map[17] = "8";
             keys_map[18] = "9";
             keys_map[19] = "0";
             keys_map[20] = "-";
             keys_map[21] = "=";
             keys_map[22] = "Backspace";
             keys_map[23] = "Tab";
             keys_map[66] = "CapsLock";
             keys_map[36] = "Enter";
             keys_map[50] = "Shift";
             keys_map[62] = "Shift";
             keys_map[37] = "Ctrl";
             keys_map[64] = "Alt";
             keys_map[65] = "Space";
             chars_map[" "] = 65;
             keys_map[113] = "Alt";
             keys_map[105] = "Ctrl";
         }
    }
}
