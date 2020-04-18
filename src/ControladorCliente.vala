using GLib;
using Sqlite;

public class ControladorCliente : GLib.Object {


	private static Sqlite.Database db;
	private static string errmsg;

	private static int abrir_bd () {
		int ec = Sqlite.Database.open (database_name, out db);
		return ec;
	}
	private static void imprimir_error_abrir_bd () {
		stderr.printf ("Can't open database: %d: %s\n", db.errcode (), db.errmsg ());
	}
	//TODO Revisar si Cliente cliente "sobra" como parametro
	//Quizás no?
	public static Cliente obtener(int id, Cliente cliente)
	{

		//string errmsg;
		
		// Open a database:
		if (abrir_bd () != Sqlite.OK) {
			imprimir_error_abrir_bd ();
			//return null;
			cliente.set_id(0);
			return cliente;
		}

		//
		// Create a prepared statement:
		// (db.prepare shouldn't be used anymore)
		//
		Sqlite.Statement stmt;
		string prepared_query_str = "SELECT Id, nif, nombre, apellidos, tel, tel2, 
							email, domicilio, cp, ciudad, otros 
							FROM  clientes WHERE Id=" + id.to_string () + ";";
		
		int ec = db.prepare_v2 (prepared_query_str, prepared_query_str.length, out stmt);

		if (ec != Sqlite.OK) {
			stderr.printf ("Error: %d: %s\n", db.errcode (), db.errmsg ());
			//return null;
			cliente.set_id(0);
			return cliente;
		}

		stmt.step ();

		//"Debug"	
		print ("Nº: %d - Nombre: %s - Apellidos: %s\n", 
	        stmt.column_int (0),
	        stmt.column_text(2), 
	        stmt.column_text(3) );
		
		//Object assign fields	
		cliente.set_id(stmt.column_int (0));
		cliente.set_nif(stmt.column_text(1));
		cliente.set_nombre(stmt.column_text(2));
		cliente.set_apellidos(stmt.column_text(3));
		cliente.set_tel1(stmt.column_text(4));
		cliente.set_tel2(stmt.column_text(5));
		cliente.set_email(stmt.column_text(6));
		cliente.set_domicilio(stmt.column_text(7));
		cliente.set_cp(stmt.column_text(8));
		cliente.set_ciudad(stmt.column_text(9));
		cliente.set_varios(stmt.column_text(10));

		stmt.reset ();

		return cliente;
	}
	
	//Insert a new cliente in the database or update
	public static bool insertar(Cliente cliente, 
	                       	    bool modificacion = false,
	                            string id = "0" ) 
	{
		if (abrir_bd () != Sqlite.OK) {
			imprimir_error_abrir_bd ();	
			return false;
		}

		// Insert test data:
		//print(cliente.get_nombre());
		string query;
		if (modificacion == false ) {
			
			query = "INSERT INTO clientes (nif, 
						       nombre, 
						       apellidos, 
						       tel, 
						       tel2,
						       email,
						       domicilio,
						       cp,
						       ciudad,
						       otros) 
						       VALUES ('" + cliente.get_nif () 
						                  + "','"
								  + cliente.get_nombre ()
								  + "','" 
								  + cliente.get_apellidos ()
								  + "','"
								  + cliente.get_tel1 ()
								  + "','"
								  + cliente.get_tel2 ()
								  + "','" 
								  + cliente.get_email ()
								  + "','" 
								  + cliente.get_domicilio ()
								  + "','"
								  + cliente.get_cp ()
								  + "','" 
								  + cliente.get_ciudad ()
								  + "','"
								  + cliente.get_varios ()
								  + "'"
								  + ");";

		} else {		
			query = "UPDATE clientes SET nif ='" + cliente.get_nif () + "',"
							  + "nombre ='" + cliente.get_nombre () + "',"
							  + "apellidos ='" + cliente.get_apellidos () + "',"
							  + "tel ='" + cliente.get_tel1 () + "',"
							  + "tel2 ='" + cliente.get_tel2 () + "',"
							  + "email ='" + cliente.get_email () + "',"
							  + "domicilio='" + cliente.get_domicilio () + "',"
				             		  + "cp ='" + cliente.get_cp () + "',"
							  + "ciudad ='" + cliente.get_ciudad () + "',"
				                          + "otros ='" + cliente.get_varios () 
							  + "' WHERE Id =" + id + ";" ;
		}
		
		int ec = db.exec (query, null, out errmsg);

		if (ec != Sqlite.OK) {
			stderr.printf ("Error: %s\n", errmsg);
			return false;
		}
		
		return true;
	}

	
	public static Cliente[] obtener_lista( string filtro="", string campo="") 
	{
		if (abrir_bd () != Sqlite.OK) {
			Cliente[] lista_clientes = {
				new Cliente()
			};
			return lista_clientes;
		}

		Sqlite.Statement stmt;
		
		string prepared_query_str = "SELECT id, nombre, apellidos, tel, tel2, email, nif FROM clientes "
					     + filtro 
					     + campo 
					     + ";";	

		int ec = db.prepare_v2 (prepared_query_str, prepared_query_str.length, out stmt);

		if (ec != Sqlite.OK) {
			stderr.printf ("Error: %d: %s\n", db.errcode (), db.errmsg ());
			Cliente[] lista_clientes = {
				new Cliente()
			};
			return lista_clientes;
		}
		
		Cliente[] lista_clientes = new Cliente[Utilidades.devolver_num_rows ("clientes", filtro, campo)];
		
		int contador = 0;
		while (stmt.step () == Sqlite.ROW) {
			
			lista_clientes[ contador ] = new Cliente.constructor_for_list (	stmt.column_int (0), 
		        								stmt.column_text(1), 
				        						stmt.column_text(2),
				        						stmt.column_text(3),
				        						stmt.column_text(4),
				        						stmt.column_text(5),
				        						stmt.column_text(6));
			contador++;
			print ("%s\n",stmt.column_text (2));
			
		}
		return lista_clientes;
	}

}
