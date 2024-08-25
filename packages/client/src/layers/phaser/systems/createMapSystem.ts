import { Tileset } from "../../../artTypes/world";
import { PhaserLayer } from "../createPhaserLayer";

export function createMapSystem(layer: PhaserLayer) {
  const {
    scenes: {
      Main: {
        maps: {
          Main: { putTileAt },
        },
      },
    },
  } = layer;

  const mapSize = 32; // Esto creará un mapa de 32x32 tiles (de -16 a 15)

  // Llenar todo el mapa con césped
  for (let x = -mapSize; x < mapSize; x++) {
    for (let y = -mapSize; y < mapSize; y++) {
      const coord = { x, y };
      putTileAt(coord, Tileset.Grass, "Background");
    }
  }

  // Colocar elementos en posiciones específicas en relación al centro
  const placeCenteredTiles = () => {
    putTileAt({ x: -1, y: 1 }, Tileset.Mountain, "Foreground"); // Primera posición
    putTileAt({ x: -1, y: 2 }, Tileset.Mountain, "Foreground"); // Primera posición
    putTileAt({ x: -1, y: 3 }, Tileset.Mountain, "Foreground"); // Primera posición
    putTileAt({ x: -1, y: 4 }, Tileset.Mountain, "Foreground"); // Primera posición
    putTileAt({ x: -1, y: 5 }, Tileset.Mountain, "Foreground"); // Primera posición
    putTileAt({ x: -1, y: 6 }, Tileset.Mountain, "Foreground"); // Primera posición
    putTileAt({ x: -2, y: 2 }, Tileset.Forest, "Foreground");   // Segunda posición
    putTileAt({ x: -3, y: 3 }, Tileset.Flower, "Foreground");   // Tercera posición
    putTileAt({ x: -4, y: 4 }, Tileset.Stuff, "Foreground");    // Cuarta posición
  };

  placeCenteredTiles();

  // Colocar elementos aleatoriamente en el mapa
  const placeRandomTiles = (tileset: Tileset, quantity: number) => {
    for (let i = 0; i < quantity; i++) {
      const randomX = getRandomInt(-mapSize, mapSize - 1);
      const randomY = getRandomInt(-mapSize, mapSize - 1);
      putTileAt({ x: randomX, y: randomY }, tileset, "Foreground");
    }
  };

  // Función para generar un número aleatorio entre min y max (ambos inclusive)
  const getRandomInt = (min: number, max: number) => {
    return Math.floor(Math.random() * (max - min + 1)) + min;
  };

  // Definir cuántos de cada tile se colocarán aleatoriamente
  const mountainCount = getRandomInt(200, 200); // Número de montañas
  const forestCount = getRandomInt(200, 200);   // Número de bosques
  const flowerCount = getRandomInt(200, 200);   // Número de flores
  const stuffCount = getRandomInt(200, 200);    // Número de "stuff"

  // Colocar montañas, bosques, flores y stuff aleatoriamente
  placeRandomTiles(Tileset.Mountain, mountainCount);
  placeRandomTiles(Tileset.Forest, forestCount);
  placeRandomTiles(Tileset.Flower, flowerCount);
  placeRandomTiles(Tileset.Stuff, stuffCount);
}
