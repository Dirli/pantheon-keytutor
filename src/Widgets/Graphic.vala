namespace KeyTutor {
    public class Widgets.Graphic : Gtk.Grid {
        private const int HEIGHT_SIZE = 400;
        private const int WIDTH_SIZE = 800;
        private const int PADDING_SIZE = 30;

        private const int RIGHT_PADDING = 770;
        private const int BOTTOM_PADDING = 370;

        private double[] coords_arr;
        private Gtk.DrawingArea drawing_area;
        private Granite.Widgets.ModeButton type_box;

        public signal void changed_type (int type_index);

        private LevelResults[] level_results;

        public Graphic (LevelResults[] level_results, int act_index = 0) {
            Object (row_spacing: 5,
                    expand: true,
                    halign: Gtk.Align.CENTER,
                    valign: Gtk.Align.CENTER);

            this.level_results = level_results;

            type_box = new Granite.Widgets.ModeButton ();
            type_box.orientation = Gtk.Orientation.HORIZONTAL;
            type_box.halign = Gtk.Align.END;

            type_box.append_text ("Speed");
            type_box.append_text ("Accuracy");
            type_box.mode_changed.connect (toggled_type);

            attach (type_box, 0, 0);
            show_all ();

            type_box.selected = act_index;
        }

        private unowned void toggled_type () {
            var exist_widget = get_child_at (0, 1);
            if (exist_widget != null) {
                exist_widget.destroy ();
            }

            coords_arr = {};

            int selected_type = type_box.selected;

            changed_type (selected_type);

            for (uint i = 0; i < level_results.length; i++) {
                if (selected_type == 0) {
                    coords_arr += level_results[i].speed;
                } else {
                    coords_arr += level_results[i].accuracy;
                }
            }

            drawing_area = new Gtk.DrawingArea ();
            drawing_area.set_size_request (WIDTH_SIZE, HEIGHT_SIZE);
            drawing_area.halign = Gtk.Align.CENTER;
            drawing_area.valign = Gtk.Align.CENTER;
            drawing_area.draw.connect (on_draw);

            attach (drawing_area, 0, 1);
            drawing_area.show_all ();
        }

        private bool on_draw (Cairo.Context ctx) {
            ctx.set_source_rgb (0, 0, 0);
            ctx.set_line_width (2);
            ctx.rectangle (0, 0, WIDTH_SIZE, HEIGHT_SIZE);
            ctx.fill ();

            ctx.set_source_rgb (1, 1, 1);

            ctx.move_to (PADDING_SIZE, PADDING_SIZE);
            ctx.line_to (PADDING_SIZE, BOTTOM_PADDING);
            ctx.line_to (RIGHT_PADDING, BOTTOM_PADDING);
            ctx.move_to (PADDING_SIZE, PADDING_SIZE);
            ctx.line_to (PADDING_SIZE - 5, PADDING_SIZE + 10);
            ctx.move_to (PADDING_SIZE, PADDING_SIZE);
            ctx.line_to (PADDING_SIZE + 5, PADDING_SIZE + 10);
            ctx.move_to (RIGHT_PADDING, BOTTOM_PADDING);
            ctx.line_to (RIGHT_PADDING - 10, BOTTOM_PADDING - 5);
            ctx.move_to (RIGHT_PADDING, BOTTOM_PADDING);
            ctx.line_to (RIGHT_PADDING - 10, BOTTOM_PADDING + 5);

            ctx.stroke ();

            int max_coord = get_coords ();
            int iter_coord = max_coord / 5;

            // horizontal grid and text
            int inc = 0;
            int coord_text = 0;
            while (340 - inc > 60) {
                inc += 60;
                coord_text += iter_coord;
                add_basetext_coords (ctx, inc, coord_text.to_string ());
                add_grid (ctx, Gtk.Orientation.HORIZONTAL, inc);
            }

            // vertical grid
            inc = 0;
            while (740 - inc > 60) {
                inc += 60;
                add_grid (ctx, Gtk.Orientation.VERTICAL, inc);
            }

            ctx.set_source_rgb (1, 0, 0);

            int point_y;
            double coord_proc;
            int point_x = PADDING_SIZE;
            for (uint i = 0; i < coords_arr.length; i++) {
                coord_proc = GLib.Math.round (coords_arr[i] * 100.0 / max_coord);
                point_y = HEIGHT_SIZE - PADDING_SIZE - 3* (int) coord_proc;
                if (i == 0) {
                    ctx.move_to (point_x, point_y);
                } else {
                    point_x += 30;
                    ctx.line_to (point_x, point_y);
                }
            }

            ctx.stroke ();

            return false;
        }


        private void add_basetext_coords (Cairo.Context ctx, int increment, string base_text) {
            ctx.save ();
            ctx.select_font_face ("Adventure", Cairo.FontSlant.NORMAL, Cairo.FontWeight.NORMAL);
            ctx.set_font_size (11);

            ctx.move_to (3, BOTTOM_PADDING - increment);
            ctx.show_text (base_text);

            ctx.stroke ();
            ctx.restore ();
        }

        private void add_grid (Cairo.Context ctx, Gtk.Orientation orient, int inc) {
            ctx.save ();
            ctx.set_dash ({2, 2}, 0);
            ctx.set_line_width (0.8);
            ctx.set_source_rgba (1, 1, 1, 0.5);

            if (orient == Gtk.Orientation.HORIZONTAL) {
                ctx.move_to (PADDING_SIZE, BOTTOM_PADDING - inc);
                ctx.line_to (RIGHT_PADDING, BOTTOM_PADDING - inc);
            } else {
                ctx.move_to (PADDING_SIZE + inc, PADDING_SIZE);
                ctx.line_to (PADDING_SIZE + inc, BOTTOM_PADDING);
            }

            ctx.stroke ();
            ctx.restore ();
        }

        private int get_coords () {
            double min_val, max_val;
            int max_coord;
            if (coords_arr.length > 0) {
                min_val = max_val = coords_arr[0];
                for (uint i = 0; i < coords_arr.length; i++) {
                    min_val = double.min (min_val, coords_arr[i]);
                    max_val = double.max (max_val, coords_arr[i]);
                }

                max_coord = (int) (GLib.Math.round (max_val/50.0) * 50);

                if (max_val > max_coord) {
                    if (max_val > max_coord + max_coord * 0.1) {
                        max_coord += 50;
                    }
                }
                return max_coord;
            } else {
                return 100;
            }
        }
    }
}
