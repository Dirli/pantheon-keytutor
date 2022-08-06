namespace KeyTutor {
    public class Services.Accuracy : GLib.Object {
        private uint16 error_chars;

        public Accuracy () {
            error_chars = 0;
        }

        public double get_accuracy (uint16 total_chars) {
            return 100 - ((double) error_chars / total_chars * 100);
        }

        public void add_err () {
            error_chars++;
        }

        public void reset () {
            error_chars = 0;
        }
    }
}
