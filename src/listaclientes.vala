/* -*- Mode: C; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-  */
/*
 * main.c
 * Copyright (C) 2019 BartolomE Vich Lozano <tolo@tovilo.es>
 * 
 * listaclientes is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * listaclientes is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 * See the GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using Gtk;
const string database_name = "ant.db";
public class Main : Object 
{
	/* 
	 * Uncomment this line when you are done testing and building a tarball
	 * or installing
	 */
	//const string UI_FILE = Config.PACKAGE_DATA_DIR + "/ui/" + "listaclientes.ui";
	const string UI_FILE = "src/listaclientes.ui";

	/* ANJUTA: Widgets declaration for listaclientes.ui - DO NOT REMOVE */
	
	Gtk.TreeView clientes_treeview;
	Gtk.ListStore liststore; //For clientes_treeview
	Gtk.ListStore liststore1; //For busqueda_combo 
	Gtk.ComboBox busqueda_combo;
	Gtk.Entry busqueda_entry; 
	Gtk.Button buscar_button;
	Gtk.Label cliente_label;


	public Main ()
	{

		try {
			var builder = new Builder ();
			builder.add_from_file (UI_FILE);
			builder.connect_signals (this);

			var window = builder.get_object ("window") as Window;
			/* ANJUTA: Widgets initialization for listaclientes.ui - DO NOT REMOVE */

		    	this.clientes_treeview = builder.get_object ("clientes_treeview") as Gtk.TreeView;
 			this.liststore = builder.get_object ("liststore") as Gtk.ListStore;
 			this.liststore1 = builder.get_object ("liststore1") as Gtk.ListStore;
			this.busqueda_combo = builder.get_object ("busqueda_combo") as Gtk.ComboBox;
		    	this.busqueda_entry = builder.get_object ("busqueda_entry") as Gtk.Entry;
			buscar_button = builder.get_object ("buscar_button") as Gtk.Button;
		   	cliente_label = builder.get_object ("cliente_label") as Gtk.Label;

			mostrar();

			buscar_button.clicked.connect (() => {			
				mostrar_condicional();
			});

			busqueda_entry.paste_clipboard.connect (() => {
				mostrar_condicional();
			});
			//TODO al pulsar Enter "para mas comodidad"
			//busqueda_entry.connect (() => {
			//	mostrar_condicional();
			//});		

			// Monitor list double-clicks.
    			clientes_treeview.row_activated.connect (al_doble_click);
    			// Monitor list selection changes
    			clientes_treeview.get_selection().changed.connect (al_seleccionar);

			busqueda_combo.set_active (1); //Search default by nombre
		
			window.show_all ();
		
		} 
		catch (Error e) {
			stderr.printf ("Could not load UI: %s\n", e.message);
		} 

	}  

	/* List item selection handler. */
    	private void al_seleccionar (Gtk.TreeSelection selection) 
	{	
        	Gtk.TreeModel model;
        	Gtk.TreeIter iter;
        
		if (selection.get_selected (out model, out iter)) {
            		Cliente cliente = get_selection (model, iter);
            		cliente_label.label = @"Seleccion de: $(cliente.get_id ().to_string ()
			                     			+"- "
								+cliente.get_nombre ()
								+" "
								+cliente.get_apellidos ())
								";
								
			print("%s\n",cliente.get_nombre ()); //for debug
     		}
    	}

	/* List item double-click handler. */
    	private void al_doble_click (Gtk.TreeView treeview ,
        	                     Gtk.TreePath path, 
                                     Gtk.TreeViewColumn column)
	{
        	Gtk.TreeIter iter;
		
        	if (clientes_treeview.model.get_iter (out iter, path)) {
            		Cliente cliente = get_selection (clientes_treeview.model, iter);
            		cliente_label.label = @"Doble click en: $(cliente.get_id ().to_string ()
								  +"- "
								  +cliente.get_nombre ()
								  +" "
								  +cliente.get_apellidos ())
								  ";
        	}
    	}
	 
    	private static Cliente get_selection (Gtk.TreeModel model,
        	                              Gtk.TreeIter iter) 
	{
	
        	int id;
		string nombre;
		string apellidos;
		string tel1;
		string tel2; 
		string email; 
		string nif;
		
        	model.get (iter, 
                   	   0, out id, 
                   	   1, out nombre, 
                   	   2, out apellidos, 
                           3, out tel1,
                           4, out tel2,
                           5, out email,
                           6, out nif);
		
		Cliente cliente = new Cliente.constructor_for_list (id,
	                                            	            nombre,
		                                        	    apellidos,
		                                        	    tel1,
		                                        	    tel2,
		                                        	    email,
		                                        	    nif);
		return cliente;
    	}


	private void mostrar(string filtro="",
	                     string campo="") 
	{
    		this.liststore.clear ();

			Cliente[] lista_clientes = ControladorCliente.obtener_lista (filtro, campo);


		    	for (int i=0; i < Utilidades.devolver_num_rows ("clientes", filtro, campo); i++) {
      			
				Gtk.TreeIter iter;
      				liststore.append (out iter);
      				liststore.set (iter, 
            		              	       0, lista_clientes[i].get_id (), 
                		               1, lista_clientes[i].get_nombre (), 
        	        		       2, lista_clientes[i].get_apellidos (), 
                        		       3, lista_clientes[i].get_tel1 (), 
                          		       4, lista_clientes[i].get_tel2 (), 
                          		       5, lista_clientes[i].get_email (), 
                          		       6, lista_clientes[i].get_nif ());
			}
	}

	private void  mostrar_condicional() 
	{
 		this.liststore.clear ();
		//print("%i",busqueda_combo.get_active ());
		switch (busqueda_combo.get_active ()) {
			
				case 0:
					mostrar("WHERE Id=", busqueda_entry.get_text ());
					//print("%s",busqueda_entry.get_text ());
					break;

				case 1:
					mostrar("WHERE nombre LIKE '", busqueda_entry.get_text ()+"%'" );
					//print("%s",busqueda_entry.get_text ()+"%");
					break;
						
				case 2:
					mostrar("WHERE apellidos LIKE '", busqueda_entry.get_text ()+"%'" );
					//print("%s",busqueda_entry.get_text ());
					break;	

				case 3:
					string cadena1 = "WHERE tel LIKE '" + busqueda_entry.get_text () + "'";
					string cadena2 = " OR tel2 LIKE '" + busqueda_entry.get_text () + "'";
					//mostrar("WHERE tel LIKE '", busqueda_entry.get_text () );
					mostrar(cadena1, cadena2);
					//print("%s",busqueda_entry.get_text ());
					break;	
				
				case 4:
					mostrar("WHERE email LIKE '", busqueda_entry.get_text ()+"%'" );
					//print("%s",busqueda_entry.get_text ());
					break;	

				case 5:
					mostrar("WHERE nif='", busqueda_entry.get_text ()+"'" );
					//print("%s",busqueda_entry.get_text ());
					break;
						
				case 6:
					mostrar();
					//print("%s",busqueda_entry.get_text ());
					break;						
												
			}
	}

	[CCode (instance_pos = -1)]
	public void on_destroy (Widget window) 
	{
		Gtk.main_quit();
	}

	static int main (string[] args) 
	{
		Gtk.init (ref args);
		var app = new Main ();

		Gtk.main ();
		
		return 0;
	}
}
