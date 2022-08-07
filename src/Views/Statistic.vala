namespace KeyTutor {
    public class Views.Statistic : Gtk.Box {
        public signal void change_level (int l);

        private Widgets.CustomMButton letters_btn;
        private Widgets.Graphic graphic_widget;

        private LevelResults[] level_results;

        private Granite.Widgets.ModeButton type_box;

        public Statistic () {
            Object (orientation: Gtk.Orientation.VERTICAL,
                    spacing: 20,
                    expand: true,
                    margin: 20,
                    valign: Gtk.Align.FILL,
                    halign: Gtk.Align.FILL);
        }

        construct {
            letters_btn = new Widgets.CustomMButton () {
                orientation = Gtk.Orientation.HORIZONTAL
            };

            Gtk.Box letters_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
            letters_box.valign = Gtk.Align.START;
            letters_box.halign = Gtk.Align.CENTER;
            letters_box.add (new Gtk.Label (_("Letters")));
            letters_box.add (letters_btn);


            type_box = new Granite.Widgets.ModeButton () {
                orientation = Gtk.Orientation.HORIZONTAL,
                halign = Gtk.Align.CENTER,
                valign = Gtk.Align.END
            };

            type_box.append_text ("Speed");
            type_box.append_text ("Accuracy");
            type_box.selected = 0;
            type_box.mode_changed.connect (on_changed_type);

            graphic_widget = new Widgets.Graphic ();

            add (letters_box);
            add (type_box);
            add (graphic_widget);

            letters_btn.mode_changed.connect (() => {
                change_level (letters_btn.selected);
            });
        }

        private void on_changed_type () {
            double[] vals = {};
            foreach (LevelResults r in level_results) {
                if (type_box.selected == 0) {
                    vals += r.speed;
                } else {
                    vals += r.accuracy;
                }
            }

            graphic_widget.update_result (vals);
        }

        public void init_tasks_list (string[] tasks_list) {
            letters_btn.clear_children ();

            for (uint8 i = 0; i < tasks_list.length; i++) {
                letters_btn.append_text ("%2.2u".printf (i + 1), tasks_list[i]);
            }
        }

        public void select_level (int lev) {
            letters_btn.selected = lev;
        }

        public void show_statistic (LevelResults[] l_res) {
            level_results = l_res;
            on_changed_type ();
        }
    }
}
