// lib/services/poke_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

class PokeService {
  static const String _urlBase = 'https://pokeapi.co/api/v2';

  Future<Map<String, dynamic>> obtenerPokemon(String nombreOId) async {
    final Uri url =
        Uri.parse('$_urlBase/pokemon/${nombreOId.toLowerCase()}');

    final http.Response respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      return jsonDecode(respuesta.body) as Map<String, dynamic>;
    }

    if (respuesta.statusCode == 404) {
      throw Exception(
        'El Pokémon "$nombreOId" no fue encontrado',
      );
    }

    throw Exception(
      'Error del servidor (${respuesta.statusCode})',
    );
  }
}

/*
```dart
// Agrega temporalmente al final del archivo:
void main() async {
  final s = PokeService();

  final json = await s.obtenerPokemon('ditto');
  print('Nombre: ${json['name']}');
  print('ID: ${json['id']}');
}
```

```bash
dart run lib/services/poke_service.dart
```
*/
