public class Cliente : GLib.Object {

	 /*Fields*/
	 private int id;
	 private string nif;
	 private string nombre;
	 private string apellidos;
	 private string tel1;
	 private string tel2;
	 private string email;
	 private string domicilio;
	 private string cp;
	 private string ciudad;
	 private string varios;

	 /*Constructor*/
	 public Cliente() {
		//TODO crear el cliente en caso de error
		//Cliente.constructor_with_error? 
	 }
	
	 public Cliente.constructor_with_all(string nif, 
	                                     string nombre, 
	                                     string apellidos, 
	                                     string tel1,
	                                     string tel2,
	                                     string email,
	                                     string domicilio,
	                                     string cp,
	                                     string ciudad,
	                                     string varios) {
		 //this.id = id; //el id lo asigna la base de datos
		 this.nif = nif;	 
		 this.nombre = nombre;	
		 this.apellidos = apellidos;	
		 this.tel1 = tel1;
		 this.tel2 = tel2;
		 this.email= email;	
		 this.domicilio = domicilio;
		 this.cp = cp;	
		 this.ciudad = ciudad;
		 this.varios = varios;
	 }

	
	 public Cliente.constructor_for_list(int id,
	                                     string nombre, 
	                                     string apellidos, 
	                                     string tel1,
	                                     string tel2,
	                                     string email,
	                                     string nif ) {
		 this.id = id; 
 		 this.nombre = nombre;	
		 this.apellidos = apellidos;	
		 this.tel1 = tel1;
		 this.tel2 = tel2;
		 this.email= email;	
		 this.nif = nif;	
	 }
	
	 /*Methods*/
	
	 /*getters*/
	 public int get_id() {
		return this.id;
	 }
	 public string get_nif() {
		return this.nif;
	 } 
	 public string get_nombre() {
		return this.nombre;
	 }
	 public string get_apellidos() {
		return this.apellidos;
	 }	
	 public string get_tel1() {
		return this.tel1;
	 }
	 public string get_tel2() {
		return this.tel2;
	 }
	 public string get_email() {
		return this.email;
	 }
	 public string get_domicilio() {
		return this.domicilio;
	 }
	 public string get_cp() {
		return this.cp;
	 }
	 public string get_ciudad() {
		return this.ciudad;
	 }
	 public string get_varios() {
		return this.varios;
	 }	
	
	 /*setters*/
	public void set_id( int id ) {
		this.id = id;
	}
	public void set_nif( string nif) {
		this.nif = nif;
	}
	public void set_nombre (string nombre) {
		this.nombre = nombre;
	}
	public void set_apellidos (string apellidos) {
		this.apellidos = apellidos;
	}
	public void set_tel1 (string tel1) {
		this.tel1 = tel1;
	}
	public void set_tel2 (string tel2) {
		this.tel2 = tel2;
	}
	public void set_email (string email) {
		this.email = email;
	}
	public void set_domicilio (string domicilio) {
		this.domicilio = domicilio;
	}
	public void set_cp (string cp) {
		this.cp = cp;
	}
	public void set_ciudad (string ciudad) {
		this.ciudad = ciudad;
	}
	public void set_varios (string varios) {
		this.varios = varios;
	}
	
}
