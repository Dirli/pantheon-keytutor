namespace KeyTutor {
    public class Services.Lessons : GLib.Object {
        private Gee.HashMap<uint16, string> keys_map;

        private string[] lessons_list;
        public string[] get_lessons_list () {
            return lessons_list;
        }

        private static Lessons? instance = null;
        public static Lessons get_default () {
            if (instance == null) {instance = new Lessons ();}
            return instance;
        }

        private Lessons () {
            keys_map = new Gee.HashMap<uint16, string> ();
        }

        public int lessons_length () {
            return lessons_list.length;
        }

        public Gee.HashMap<uint16, string> get_keys_map () {
            return keys_map;
        }

        public Gee.HashMap<string, uint16> get_chars_map () {
            var chars_map = new Gee.HashMap<string, uint16> ();

            keys_map.foreach ((k_entry) => {
                chars_map[k_entry.value] = k_entry.key;
                return true;
            });

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
chars_map
        public void generate_keys_map () {
            keys_map.clear ();
            lessons_list = {};

            init_common_btns ();

            Json.Object? locale_object = get_json_object ();
            if (locale_object != null) {
                Json.Array letters_list = locale_object.get_array_member ("letters");
                letters_list.foreach_element ((letters_list, index, elem) => {
                    var letter_iter = elem.get_object ();
                    if (letter_iter.get_string_member ("letter") != "|") {

                        if (letter_iter.has_member ("widget") && letter_iter.get_boolean_member ("widget")) {
                            uint16 key_code = (uint16) letter_iter.get_int_member ("keycode");
                            keys_map[key_code] = letter_iter.get_string_member ("letter");
                        }
                    }
                });

                Json.Object lessons_object = locale_object.get_object_member ("lessons");
                for (uint i = 0; i < lessons_object.get_size (); i++) {
                    lessons_list += lessons_object.get_string_member (i.to_string ());
                }
            }
        }

        //will read from json-files
        private Json.Object? get_json_object () {
            string data ="""
                {
                    "letters" : [
                        { "letter": "A", "keycode": 38, "widget": true},
                        { "letter": "a", "keycode": 38, "finger": 1},
                        { "letter": "B", "keycode": 56, "widget": true},
                        { "letter": "b", "keycode": 56, "finger": 4},
                        { "letter": "C", "keycode": 54, "widget": true},
                        { "letter": "c", "keycode": 54, "finger": 3},
                        { "letter": "D", "keycode": 40, "widget": true},
                        { "letter": "d", "keycode": 40, "finger": 3},
                        { "letter": "E", "keycode": 26, "widget": true},
                        { "letter": "e", "keycode": 26, "finger": 3},
                        { "letter": "F", "keycode": 41, "widget": true},
                        { "letter": "f", "keycode": 41, "finger": 4},
                        { "letter": "G", "keycode": 42, "widget": true},
                        { "letter": "g", "keycode": 42, "finger": 4},
                        { "letter": "H", "keycode": 43, "widget": true},
                        { "letter": "h", "keycode": 43, "finger": 5},
                        { "letter": "I", "keycode": 31, "widget": true},
                        { "letter": "i", "keycode": 31, "finger": 6},
                        { "letter": "J", "keycode": 44, "widget": true},
                        { "letter": "j", "keycode": 44, "finger": 5},
                        { "letter": "K", "keycode": 45, "widget": true},
                        { "letter": "k", "keycode": 45, "finger": 6},
                        { "letter": "L", "keycode": 46, "widget": true},
                        { "letter": "l", "keycode": 46, "finger": 7},
                        { "letter": "M", "keycode": 58, "widget": true},
                        { "letter": "m", "keycode": 58, "finger": 5},
                        { "letter": "N", "keycode": 57, "widget": true},
                        { "letter": "n", "keycode": 57, "finger": 5},
                        { "letter": "O", "keycode": 32, "widget": true},
                        { "letter": "o", "keycode": 32, "finger": 7},
                        { "letter": "P", "keycode": 33, "widget": true},
                        { "letter": "p", "keycode": 33, "finger": 8},
                        { "letter": "Q", "keycode": 24, "widget": true},
                        { "letter": "q", "keycode": 24, "finger": 1},
                        { "letter": "R", "keycode": 27, "widget": true},
                        { "letter": "r", "keycode": 27, "finger": 4},
                        { "letter": "S", "keycode": 39, "widget": true},
                        { "letter": "s", "keycode": 39, "finger": 2},
                        { "letter": "T", "keycode": 28, "widget": true},
                        { "letter": "t", "keycode": 28, "finger": 4},
                        { "letter": "U", "keycode": 30, "widget": true},
                        { "letter": "u", "keycode": 30, "finger": 5},
                        { "letter": "V", "keycode": 55, "widget": true},
                        { "letter": "v", "keycode": 55, "finger": 4},
                        { "letter": "W", "keycode": 25, "widget": true},
                        { "letter": "w", "keycode": 25, "finger": 2},
                        { "letter": "X", "keycode": 53, "widget": true},
                        { "letter": "x", "keycode": 53, "finger": 2},
                        { "letter": "Y", "keycode": 29, "widget": true},
                        { "letter": "y", "keycode": 29, "finger": 5},
                        { "letter": "Z", "keycode": 52, "widget": true},
                        { "letter": "z", "keycode": 52, "finger": 1},
                        { "letter": "[", "keycode": 34, "finger": 8, "widget": true},
                        { "letter": "{", "keycode": 34},
                        { "letter": "]", "keycode": 35, "finger": 8, "widget": true},
                        { "letter": "}", "keycode": 35},
                        { "letter": ",", "keycode": 59, "finger": 6, "widget": true, "punctuation": true},
                        { "letter": "<", "keycode": 59},
                        { "letter": ".", "keycode": 60, "finger": 7, "widget": true, "punctuation": true},
                        { "letter": ">", "keycode": 60},
                        { "letter": "/", "keycode": 61, "finger": 8, "widget": true},
                        { "letter": "?", "keycode": 61, "punctuation": true},
                        { "letter": "\\", "keycode": 51, "finger": 8, "widget": true},
                        { "letter": ";", "keycode": 47, "finger": 8, "widget": true, "punctuation": true},
                        { "letter": ":", "keycode": 47, "finger": 8, "punctuation": true},
                        { "letter": "'", "keycode": 48, "finger": 8, "widget": true, "punctuation": true}
                    ],
                    "lessons" : {
                        "0": "f|j",
                        "1": "d|k",
                        "2": "s|l",
                        "3": "a|p",
                        "4": "r|u",
                        "5": "e|i",
                        "6": "w|o",
                        "7": "q|z",
                        "8": "x|c",
                        "9": "v|m",
                        "10": "g|h",
                        "11": "b|n",
                        "12": "t|y"
                    }
                }
            """;

            Json.Parser parser = new Json.Parser ();
            try {
                parser.load_from_data (data);
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
             keys_map[113] = "Alt";
             keys_map[105] = "Ctrl";
         }
    }
}
