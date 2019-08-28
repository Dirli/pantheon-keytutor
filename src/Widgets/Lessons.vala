namespace KeyTutor {
    public class Widgets.Lessons : CustomBox {
        public signal void run_lesson (uint8 les_index, string stack_child_name);

        public Lessons (string[] lessons_list, uint8? level) {
            margin_top = margin_bottom = 30;

            Gtk.ListBox letter_lessons = new Gtk.ListBox ();
            letter_lessons.selection_mode = Gtk.SelectionMode.BROWSE;

            string[] lesson_name;
            string lesson_str;
            for (uint8 i = 0; i < lessons_list.length; i++) {
                lesson_name = lessons_list[i].split ("|");
                lesson_str = @"$(lesson_name[0]) " + _("and") + @" $(lesson_name[1])";
                letter_lessons.add (new LayoutRow (lesson_str, i, level < i));
            }

            Gtk.Stack tasks_stack = new Gtk.Stack ();
            tasks_stack.expand = true;
            tasks_stack.get_style_context ().add_class ("lessons-list");
            tasks_stack.add_titled (letter_lessons, "letters", _("Letters"));

            var stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.halign = Gtk.Align.CENTER;
            stack_switcher.homogeneous = true;
            stack_switcher.margin_top = 12;
            stack_switcher.stack = tasks_stack;

            var tasks_scrolled = new Gtk.ScrolledWindow (null, null);
            tasks_scrolled.margin_start = tasks_scrolled.margin_end = 12;
            tasks_scrolled.hscrollbar_policy = Gtk.PolicyType.NEVER;
            tasks_scrolled.expand = true;
            tasks_scrolled.add (tasks_stack);

            Gtk.Button run_lesson_button = new Gtk.Button.with_label (_("Run lesson"));
            run_lesson_button.clicked.connect (() => {
                var cur_stack_child = tasks_stack.get_visible_child ();
                if (cur_stack_child != null) {
                    var cur_selected_row = (cur_stack_child as Gtk.ListBox).get_selected_row ();
                    if (cur_selected_row != null) {
                        run_lesson ((cur_selected_row as LayoutRow).lessson_index,
                                    tasks_stack.get_visible_child_name ());
                    }
                }
            });

            add (stack_switcher);
            add (tasks_scrolled);
            add (run_lesson_button);

            show_all ();
        }
    }

    private class LayoutRow : Gtk.ListBoxRow {
        public uint8 lessson_index;
        public LayoutRow (string les_name, uint8 les_index, bool lock_row = false) {
            lessson_index = les_index;
            Gtk.Label row_label = new Gtk.Label (les_name);


            var row_box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 10);
            row_box.margin_start = row_box.margin_end = 12;
            row_box.margin_top = row_box.margin_bottom = 6;

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
