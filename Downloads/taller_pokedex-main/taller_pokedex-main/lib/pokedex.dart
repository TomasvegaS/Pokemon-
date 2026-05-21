// lib/pokedex.dart

import 'models/pokemon.dart';
import 'services/poke_service.dart';

class Pokedex {
  final PokeService _apiPokemon = PokeService();

  Future<void> buscar(String pokemonBuscado) async {
    print('\n🔎 Buscando información de "$pokemonBuscado"...\n');

    try {
      final Map<String, dynamic> datosPokemon =
          await _apiPokemon.obtenerPokemon(pokemonBuscado);

      final Pokemon pokemon = Pokemon.fromJson(datosPokemon);

      pokemon.mostrar();

    } on Exception catch (error) {
      print('⚠️ Ocurrió un problema: $error');

    } catch (error) {
      print('❌ Error inesperado: $error');

    } finally {
      print('=========== CONSULTA FINALIZADA ===========\n');
    }
  }
}