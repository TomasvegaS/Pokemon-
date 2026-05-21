// bin/pokedex.dart

import 'package:taller_pokedex/pokedex.dart';

Future<void> main() async {
  final Pokedex pokedex = Pokedex();

  final List<String> pokemones = [
    'pikachu',
    'charizard',
    'mewtwo',
    'pokemonfake'
  ];

  for (final pokemon in pokemones) {
    await pokedex.buscar(pokemon);
  }
}