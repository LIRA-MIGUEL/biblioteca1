import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:biblioteca1/convert_utility.dart';
import 'package:biblioteca1/dbManager.dart';
import 'package:biblioteca1/libro.dart';
import 'image_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Libro>>? Libross;

  TextEditingController controlNumController = TextEditingController();
  TextEditingController isbnController = TextEditingController();
  TextEditingController tituloController = TextEditingController();
  TextEditingController autorController = TextEditingController();
  TextEditingController editorialController = TextEditingController();
  TextEditingController paginasController = TextEditingController();
  TextEditingController edicionController = TextEditingController();

  String? isbn = '';
  String? titulo = '';
  String? autor = '';
  String? editorial = '';
  String? paginas = '';
  String? edicion = '';
  String? photoname = '';

  //Update control
  int? currentLibroId;

  //String? currentBookIsbn;

  // Variable para guardar la imagen
  var image ;

  final formKey = GlobalKey<FormState>();
  late var dbHelper;

  // Variable para verificar si estamos actualizando
  late bool isUpdating;

  //Métodos de usaurio
  refreshList() {
    setState(() {
      Libross = dbHelper.getLibros();
    });
  }

  pickImageFromGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(source: ImageSource.gallery, maxHeight: 480, maxWidth: 640)
        .then((value) async {
      Uint8List? imageBytes = await value!.readAsBytes();
      setState(() {
        photoname = Utility.base64String(imageBytes!);
      });
    });
  }

  clearFields() {
    controlNumController.text = '';
    isbnController.text = '';
    tituloController.text = '';
    editorialController.text = '';
    autorController.text = '';
    paginasController.text = '';
    edicionController.text = '';

    photoname = '';
  }

  @override
  void initState() {
    super.initState();
    dbHelper = DBManager();
    refreshList();
    isUpdating = false;
  }

  Widget userForm() {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: [
            const SizedBox(height: 10),
            //TextFormField(
            //controller: controlNumController,
            //keyboardType: TextInputType.number,
            //decoration: const InputDecoration(
            //labelText: 'Control Number',
            // ),
            //validator: (val) => val!.isEmpty ? 'Enter Control Number' : null,
            //onSaved: (val) => controlNumController.text = val!,
            // ),
            TextFormField(
              controller: tituloController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Titulo del Libro',
              ),
              validator: (val) => val!.isEmpty ? 'Titulo' : null,
              onSaved: (val) => titulo = val!,
            ),
            TextFormField(
              controller: autorController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Autor/Autores',
              ),
              validator: (val) => val!.isEmpty ? 'Autor/Autores' : null,
              onSaved: (val) => autor = val!,
            ),
            TextFormField(
              controller: editorialController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Editorial',
              ),
              validator: (val) => val!.isEmpty ? 'Editorial' : null,
              onSaved: (val) => editorial = val!,
            ),
            TextFormField(
              controller: paginasController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'No. Páginas',
              ),
              validator: (val) => val!.isEmpty ? 'No. Páginas' : null,
              onSaved: (val) => paginas = val!,
            ),
            TextFormField(
              controller: edicionController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'Edición',
              ),
              validator: (val) => val!.isEmpty ? 'Edición' : null,
              onSaved: (val) => edicion = val!,
            ),
            TextFormField(
              controller: isbnController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: 'ISBN',
              ),
              validator: (val) => val!.isEmpty ? 'Enter isbn' : null,
              onSaved: (val) => isbn = val!,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: validate,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: const BorderSide(color: Colors.lightBlue)),
                  child: Text(isUpdating ? "Actualizar" : "Insertar"),
                ),
                MaterialButton(
                  onPressed: () {
                    pickImageFromGallery();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                      side: const BorderSide(color: Colors.pink)),
                  child: const Text("Seleccionar imagen"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  SingleChildScrollView userDataTable(List<Libro>? Libross) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Foto')),
          DataColumn(label: Text('Titulo')),
          DataColumn(label: Text('Autor/Autores')),
          DataColumn(label: Text('Editorial')),
          DataColumn(label: Text('No. Páginas')),
          DataColumn(label: Text('Edición')),
          DataColumn(label: Text('ISBN')),
          DataColumn(label: Text('Eliminar')),
        ],
        rows: Libross!
            .map((libro) => DataRow(cells: [
          DataCell(
              Container(
                width: 80,
                height: 120,
                child: Utility.ImageFromBase64String(libro.photoName!),
              ), onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => imageInfo(
                      photo: libro.photoName,
                      titulo: libro.titulo,
                      autor: libro.autor,
                      editorial: libro.editorial,
                      paginas: libro.paginas,
                      edicion: libro.edicion,
                      isbn: libro.isbn)),
            );
          }),
          DataCell(Text(libro.titulo!), onTap: () {
            setState(() {
              // En caso de que se actualice
              isUpdating = true;
              // Obtiene el ID y la Imagen del registro seleccionado
              currentLibroId = libro.controlNum;
              image = libro.photoName;
            });
            tituloController.text = libro.titulo!;
            autorController.text = libro.autor!;
            editorialController.text = libro.editorial!;
            paginasController.text = libro.paginas!;
            edicionController.text = libro.edicion!;
            isbnController.text = libro.isbn!;
          }),
          DataCell(Text(libro.autor!)),
          DataCell(Text(libro.editorial!)),
          DataCell(Text(libro.paginas!)),
          DataCell(Text(libro.edicion!)),
          DataCell(Text(libro.isbn!)),
          DataCell(IconButton(
            onPressed: () {
              dbHelper.delete(libro.controlNum);
              refreshList();
            },
            icon: const Icon(Icons.delete),
          ))
        ]))
            .toList(),
      ),
    );
  }

  Widget list() {
    return Expanded(
        child: SingleChildScrollView(
          child: FutureBuilder(
              future: Libross,
              builder: (context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return userDataTable(snapshot.data);
                }
                if (!snapshot.hasData) {
                  print("Data Not Found");
                }
                return const CircularProgressIndicator();
              }),
        ));
  }

  validate() {
    // Validar los métodos
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (isUpdating) {
        // Verifica imagen
        if (photoname == null || photoname!.isEmpty) {
          // Conservar la imagen existente si photoname está vacío
          photoname = image;
        }
        // Asigna los valores que se vayan a actualizar
        Libro libro = Libro(
          controlNum: currentLibroId,
          titulo: titulo,
          autor: autor,
          editorial: editorial,
          paginas: paginas,
          edicion: edicion,
          isbn: isbn,
          photoName: photoname,
        );
        // Actualiza con el método correspondiente
        dbHelper.update(libro);

        isUpdating = false;
        // Limpia las entradas de datos y refresca la tabla
        clearFields();
        refreshList();
      } else {
        // Verifica imagne
        if (photoname == null || photoname!.isEmpty) {
          // Muestra una alerta si no se ha seleccionado una imagen al crear un nuevo registro
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Selecciona una imagen.'),
            ),
          );
        } else {
          // Asigna los valores correspondientes
          Libro libro = Libro(
            controlNum: currentLibroId,
            titulo: titulo,
            autor: autor,
            editorial: editorial,
            paginas: paginas,
            edicion: edicion,
            isbn: isbn,
            photoName: photoname,
          );
          // Guarda el nuevo registro con el método correspondiente
          dbHelper.save(libro);
          // Limpia las entradas y vuelve a cargas la tabla
          clearFields();
          refreshList();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Evitar botón de regreso
        automaticallyImplyLeading: false,
        title: const Text('Menu Biblioteca'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: CustomSearch(dbHelper));
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: [userForm(), list()],
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  final DBManager dbHelper;

  CustomSearch(this.dbHelper);


  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Realiza la búsqueda en la base de datos y obtén los libros
    Future<List<Libro>> searchLibros() async {
      // Realiza una consulta a la base de datos para obtener los libros
      return await dbHelper.searchLibrosByTitle(query);
    }

    return FutureBuilder<List<Libro>>(
      future: searchLibros(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No se encontraron resultados');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var libro = snapshot.data![index];
              return ListTile(
                title: Text(libro.titulo!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => imageInfo(
                        autor: libro.autor ?? 'Valor predeterminado en caso de nulo',
                        titulo: libro.titulo ?? 'Valor predeterminado en caso de nulo',
                        edicion: libro.edicion ?? 'Valor predeterminado en caso de nulo',
                        editorial: libro.editorial ?? 'Valor predeterminado en caso de nulo',
                        isbn: libro.isbn ?? 'Valor predeterminado en caso de nulo',
                        paginas: libro.paginas ?? 'Valor predeterminado en caso de nulo',
                        photo: libro.photoName ?? 'Valor predeterminado en caso de nulo',),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Realiza la búsqueda en la base de datos y obtén los libros
    Future<List<Libro>> searchLibros() async {
      // Realiza una consulta a la base de datos para obtener los libros
      return await dbHelper.searchLibrosByTitle(query);
    }

    return FutureBuilder<List<Libro>>(
      future: searchLibros(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No se encontraron resultados');
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var libro = snapshot.data![index];
              return ListTile(
                title: Text(libro.titulo!),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => imageInfo(
                        autor: libro.autor ?? 'Valor predeterminado en caso de nulo',
                        titulo: libro.titulo ?? 'Valor predeterminado en caso de nulo',
                        edicion: libro.edicion ?? 'Valor predeterminado en caso de nulo',
                        editorial: libro.editorial ?? 'Valor predeterminado en caso de nulo',
                        isbn: libro.isbn ?? 'Valor predeterminado en caso de nulo',
                        paginas: libro.paginas ?? 'Valor predeterminado en caso de nulo',
                        photo: libro.photoName ?? 'Valor predeterminado en caso de nulo',),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

}
