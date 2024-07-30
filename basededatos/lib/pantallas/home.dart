import 'package:flutter/material.dart';
import '../db/database.dart';
import '../autos/jdm.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  final TextEditingController _distancia100Controller = TextEditingController();
  List<Autos> autos = [];

  @override
  void initState() {
    super.initState();
    _consulta();
  }

  Future<void> _consulta() async {
    final autosList = await Database.seleccionarTodos();
    setState(() {
      autos = autosList;
    });
  }

  Future<void> _agregar() async {
    final nombre = _nombreController.text;
    final km = double.tryParse(_kmController.text) ?? 0;
    final distancia100 = double.tryParse(_distancia100Controller.text) ?? 0;

    if (nombre.isNotEmpty) {
      final auto = Autos(nombre, km, distancia100); // Sin id
      await Database.insertar(auto);
      _nombreController.clear();
      _kmController.clear();
      _distancia100Controller.clear();
      _consulta();
    }
  }

  Future<void> _eliminar(int id) async {
    await Database.eliminar(id);
    _consulta();
  }

  Future<void> _actualizar(Autos auto) async {
    auto.nombre = _nombreController.text;
    auto.km = double.tryParse(_kmController.text) ?? 0;
    auto.distancia100 = double.tryParse(_distancia100Controller.text) ?? 0;

    if (auto.nombre.isNotEmpty) {
      await Database.actualizar(auto);
      _nombreController.clear();
      _kmController.clear();
      _distancia100Controller.clear();
      _consulta();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Autos BD'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre del auto'),
            ),
            TextField(
              controller: _kmController,
              decoration: const InputDecoration(labelText: 'Kilometraje'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _distancia100Controller,
              decoration: const InputDecoration(labelText: '0 a 100 km/h'),
              keyboardType: TextInputType.number,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _agregar,
                  child: const Text('Agregar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (autos.isNotEmpty) {
                      final auto = autos.last;
                      _actualizar(auto);
                    }
                  },
                  child: const Text('Actualizar'),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: autos.length,
                itemBuilder: (context, index) {
                  final auto = autos[index];
                  return Card(
                    child: ListTile(
                      title: Text(auto.nombre),
                      subtitle: Text("0 a 100 km/h: ${auto.distancia100} km, Kilometraje: ${auto.km}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _eliminar(auto.id!),
                      ),
                      onTap: () {
                        _nombreController.text = auto.nombre;
                        _kmController.text = auto.km.toString();
                        _distancia100Controller.text = auto.distancia100.toString();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
