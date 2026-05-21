# 🎮 Taller — Pokédex en Dart

**Programación para Dispositivos Móviles**  
Universidad Pontificia Bolivariana · Prof. Luis Castilla

---

## 🎯 Objetivo

Construir una **Pokédex de consola** en Dart que recibe el nombre o ID de un Pokémon, consulta la PokéAPI y muestra su ficha en pantalla.

Al terminar habrás aplicado:

| Concepto                               | Dónde                            |
| -------------------------------------- | -------------------------------- |
| Clases, atributos privados, getters    | `lib/models/pokemon.dart`        |
| Constructor nombrado `.fromJson()`     | `lib/models/pokemon.dart`        |
| `Future<T>`, `async/await`             | `lib/services/poke_service.dart` |
| `try / on Exception / catch / finally` | `lib/pokedex.dart`               |
| Proyecto Dart real con `lib/` y `bin/` | Todo el proyecto                 |

---

## 🌐 API

**Endpoint:** `GET https://pokeapi.co/api/v2/pokemon/{id or name}`  
**Ejemplo:** `https://pokeapi.co/api/v2/pokemon/pikachu`  
**Docs:** https://pokeapi.co/docs/v2#pokemon

Campos de la respuesta que usaremos:

```json
{
  "id": 25,
  "name": "pikachu",
  "base_experience": 112,
  "height": 4,
  "weight": 60,
  "types": [{ "slot": 1, "type": { "name": "electric" } }],
  "stats": [
    { "base_stat": 35, "stat": { "name": "hp" } },
    { "base_stat": 55, "stat": { "name": "attack" } },
    { "base_stat": 40, "stat": { "name": "defense" } },
    { "base_stat": 50, "stat": { "name": "speed" } }
  ],
  "abilities": [
    { "ability": { "name": "static" }, "is_hidden": false },
    { "ability": { "name": "lightning-rod" }, "is_hidden": true }
  ]
}
```

---

## 📁 Estructura del proyecto

```
taller_pokedex/
├── pubspec.yaml              ← dependencias del proyecto
├── bin/
│   └── pokedex.dart          ← ÚNICO void main() — punto de entrada
└── lib/
    ├── pokedex.dart          ← orquestador (une modelo + servicio)
    ├── models/
    │   └── pokemon.dart      ← clases Pokemon y PokemonStat
    └── services/
        └── poke_service.dart ← llamadas a la API
```

> Cada archivo en `lib/` **no tiene `void main()`**.  
> Solo `bin/pokedex.dart` tiene el main y corre todo el programa.

---

## ⚙️ Setup inicial

```bash
# 1. Clona o crea la carpeta
mkdir taller_pokedex && cd taller_pokedex

# 2. Descarga las dependencias
dart pub get

# 3. Cuando tengas todo implementado, corre el proyecto con:
dart run bin/pokedex.dart
```

---

## 🗺️ Fases del taller

El proyecto se construye en **4 fases**. Cada fase corresponde a un archivo en `lib/` (excepto la última que es `bin/`). Completa las fases en orden — cada una depende de la anterior.

```
FASE 1 ──► lib/models/pokemon.dart
FASE 2 ──► lib/services/poke_service.dart
FASE 3 ──► lib/pokedex.dart
FASE 4 ──► bin/pokedex.dart          ← main final
```

---

## 🟢 Fase 1 — El Modelo (`lib/models/pokemon.dart`)

**Conceptos:** clases, atributos privados, constructor `.fromJson()`, getters, mapeo de listas

### Tu trabajo

Completar la clase `Pokemon` para que:

1. Tenga atributos **privados** para todos los campos de la API
2. Tenga un **constructor nombrado** `Pokemon.fromJson(Map<String, dynamic> json)` que los extraiga
3. Exponga cada atributo con un **getter** (sin setters — un Pokémon no cambia)
4. Tenga un método `void mostrar()` que imprima la ficha completa

### Salida esperada de `mostrar()`

```
╔══════════════════════════════════════╗
║  #25 — PIKACHU
║  Altura: 0.4m   Peso: 6.0kg   XP base: 112
║
║  Tipos:       electric
║  Habilidades: static, lightning-rod
║
║  Stats:
║    hp        35  ████████░░░░░░░░
║    attack    55  █████████████░░░
║    defense   40  ██████████░░░░░░
║    speed     50  ████████████░░░░
╚══════════════════════════════════════╝
```

### Cómo verificar esta fase

Agrega temporalmente un `main()` al final del archivo para probar sin API:

```dart
void main() {
  final json = {
    'id': 25,
    'name': 'pikachu',
    'height': 4,
    'weight': 60,
    'base_experience': 112,
    'types': [
      {'slot': 1, 'type': {'name': 'electric'}}
    ],
    'stats': [
      {'base_stat': 35, 'stat': {'name': 'hp'}},
      {'base_stat': 55, 'stat': {'name': 'attack'}},
      {'base_stat': 40, 'stat': {'name': 'defense'}},
      {'base_stat': 50, 'stat': {'name': 'speed'}},
    ],
    'abilities': [
      {'ability': {'name': 'static'},       'is_hidden': false},
      {'ability': {'name': 'lightning-rod'}, 'is_hidden': true},
    ],
  };

  final p = Pokemon.fromJson(json);
  p.mostrar();
}
```

```bash
dart run lib/models/pokemon.dart
```

> ⚠️ Cuando la fase esté completa, **elimina ese `main()` temporal** antes de seguir.

### 💡 Pistas

<details>
<summary>Pista 1 — cómo mapear los tipos (List anidada)</summary>

```dart
// json['types'] es una List<dynamic>
// Cada elemento: { 'slot': 1, 'type': { 'name': 'electric' } }

_types = (json['types'] as List)
    .map((t) => t['type']['name'] as String)
    .toList();
```

</details>

<details>
<summary>Pista 2 — cómo mapear los stats con PokemonStat</summary>

```dart
// json['stats'] es una List<dynamic>
// Cada elemento: { 'base_stat': 35, 'stat': { 'name': 'hp' } }

_stats = (json['stats'] as List)
    .map((s) => PokemonStat(
          s['stat']['name'] as String,
          s['base_stat']    as int,
        ))
    .toList();
```

</details>

<details>
<summary>Pista 3 — altura y peso en unidades legibles</summary>

```dart
// La API retorna decímetros y hectogramos.
// Para mostrar metros y kg:
final alturaM = _height / 10;   // 4 dm → 0.4 m
final pesoKg  = _weight / 10;   // 60 hg → 6.0 kg
```

</details>

<details>
<summary>Pista 4 — cómo usar _barra() en mostrar()</summary>

```dart
// El método _barra() ya está implementado en el esqueleto.
// Úsalo así dentro de mostrar():
for (final stat in _stats) {
  final nombre = stat.nombre.padRight(10);
  final valor  = stat.valor.toString().padLeft(3);
  print('║    $nombre $valor  ${_barra(stat.valor)}');
}
```

</details>

---

## 🌐 Fase 2 — El Servicio (`lib/services/poke_service.dart`)

**Conceptos:** `Future<T>`, `async/await`, HTTP GET, manejo de status codes

### Tu trabajo

Implementar el método `obtenerPokemon(String idONombre)`:

1. Construir la URL con `Uri.parse('$_baseUrl/pokemon/$idONombre')`
2. Hacer `await http.get(url)`
3. Si el status es `200` → decodificar y retornar el JSON
4. Si el status es `404` → lanzar `Exception('Pokémon "$idONombre" no encontrado')`
5. Cualquier otro status → lanzar `Exception('Error del servidor: ${response.statusCode}')`

### Cómo verificar esta fase

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

> ⚠️ Elimina el `main()` temporal cuando la fase esté completa.

### 💡 Pistas

<details>
<summary>Pista 1 — el GET completo</summary>

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> obtenerPokemon(String idONombre) async {
  final url      = Uri.parse('$_baseUrl/pokemon/$idONombre');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  if (response.statusCode == 404) {
    throw Exception('Pokémon "$idONombre" no encontrado');
  }

  throw Exception('Error del servidor: ${response.statusCode}');
}
```

</details>

---

## 🔴 Fase 3 — El Orquestador (`lib/pokedex.dart`)

**Conceptos:** `try / on Exception catch / catch / finally`, composición de clases

### Tu trabajo

Implementar el método `buscar(String idONombre)` en la clase `Pokedex`:

1. Imprimir `'Buscando a "$idONombre"...\n'`
2. Llamar a `_servicio.obtenerPokemon()`
3. Construir `Pokemon.fromJson()` y llamar a `.mostrar()`
4. Manejar errores con `on Exception catch` y `catch`
5. El bloque `finally` siempre imprime `'--- Búsqueda finalizada ---\n'`

### Cómo verificar esta fase

```dart
// Agrega temporalmente al final del archivo:
void main() async {
  final dex = Pokedex();

  await dex.buscar('charmander');   // éxito
  await dex.buscar('pokemonXXX');   // error 404
}
```

```bash
dart run lib/pokedex.dart
```

> ⚠️ Elimina el `main()` temporal cuando la fase esté completa.

### Salida esperada

```
Buscando a "charmander"...

╔══════════════════════════════════════╗
║  #4 — CHARMANDER
║  ...
╚══════════════════════════════════════╝
--- Búsqueda finalizada ---

Buscando a "pokemonXXX"...
❌ Exception: Pokémon "pokemonXXX" no encontrado
--- Búsqueda finalizada ---
```

### 💡 Pistas

<details>
<summary>Pista — estructura del try/on/catch/finally</summary>

```dart
Future<void> buscar(String idONombre) async {
  print('Buscando a "$idONombre"...\n');

  try {
    final json    = await _servicio.obtenerPokemon(idONombre);
    final pokemon = Pokemon.fromJson(json);
    pokemon.mostrar();

  } on Exception catch (e) {
    // Captura solo objetos Exception (los que lanzamos en PokeService)
    print('❌ $e');

  } catch (e) {
    // Captura cualquier otro error (sin internet, timeout, etc.)
    print('💥 Error inesperado: $e');

  } finally {
    // SIEMPRE se ejecuta, haya error o no
    print('--- Búsqueda finalizada ---\n');
  }
}
```

</details>

---

## 🏁 Fase 4 — El Main (`bin/pokedex.dart`)

**Conceptos:** punto de entrada único, `async main`

### Tu trabajo

Con las tres fases anteriores completas, ahora solo tienes que **usar** la `Pokedex`.  
Descomenta las llamadas en `bin/pokedex.dart` y arma tu sesión de búsquedas.

```bash
# Este es el único comando que necesitas para correr todo el proyecto:
dart run bin/pokedex.dart
```

### Salida esperada completa

```
Buscando a "pikachu"...

╔══════════════════════════════════════╗
║  #25 — PIKACHU
║  Altura: 0.4m   Peso: 6.0kg   XP base: 112
║
║  Tipos:       electric
║  Habilidades: static, lightning-rod
║
║  Stats:
║    hp          35  ████████░░░░░░░░
║    attack      55  █████████████░░░
║    defense     40  ██████████░░░░░░
║    speed       50  ████████████░░░░
╚══════════════════════════════════════╝
--- Búsqueda finalizada ---

Buscando a "mewtwo"...

╔══════════════════════════════════════╗
║  #150 — MEWTWO
║  Altura: 2.0m   Peso: 122.0kg   XP base: 340
║
║  Tipos:       psychic
║  Habilidades: pressure, unnerve
║
║  Stats:
║    hp          106  ████████████████
║    attack       110  ████████████████
║    defense       90  ██████████████░░
║    speed        130  ████████████████
╚══════════════════════════════════════╝
--- Búsqueda finalizada ---

Buscando a "pokemonXXX"...
❌ Exception: Pokémon "pokemonXXX" no encontrado
--- Búsqueda finalizada ---
```

---

## ✅ Criterios de entrega

| Criterio               | Descripción                                                      |
| ---------------------- | ---------------------------------------------------------------- |
| Compilación            | `dart run bin/pokedex.dart` corre sin errores                    |
| Fase 1 completa        | `Pokemon.fromJson()` mapea correctamente todos los campos        |
| Fase 2 completa        | `PokeService.obtenerPokemon()` hace el GET y maneja status codes |
| Fase 3 completa        | `Pokedex.buscar()` tiene `try/on/catch/finally` completo         |
| Fase 4 completa        | `main()` busca al menos 3 Pokémon (uno debe fallar)              |
| Código limpio          | Atributos con `_`, getters sin setters, sin `var` sin tipo       |
| Sin `main()` en `lib/` | Los archivos de `lib/` no tienen `void main()` al entregar       |
| Git                    | Un commit por fase: `feat: fase 1 — modelo Pokemon`              |

---

## 🚀 Retos extra (opcionales)

**Reto 1 — ID por parámetro de consola**  
Modifica el `main()` para leer el nombre del Pokémon desde los argumentos de la línea de comandos:

```bash
dart run bin/pokedex.dart pikachu
dart run bin/pokedex.dart 94
```

Pista: `void main(List<String> args)` — `args[0]` es el primer argumento.

**Reto 2 — Solo habilidades no ocultas**  
En `Pokemon.fromJson()`, filtra las habilidades para mostrar solo las que tienen `is_hidden: false`.

**Reto 3 — Comparador**  
Agrega un método `comparar(String poke1, String poke2)` a la clase `Pokedex` que consulte ambos con `Future.wait()` y muestre sus stats lado a lado.

**Reto 4 — Búsqueda por tipo**  
Agrega un método `buscarPorTipo(String tipo)` que use el endpoint `/type/{name}` y liste los primeros 5 Pokémon de ese tipo.  
Endpoint: `https://pokeapi.co/api/v2/type/fire`

---

## 📚 Recursos

| Recurso                    | URL                                                      |
| -------------------------- | -------------------------------------------------------- |
| PokéAPI — endpoint Pokemon | https://pokeapi.co/api/v2/pokemon/pikachu                |
| PokéAPI — docs             | https://pokeapi.co/docs/v2#pokemon                       |
| Paquete `http`             | https://pub.dev/packages/http                            |
| Dart — async/await         | https://dart.dev/libraries/async/async-await             |
| Dart — `dart:convert`      | https://api.dart.dev/stable/dart-convert                 |
| Dart — Future              | https://api.dart.dev/stable/dart-async/Future-class.html |

---

_Programación para Dispositivos Móviles · UPB Bucaramanga · 2025_
