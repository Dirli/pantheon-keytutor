namespace KeyTutor {
    public class Widgets.Graphic : Gtk.DrawingArea {
        private const int HEIGHT_SIZE = 400;
        private const int WIDTH_SIZE = 800;
        private const int PADDING_SIZE = 30;
        private const int RIGHT_PADDING = 770;
        private const int BOTTOM_PADDING = 370;


        // private int selected_type = 0;
        // private LevelResults[] level_results;

        private double[] coords;

        public Graphic () {
            Object (expand: true,
                    halign: Gtk.Align.CENTER,
                    valign: Gtk.Align.CENTER);
        }

        construct {
            coords = {};

            set_size_request (WIDTH_SIZE, HEIGHT_SIZE);
            draw.connect (on_draw);
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
            for (uint i = 0; i < coords.length; i++) {
                coord_proc = GLib.Math.round (coords[i] * 100.0 / max_coord);
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

        public void update_result (double[] r) {
            coords = r;

            queue_draw ();
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
            if (coords.length > 0) {
                min_val = max_val = coords[0];
                for (uint i = 0; i < coords.length; i++) {
                    min_val = double.min (min_val, coords[i]);
                    max_val = double.max (max_val, coords[i]);
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
