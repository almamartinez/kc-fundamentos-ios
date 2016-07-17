# Práctica Fundamentos iOS con Swift.
## Comentarios

He metido dos TableViewControllers en un TabController para la parte de los listados de libros. 

Los TableViewControllers son uno subtipo de otro, porque pensé que podía reutilizar bastante código, pero tampoco ha ayudado mucho. 

El tratamiento del SplitViewController es el que está marcado con Deprecated porque no me dio tiempo a encontrar otra forma de implementarlo. Además buscando por internet, sólo encuentras implementaciones con Storyboards. 

## Preguntas
* **¿En qué otros modos podemos trabajar?¿is, as?**

	* ``is``: sirve para comprobar si una instancia es de un determinado tipo.
	*  ``as``: sirve para hacer un downcast. Se utiliza para intentar transformar una variable a un sub tipo o subclase (si sabemos que puede que dicha variable sea de dicho sub tipo). 

* **Imágenes de portada y Pdfs. ¿Dónde guardarías estos datos?**

	Los he guardado en NSUserDefaults, en diccionarios [String:NSData]. La Key es la url (String absuluta) y guardo el NSData del recurso. 


* **Persistencia de Favoritos**

	Se guardan en un array en NSUserDefaults. Si el título de un libro está en ese array, es favorito, si no, no. 
	
	Los favoritos se cargan en la inicialización de AGTLibrary.
	
* **Cambio y propagación de la propiedad ```isFavourite```**
	
	Se puede hacer con Delegados y con Notificaciones. 
	
	Lo he hecho con ambos, por temas de diseño. Tengo dos TableViewControllers distintos y si cambio un favorito desde el listado por Título, al ir al otro listado, no se actualizan los favoritos. Así que desde el otro listado, el de Tags, me subscribo a la notificación de que el listado de Favoritos a cambiado, de forma que se refresca siempre. 
	
	
* **```reloadaData()``` ¿Es una aberración desde el puntod de vista del rendimiento?**

	En realidad no, porque refresca sólo las filas que están visibles. 
	
	**¿Hay alguna forma alternativa? ¿Cuándo crees que vale la pena usarlo?**
	
	Yo he usado distintos métodos:

	Para celdas concretas, cuando hacemos una carga asíncrona de la portada, porque al menos la primera vez recargaremos la tabla tantas veces como celdas. Si usamos esto, sólo refrescamos la imagen de la celda:
        
        tableView.reloadRowsAtIndexPaths([indexPath],
        withRowAnimation:
        UITableViewRowAnimation.Automatic)
	
	Para Secciones concretas, para el caso de los Favoritos, porque era la única sección que cambiaba:
	
		tableView.reloadSections(NSIndexSet(index: 0),
		withRowAnimation:
		UITableViewRowAnimation.Automatic)
	
* **Actualizar el PDF cuando el usuario selecciona otro en la tabla**

	Lo he hecho utilizando un delegado al que se le pasa el libro seleccionado.
	
	 El delegado es implementado por:
	 * el BookViewController, que recarga el controlador con los nuevos datos, cuando lo usamos desde el SplitViewController.  
	
	 * Los TableViewControllers, que crea un nuevo BookViewController pasándole el libro y hace un push en el navigatorController.

## Extras
* **¿Qué funcionalidades le añadirías antes de subirla a la App Store?**

	* Guardar en qué página se queda el usuario leyendo. 
	* Posibilidad de votar los libros
	* Posibilidad de subir tus propios libros (o importarlos a la App).

* **¿Qué otras versiones se te ocurren? ¿Algo que puedas monetizar?**

	Se me ocurre la posibilidad de monetizar esta misma App, permitiendo una previsualización del libro, y permitiendo la descarga completa sólo tras el pago del libro. 
	
	A parte, usando esta plantilla se puede crear cualquier tipo de App del tipo Listado + Detalle. 