import 'package:flutter/material.dart';
import 'package:biblioteca1/convert_utility.dart';

class imageInfo extends StatefulWidget {
  const imageInfo({
    Key? key,
    required this.photo,
    required this.titulo,
    required this.autor,
    required this.editorial,
    required this.paginas,
    required this.edicion,
    required this.isbn,
  }) : super(key: key);

  final String? photo;
  final String? titulo;
  final String? autor;
  final String? editorial;
  final String? paginas;
  final String? edicion;
  final String? isbn;

  @override
  State<imageInfo> createState() => _imageInfoState();
}

class _imageInfoState extends State<imageInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Datos del libro",
          style: TextStyle(color: Colors.green), // Cambiar el color del texto a verde
        ),
        centerTitle: true,
        backgroundColor: Colors.orange, // Cambiar el color de fondo a naranja
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          const Center(
            child: Text(
              "Información del libro",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Cambiar el color del texto a verde
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 120,
                  child: Utility.ImageFromBase64String(widget.photo!),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Titulo ${widget.titulo}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Cambiar el color del texto a azul
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Autor/Autores: ${widget.autor}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Cambiar el color del texto a azul
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Editorial: ${widget.editorial}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Cambiar el color del texto a azul
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "No. de Páginas: ${widget.paginas}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Cambiar el color del texto a azul
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "Edición: ${widget.edicion}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Cambiar el color del texto a azul
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "ISBN: ${widget.isbn}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // Cambiar el color del texto a azul
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Regresar"),
            style: ButtonStyle(
              backgroundColor:
              MaterialStateProperty.all(Colors.blue), // Cambiar el color del botón a azul
            ),
          ),
        ],
      ),
    );
  }
}
