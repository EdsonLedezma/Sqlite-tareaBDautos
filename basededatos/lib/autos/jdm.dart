class Autos {
  int? id; // Hacemos el id opcional
  late String nombre;
  late double km;
  late double distancia100;

  Autos(this.nombre, this.km, this.distancia100, {this.id});

  Autos.fromMap(Map<String, dynamic> resultado) {
    id = resultado["id"];
    nombre = resultado["nombre"];
    km = resultado["km"];
    distancia100 = resultado["distancia100"];
  }

  Map<String, dynamic> aMapa() {
    var mapa = {
      "nombre": nombre,
      "km": km,
      "distancia100": distancia100,
    };
    if (id != null) {
      mapa["id"] = id!;
    }
    return mapa;
  }
}
