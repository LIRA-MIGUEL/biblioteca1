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
        title: const Text("Libros", style: TextStyle(color: Colors.red)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        color: Colors.lightBlue, // Cambia el color de fondo aquí
        child: ListView(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Center(
              child: Text(
                "Información del Libro",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 170,
                    height: 170,
                    child: Utility.ImageFromBase64String(widget.photo!),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _buildFieldAndResponse("Título:", widget.titulo, Colors.greenAccent, Colors.black),
                  _buildFieldAndResponse("Autor/Autores:", widget.autor, Colors.greenAccent, Colors.black),
                  _buildFieldAndResponse("Editorial:", widget.editorial, Colors.greenAccent, Colors.black),
                  _buildFieldAndResponse("No. de Páginas:", widget.paginas, Colors.greenAccent, Colors.black),
                  _buildFieldAndResponse("Edición:", widget.edicion, Colors.greenAccent, Colors.black),
                  _buildFieldAndResponse("ISBN:", widget.isbn, Colors.greenAccent, Colors.black)
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red, // Cambiar el color de fondo del botón
                  onPrimary: Colors.black, // Cambiar el color del texto del botón
                  minimumSize: const Size(150, 40), // Tamaño mínimo del botón
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text("Regresar"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldAndResponse(String field, String? response, Color fieldColor, Color responseColor) {
    return Row(
      children: [
        Text(
          "$field",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: fieldColor,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          response ?? "",
          style: TextStyle(
            fontSize: 20,
            color: responseColor,
          ),
        ),
      ],
    );
  }
}


