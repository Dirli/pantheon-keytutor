namespace KeyTutor {
    public class Widgets.Tasks : Gtk.Box {
        private Gtk.Stack tasks_stack;
        private Gtk.ListBox task_letters;

        public Tasks () {
            Object (orientation: Gtk.Orientation.VERTICAL,
                    spacing: 20,
                    margin_top: 30,
                    margin_bottom: 30);
        }

        construct {
            task_letters = new Gtk.ListBox () {
                // expand = true,
                selection_mode = Gtk.SelectionMode.BROWSE
            };

            tasks_stack = new Gtk.Stack ();
            tasks_stack.get_style_context ().add_class ("lessons-list");
            tasks_stack.add_titled (task_letters, "letters", _("Letters"));

            var stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.halign = Gtk.Align.CENTER;
            stack_switcher.valign = Gtk.Align.START;
            // stack_switcher.homogeneous = true;
            // stack_switcher.margin_top = 12;
            stack_switcher.stack = tasks_stack;

            var tasks_scrolled = new Gtk.ScrolledWindow (null, null) {
                margin_start = 12,
                margin_end = 12,
                vexpand = true,
                hexpand = true,
                hscrollbar_policy = Gtk.PolicyType.NEVER
            };
            tasks_scrolled.add (tasks_stack);

            add (stack_switcher);
            add (tasks_scrolled);
        }

        public string get_task_type () {
            var task_type = tasks_stack.get_visible_child_name ();
            return task_type ?? "";
        }

        public int get_selected_task () {
            var cur_stack_child = tasks_stack.get_visible_child ();
            if (cur_stack_child != null) {
                var cur_selected_row = ((Gtk.ListBox) cur_stack_child).get_selected_row ();
                if (cur_selected_row != null) {
                    return cur_selected_row.get_index ();
                }
            }

            return -1;
        }

        public void select_task (int inc) {
            var cur_stack_child = tasks_stack.get_visible_child ();
            if (cur_stack_child != null) {
                var cur_task_list = (Gtk.ListBox) cur_stack_child;
                var cur_selected_row = cur_task_list.get_selected_row ();
                if (cur_selected_row != null) {
                    var new_index = cur_selected_row.get_index () + inc;
                    cur_task_list.unselect_row (cur_selected_row);

                    if (new_index < 0) {
                        return;
                    }

                    var new_row = cur_task_list.get_row_at_index (new_index);
                    if (new_row != null) {
                        cur_task_list.select_row (new_row);
                    }
                }
            }
        }

        public void update_tasks_list (string[] tasks_list, uint8? level) {
            task_letters.@foreach ((w) => {
                task_letters.remove (w);
            });

            string[] t_name;
            string task_str;
            for (uint8 i = 0; i < tasks_list.length; i++) {
                t_name = tasks_list[i].split ("|");
                task_str = @"$(t_name[0]) " + _("and") + @" $(t_name[1])";
                task_letters.add (new LayoutRow (task_str, level < i));
            }
        }

        public override void get_preferred_width (out int minimum_width, out int natural_width) {
            minimum_width = 250;
            natural_width = 300;
        }
    }

    private class LayoutRow : Gtk.ListBoxRow {
        public LayoutRow (string t_name, bool lock_row = false) {
            Gtk.Label row_label = new Gtk.Label (t_name);

            var row_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10) {
                margin_start = 12,
                margin_end = 12,
                margin_top = 6,
                margin_bottom = 6
            };

            row_box.add (row_label);

            if (lock_row) {
                sensitive = false;
                var row_icon = new Gtk.Image.from_icon_name ("system-lock-screen-symbolic", Gtk.IconSize.SMALL_TOOLBAR);
                row_box.add (row_icon);
            }

            add (row_box);
        }

    }
}
