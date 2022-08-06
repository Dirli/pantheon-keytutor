namespace KeyTutor {
    public class Services.Timer : GLib.Object {
        public signal void pasted_time (int ptime);

        private GLib.DateTime start_time;
        private GLib.TimeSpan past_time;

        private uint source_id;

        public Timer () {}

        public void start_timer () {
            past_time = 0;

            start_time = new GLib.DateTime.now_local ();
            source_id = GLib.Timeout.add (1000, timer_handler);
        }

        public uint get_full_time () {
            return (uint) past_time / 1000000;
        }

        private bool timer_handler () {
            var cur_time = new GLib.DateTime.now_local ();

            past_time += cur_time.difference (start_time);
            start_time = cur_time;

            pasted_time ((int) past_time / 1000000);

            return true;
        }

        public void stop_timer () {
            if (source_id > 0) {
                GLib.Source.remove(source_id);
            }
        }
    }
}
