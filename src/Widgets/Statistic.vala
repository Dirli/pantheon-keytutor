namespace KeyTutor {
    public class Widgets.Statistic : Gtk.Box {
        public Statistic (string locale, uint8 level_index, string course_name) {
            Object (orientation: Gtk.Orientation.VERTICAL,
                    spacing: 20,
                    expand: true,
                    valign: Gtk.Align.FILL,
                    halign: Gtk.Align.FILL);

            var progress_view = new Widgets.Progress (locale,level_index, course_name);

            Gtk.Stack stats_stack = new Gtk.Stack ();
            stats_stack.expand = true;
            stats_stack.add_titled (progress_view, "letters", _("Progress"));

            Gtk.StackSwitcher stack_switcher = new Gtk.StackSwitcher ();
            stack_switcher.halign = Gtk.Align.CENTER;
            stack_switcher.homogeneous = true;
            stack_switcher.margin_top = 12;
            stack_switcher.stack = stats_stack;

            add (stack_switcher);
            add (stats_stack);
        }
    }
}
