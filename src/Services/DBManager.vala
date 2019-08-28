namespace KeyTutor {
    public class Services.DBManager : GLib.Object {
        private static DBManager? instance = null;

        public static DBManager get_default () {
            if (instance == null) {
                instance = new DBManager ();
            }

            return instance;
        }

        private Sqlite.Database db;
        private string errormsg;

        private DBManager () {
            open_database ();
        }

        private void open_database () {
            try {
                var path = File.new_for_path (Environment.get_user_cache_dir () + "/io.elementary.keytutor");
                if (!path.query_exists ()) {
                    path.make_directory ();
                }
            } catch (Error e) {
                warning (e.message);
            }


            int ec = Sqlite.Database.open (Environment.get_user_cache_dir () + "/io.elementary.keytutor/database.db", out db);

            if (ec != Sqlite.OK) {
            		warning ("can't open db");
            }

            string q;
            q = """CREATE TABLE IF NOT EXISTS Levels (
                ID          INTEGER     PRIMARY KEY AUTOINCREMENT,
                locale      TEXT        NOT NULL,
                level       INTEGER     DEFAULT 1,
                CONSTRAINT unique_level UNIQUE (locale)
                );""";

            if (db.exec (q, null, out errormsg) != Sqlite.OK) {
                warning (errormsg);
            }

            q = """CREATE TABLE IF NOT EXISTS Results (
                ID          INTEGER     PRIMARY KEY AUTOINCREMENT,
                locale      TEXT        NOT NULL,
                type        TEXT        NOT NULL,
                level       UNTEGER     NOT NULL,
                speed       INTEGER     NOT NULL,
                accuracy    REAL        NOT NULL
                );""";

            if (db.exec (q, null, out errormsg) != Sqlite.OK) {
                warning (errormsg);
            }
        }

        public void reset_database () {
            File db_path = File.new_for_path (Environment.get_user_cache_dir () + "/io.elementary.keytutor/database.db");
            try {
                db_path.delete ();
            } catch (Error err) {
                warning (err.message);
            }

            open_database ();
        }

        public void level_reload (string locale, int speed, int accuracy) {
            Sqlite.Statement stmt;
            int res = db.prepare_v2 ("SELECT level, MAX(speed), MAX(accuracy) FROM Results WHERE locale=? AND type=? GROUP BY level", -1, out stmt);
            assert (res == Sqlite.OK);

            res = stmt.bind_text (1, locale);
            assert (res == Sqlite.OK);

            res = stmt.bind_text (2, "letters");
            assert (res == Sqlite.OK);

            int new_level = 0;

            while (stmt.step () == Sqlite.ROW) {
                if (speed > stmt.column_int (1) || accuracy > stmt.column_double (2)) {
                    break;
                }
                new_level = stmt.column_int (0);
            }

            level_up (locale, (uint8) new_level);
        }

        public void level_up (string locale, owned uint8? level = null) {
            Sqlite.Statement stmt;
            if (level == null) {
                level = get_level (locale);
                if (level != null) {++level;}
            }
            if (level != null) {
                int res = db.prepare_v2 ("UPDATE Levels SET level=? WHERE locale=?", -1, out stmt);
                assert (res == Sqlite.OK);

                res = stmt.bind_int (1, (int) (level));
                assert (res == Sqlite.OK);
                res = stmt.bind_text (2, locale);
                assert (res == Sqlite.OK);

                res = stmt.step ();
                if (res != Sqlite.DONE) {
                    warning ("error when update level");
                }
            } else {
                int res = db.prepare_v2 ("INSERT INTO Levels (locale)  VALUES (?)", -1, out stmt);
                assert (res == Sqlite.OK);

                res = stmt.bind_text (1, locale);
                assert (res == Sqlite.OK);

                res = stmt.step ();
                if (res != Sqlite.DONE) {
                    warning ("error when insert data");
                }
            }
        }

        public uint8? get_level (string locale) {
            Sqlite.Statement stmt;

            int res = db.prepare_v2 ("SELECT level FROM Levels WHERE locale=?", -1, out stmt);
            assert (res == Sqlite.OK);

            res = stmt.bind_text (1, locale);
            assert (res == Sqlite.OK);

            uint8? loc_level = null;

            if (stmt.step () == Sqlite.ROW) {
                loc_level = (uint8) stmt.column_int (0);
            }

            return loc_level;
        }

        public void add_lesson_result (string locale,
                                       string les_type,
                                       uint8 les_level,
                                       uint16 speed,
                                       double accuracy) {
            Sqlite.Statement stmt;

            int res = db.prepare_v2 ("INSERT INTO Results (locale, type, level, speed, accuracy) VALUES (?, ?, ?, ?, ?)", -1, out stmt);
            assert (res == Sqlite.OK);

            res = stmt.bind_text (1, locale);
            assert (res == Sqlite.OK);

            res = stmt.bind_text (2, les_type);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (3, (int) les_level);
            assert (res == Sqlite.OK);

            res = stmt.bind_int (4, (int) speed);
            assert (res == Sqlite.OK);

            res = stmt.bind_double (5, accuracy);
            assert (res == Sqlite.OK);

            res = stmt.step ();
            if (res != Sqlite.DONE) {
                warning ("error when insert data");
            }
        }

        public LevelResults[] get_lesson_results (string locale, string les_type, uint8 les_level) {
            Sqlite.Statement stmt;
            int res = db.prepare_v2 ("SELECT speed, accuracy FROM Results WHERE locale=? AND type=? AND level=?", -1, out stmt);
            assert (res == Sqlite.OK);

            res = stmt.bind_text (1, locale);
            assert (res == Sqlite.OK);
            res = stmt.bind_text (2, les_type);
            assert (res == Sqlite.OK);
            res = stmt.bind_int (3, (int) les_level);
            assert (res == Sqlite.OK);

            LevelResults[] all = {};

            while (stmt.step () == Sqlite.ROW) {
                LevelResults level_result = {};
                level_result.speed = (uint16) stmt.column_int (0);
                level_result.accuracy = stmt.column_double (1);
                all += level_result;
            }

            return all;
        }

    }

    public struct LevelResults {
        public uint16 speed;
        public double accuracy;
    }
}
