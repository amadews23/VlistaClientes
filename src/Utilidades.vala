public class Utilidades : GLib.Object {
	public static int devolver_num_rows (string tabla, 
	                                     string filtro="", 
	                                     string campo="") {
		Sqlite.Database db;
		//string errmsg;

		// Open a database:
		int ec = Sqlite.Database.open (database_name, out db);
		if (ec != Sqlite.OK) {
			stderr.printf ("Can't open database: %d: %s\n", db.errcode (), db.errmsg ());
			return -1;
		}

		//
		// Create a prepared statement:
		// (db.prepare shouldn't be used anymore)
		//
		Sqlite.Statement stmt;
		//const
		string prepared_query_str = "SELECT count(*) FROM " + tabla + " "+ filtro + campo +";";
		ec = db.prepare_v2 (prepared_query_str, prepared_query_str.length, out stmt);
		if (ec != Sqlite.OK) {
			stderr.printf ("Error: %d: %s\n", db.errcode (), db.errmsg ());
			return -1;
		}

		//
		// Use the prepared statement:
		//
		stmt.step ();
		int n_rows = stmt.column_int (0);
		//print ("Nº: %d\n", n_rows);
		stmt.reset ();
		return n_rows;
		//return stmt.column_int (0);
	}
}
