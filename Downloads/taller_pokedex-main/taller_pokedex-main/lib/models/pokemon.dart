// lib/models/pokemon.dart

class EstadisticaPokemon {
  final String nombre;
  final int valor;

  EstadisticaPokemon(this.nombre, this.valor);
}

class Pokemon {
  late int _id;
  late String _nombre;
  late int _altura;
  late int _peso;
  late int _experiencia;

  late List<String> _tipos;
  late List<String> _habilidades;
  late List<EstadisticaPokemon> _estadisticas;

  int get id => _id;
  String get nombre => _nombre;
  int get altura => _altura;
  int get peso => _peso;
  int get experiencia => _experiencia;

  List<String> get tipos => _tipos;
  List<String> get habilidades => _habilidades;
  List<EstadisticaPokemon> get estadisticas => _estadisticas;

  Pokemon.fromJson(Map<String, dynamic> datos) {
    _id = datos['id'];
    _nombre = datos['name'];
    _altura = datos['height'];
    _peso = datos['weight'];
    _experiencia = datos['base_experience'];

    _tipos = (datos['types'] as List)
        .map((tipo) => tipo['type']['name'].toString())
        .toList();

    _habilidades = (datos['abilities'] as List)
        .map((habilidad) => habilidad['ability']['name'].toString())
        .toList();

    _estadisticas = (datos['stats'] as List)
        .map(
          (stat) => EstadisticaPokemon(
            stat['stat']['name'],
            stat['base_stat'],
          ),
        )
        .toList();
  }

  String crearBarra(int valor) {
    const int maximo = 150;
    const int tamaño = 18;

    int llenos = ((valor / maximo) * tamaño).round();

    if (llenos > tamaño) {
      llenos = tamaño;
    }

    return '▓' * llenos + '░' * (tamaño - llenos);
  }

  void mostrar() {
    print('\n======================================');
    print('POKÉMON #$_id');
    print(_nombre.toUpperCase());
    print('======================================');

    print('\nXP Base: $_experiencia');
    print('Altura: ${_altura / 10} m');
    print('Peso: ${_peso / 10} kg');

    print('\nTipos: ${_tipos.join(', ')}');
    print('Habilidades: ${_habilidades.join(', ')}');

    print('\nESTADÍSTICAS');

    for (final stat in _estadisticas) {
      print(
        '${stat.nombre.padRight(12)} '
        '${stat.valor.toString().padLeft(3)} '
        '${crearBarra(stat.valor)}',
      );
    }

    print('======================================\n');
  }
}