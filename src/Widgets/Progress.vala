namespace KeyTutor {
    public class Widgets.Progress : Gtk.Grid {
        private Widgets.CustomMButton letters_btn;
        private int type_index;
        private string locale;

        public Progress (string locale, uint8 level_index, string course_name) {
            row_spacing = 15;
            halign = Gtk.Align.CENTER;
            type_index = 0;
            this.locale = locale;

            var letters_label = new Gtk.Label (_("Letters"));

            letters_btn = new Widgets.CustomMButton ();
            letters_btn.orientation = Gtk.Orientation.HORIZONTAL;

            string[] lessons_list = Services.Lessons.get_default ().get_lessons_list ();

            for (uint8 i = 0; i < lessons_list.length; i++) {
                letters_btn.append_text ("%2.2u".printf (i + 1), lessons_list[i]);
            }

            Gtk.Box letters_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
            letters_box.valign = Gtk.Align.START;
            letters_box.halign = Gtk.Align.CENTER;
            letters_box.add (letters_label);
            letters_box.add (letters_btn);

            attach (letters_box, 0, 0);
            letters_btn.mode_changed.connect (toggled_letters);

            letters_btn.selected = level_index;
        }

        private void create_graphic (LevelResults[] results) {
            var exist_widget = get_child_at (0, 2);
            if (exist_widget != null) {
                exist_widget.destroy ();
            }

            var graphic_widget = new Widgets.Graphic (results, type_index);
            graphic_widget.changed_type.connect ((new_index) => {
                type_index = new_index;
            });

            graphic_widget.valign = Gtk.Align.CENTER;
            attach (graphic_widget, 0, 2);
        }

        private unowned void toggled_letters () {
            var level_res = Services.DBManager.get_default ().get_lesson_results (locale,
                                                                                  "letters",
                                                                                  (uint8) letters_btn.selected);
            create_graphic (level_res);
        }
    }
}
