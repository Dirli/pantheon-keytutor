public class KeyTutor.Services.Settings : GLib.Settings {
    private static Settings? instance = null;

    private Settings () {
         Object (schema_id: "io.elementary.keytutor");
    }

    public static Settings get_default () {
        if (instance == null) {
            instance = new Settings ();
        }

        return instance;
    }
}
