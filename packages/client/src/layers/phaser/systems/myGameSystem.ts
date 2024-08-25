import { Has, defineEnterSystem, defineExitSystem, defineSystem, getComponentValueStrict, getComponentValue } from "@latticexyz/recs";
import { PhaserLayer } from "../createPhaserLayer";
import { 
  pixelCoordToTileCoord,
  tileCoordToPixelCoord
} from "@latticexyz/phaserx";
import { TILE_WIDTH, TILE_HEIGHT, Animations, Directions } from "../constants";

function decodePosition(hexString) {
    if (hexString.startsWith('0x')) {
        hexString = hexString.slice(2);
    }

    const halfLength = hexString.length / 2;
    const firstHalfHex = hexString.slice(0, halfLength);
    const secondHalfHex = hexString.slice(halfLength);

    const firstHalfInt32 = getSignedInt32(firstHalfHex);
    const secondHalfInt32 = getSignedInt32(secondHalfHex);

    return { x: firstHalfInt32, y: secondHalfInt32 };
}

function getSignedInt32(hexStr) {
    const int32Value = parseInt(hexStr.slice(-8), 16);

    if (int32Value > 0x7FFFFFFF) {
        return int32Value - 0x100000000;
    }
    return int32Value;
}

function encodePosition(x: number, y: number): string {
    const xHex = int256ToHex(x);
    const yHex = int256ToHex(y);

    // Concatenate the two 32-byte hex values to form a 64-byte hex string
    return '0x' + xHex + yHex;
}

function int256ToHex(value: number): string {
    // If the value is negative, convert it to a 256-bit unsigned integer
    if (value < 0) {
        value = BigInt('0x10000000000000000000000000000000000000000000000000000000000000000') + BigInt(value);
    } else {
        value = BigInt(value);
    }

    // Convert the integer to a hexadecimal string, ensuring it has 64 characters (256 bits)
    let hexStr = value.toString(16);
    while (hexStr.length < 64) {
        hexStr = '0' + hexStr;
    }

    return hexStr;
}

export const createMyGameSystem = (layer: PhaserLayer) => {
  const {
    world,
    networkLayer: {
      components: { Character, Player, SpicePosition },
      systemCalls: { spawn, spawn2, move, move2, attack, attack2, defend, defend2, playerEntity, getPrivateType }
    },
    scenes: {
        Main: { objectPool, input }
    }
  } = layer;

  let startPoint: { x: number; y: number } | null = null;
  let draggedEntity: string | null = null;

  let playerRectangle1 = objectPool.get("PlayerRectangle1", "Rectangle");
  let playerRectangle2 = objectPool.get("PlayerRectangle2", "Rectangle");
  let playerRectangle3 = objectPool.get("PlayerRectangle3", "Rectangle");
  let playerRectangle4 = objectPool.get("PlayerRectangle4", "Rectangle");
  let arrowLine1 = objectPool.get("ArrowLine1", "Line");
  let arrowLine2 = objectPool.get("ArrowLine2", "Line");
  let arrowLine3 = objectPool.get("ArrowLine3", "Line");

  let type1 = objectPool.get("Type1", "Sprite");
  let type2 = objectPool.get("Type2", "Sprite");
  let type3 = objectPool.get("Type3", "Sprite");



  
  let spiceText = objectPool.get("SpiceText", "Text");
  spiceText.setComponent({
    id: "text",
    once: (text) => {
      text.setText("");
      text.setStyle({
        fontSize: "32px",
        fill: "#ffffff",
        backgroundColor: "#000000",
      });
      //text.setVisible(false); // Initially hide the text
    },
  });



  type1.setComponent({
    id: 'animation',
    once: (sprite) => {
      sprite.setPosition(0, 0);
      sprite.visible = false;
      sprite.play(Animations.Water);
    }
  });
  type2.setComponent({
    id: 'animation',
    once: (sprite) => {
      sprite.setPosition(0, 0);
      sprite.visible = false;
      sprite.play(Animations.Fire);
    }
  });
  type3.setComponent({
    id: 'animation',
    once: (sprite) => {
      sprite.setPosition(0, 0);
      sprite.visible = false;
      sprite.play(Animations.Grass);
    }
  });

  let secretCharacterValues = [0, 4, 1, 2, 3];
  let privateSalt = Math.floor(Math.random() * 1000) + 1;
  let privateType = Math.floor(Math.random() * 3) + 1;

  let positionToEntityMap = new Map<string, string>();

  input.pointerdown$.subscribe((event) => {
    const { worldX, worldY } = event.pointer;

    let coordinates = pixelCoordToTileCoord({ x: worldX, y: worldY }, TILE_WIDTH, TILE_HEIGHT);
    const player = getComponentValue(Player, playerEntity);

    if(player
        && coordinates.x == player.x
        && coordinates.y == player.y) {
      startPoint = { x: worldX, y: worldY };
      draggedEntity = `${player.x}-${player.y}`;
    } else {
        spawn2(coordinates.x, coordinates.y);
    }
  });

  input.pointermove$.subscribe((event) => {
    const { worldX, worldY } = event.pointer;

    const currentTile = pixelCoordToTileCoord({ x: worldX, y: worldY }, TILE_WIDTH, TILE_HEIGHT);
    const positionKey = `${currentTile.x}-${currentTile.y}`;
    const destinationOwner = positionToEntityMap.get(positionKey)
    const destinationPlayer = getComponentValue(Player, destinationOwner);
    if(destinationPlayer) {
      spiceText.setComponent({
        id: "text",
        once: (text) => {
          text.setText("Spice: "+destinationPlayer.spice);
          text.setPosition(worldX, worldY-40);
          text.setStyle({
            fontSize: "20px",
            fill: "#ffffff",
            backgroundColor: "#000000",
          });
          text.setVisible(true); // Initially hide the text
        },
      });
    }else{
      spiceText.setComponent({
        id: "text",
        once: (text) => {
          text.setVisible(false); // Initially hide the text
        },
      });
    }

    if (startPoint && draggedEntity) {
        // Draw the main line
        arrowLine1.setComponent({
          id: "line",
          once: (line) => {
            line.visible = true;
            line.isStroked = true;
            line.setFillStyle(0xff00ff);
            line.geom.x1 = startPoint.x;
            line.geom.y1 = startPoint.y;
            line.geom.x2 = worldX;
            line.geom.y2 = worldY;
          },
        });

        // Draw an arrowhead effect at the end point
        const arrowLength = 20;
        const angle = Math.atan2(worldY - startPoint.y, worldX - startPoint.x);

        arrowLine2.setComponent({
          id: "line",
          once: (line) => {
            line.visible = true;
            line.isStroked = true;
            line.setFillStyle(0x00ff00);
            line.geom.x1 = worldX;
            line.geom.y1 = worldY;
            line.geom.x2 = worldX - arrowLength * Math.cos(angle - Math.PI / 6);
            line.geom.y2 = worldY - arrowLength * Math.sin(angle - Math.PI / 6);
          },
        });

        arrowLine3.setComponent({
            id: "line",
          once: (line) => {
            line.visible = true;
            line.isStroked = true;
            line.setFillStyle(0x00ff00);
            line.geom.x1 = worldX;
            line.geom.y1 = worldY;
            line.geom.x2 = worldX - arrowLength * Math.cos(angle + Math.PI / 6);
            line.geom.y2 = worldY - arrowLength * Math.sin(angle + Math.PI / 6);
          },
        });
    }
  });

  input.pointerup$.subscribe((event) => {
    if (startPoint && draggedEntity) {

      const { worldX, worldY } = event.pointer;

      const startTile = pixelCoordToTileCoord(startPoint, TILE_WIDTH, TILE_HEIGHT);
      const endTile = pixelCoordToTileCoord({ x: worldX, y: worldY }, TILE_WIDTH, TILE_HEIGHT);

      const positionKey = `${endTile.x}-${endTile.y}`;
      const destinationOwner = positionToEntityMap.get(positionKey)
      const destinationPlayer = getComponentValue(Player, destinationOwner);
      if(destinationPlayer) {
        attack2("0x" + destinationOwner.slice(26).toLowerCase(), getPrivateType());
      }else{
        //console.log("No player")
      }
      
      startPoint = null;
      draggedEntity = null;
    }
  });

  defineEnterSystem(world, [Has(Character)], ({ entity }) => {
    const character = getComponentValue(Character, entity);

    const characterObj = objectPool.get(entity, "Sprite");
    characterObj.setComponent({
      id: 'animation',
      once: (sprite) => {
        let characterAnimation = character.revealedValue;
        const playerIsOwner = "0x" + playerEntity.slice(26).toLowerCase() == "" + character.owner.toLowerCase()
        if(playerIsOwner) {
          characterAnimation = secretCharacterValues[character.id];
        }
        if(playerIsOwner) {
          const characterPosition = tileCoordToPixelCoord(decodePosition(entity), TILE_WIDTH, TILE_HEIGHT);
          let rectangle = null

          switch (character.id)  {
            case 1:
              rectangle = playerRectangle1;
              break;
            case 2:
              rectangle = playerRectangle2;
              break;
            case 3:
              rectangle = playerRectangle3;
              break;
            case 4:
              rectangle = playerRectangle4;
              break;
          }

          rectangle.setComponent({
            id: "rectangle",
            once: (rectangle) => {
              rectangle.setPosition(characterPosition.x, characterPosition.y);
              rectangle.setSize(32,32);
              rectangle.setFillStyle(0x0000ff);
              rectangle.setAlpha(0.25);
            },
          });

        }
        switch (characterAnimation)  {
          case 1:
            sprite.play(Animations.A);
            break;
          case 2:
            sprite.play(Animations.B);
            break;
          case 3:
            sprite.play(Animations.C);
            break;
          case 4:
            sprite.play(Animations.D);
            break;
          default:
            sprite.play(Animations.Unknown);
        }
      }
    });
  });






  defineEnterSystem(world, [Has(SpicePosition)], ({entity}) => {

    const spiceObj = objectPool.get(entity, "Sprite");
    spiceObj.setComponent({
        id: 'animation',
        once: (sprite) => {
          sprite.play(Animations.Unknown);
        }
    })
  });

  defineSystem(world, [Has(SpicePosition)], ({ entity }) => {
    const spicePosition = decodePosition(entity);

    const spiceExists = getComponentValueStrict(SpicePosition, entity).exists;
    const pixelPosition = tileCoordToPixelCoord({x: spicePosition.x, y: spicePosition.y}, TILE_WIDTH, TILE_HEIGHT);

    const spiceObj = objectPool.get(entity, "Sprite");

    if(spiceExists) {
      spiceObj.setComponent({
        id: "position",
        once: (sprite) => {
          sprite.setPosition(pixelPosition.x, pixelPosition.y);
        }
      })
    }else
    {
      objectPool.remove(entity);
    }
  })








  defineEnterSystem(world, [Has(Player)], ({ entity }) => {
    const player = getComponentValue(Player, entity);
    const pixelPosition = tileCoordToPixelCoord(player, TILE_WIDTH, TILE_HEIGHT);



    const positionKey = `${player.x}-${player.y}`;
    positionToEntityMap.set(positionKey, entity);

    const characterObj = objectPool.get(entity, "Sprite");

    characterObj.setComponent({
      id: 'animation',
      once: (sprite) => {
        sprite.setPosition(pixelPosition.x, pixelPosition.y);
        if(!player.isAttacked)
          sprite.play(Animations.A);
        else
          sprite.play(Animations.Attacked);
      }
    });

    if(player.isAttacked
      && playerEntity == entity) {
        defend2(player.attackerType);
    }
  });

  defineSystem(world, [Has(Player)], ({ entity }) => {
    const player = getComponentValue(Player, entity);
    const pixelPosition = tileCoordToPixelCoord(player, TILE_WIDTH, TILE_HEIGHT);



    const positionKey = `${player.x}-${player.y}`;
    positionToEntityMap.set(positionKey, entity);



    const characterObj = objectPool.get(entity, "Sprite");
    characterObj.setComponent({
      id: 'animation',
      once: (sprite) => {
        sprite.setPosition(pixelPosition.x, pixelPosition.y);

        if(!player.isAttacked) {
          sprite.play(Animations.A);
        }
        else{
          sprite.play(Animations.Attacked);
        }
      }
    });



    if(playerEntity == entity)
    {
      type1.setComponent({
        id: 'animation',
        once: (sprite) => {
          sprite.visible = false;
        }
      });
      type2.setComponent({
        id: 'animation',
        once: (sprite) => {
          sprite.visible = false;
        }
      });
      type3.setComponent({
        id: 'animation',
        once: (sprite) => {
          sprite.visible = false;
        }
      });

      if(getPrivateType() == 1) {
        type1.setComponent({
          id: 'animation',
          once: (sprite) => {
            sprite.setPosition(pixelPosition.x, pixelPosition.y-32);
            sprite.visible = false;//!
          }
        });
      }
      if(getPrivateType() == 2) {
        type2.setComponent({
          id: 'animation',
          once: (sprite) => {
            sprite.setPosition(pixelPosition.x, pixelPosition.y-32);
            sprite.visible = false;//!
          }
        });
      }
      if(getPrivateType() == 3) {
        type3.setComponent({
          id: 'animation',
          once: (sprite) => {
            sprite.setPosition(pixelPosition.x, pixelPosition.y-32);
            sprite.visible = false;//!
          }
        });
      }



      characterObj.setComponent({
        id: 'animation',
        once: (sprite) => {

          if(getPrivateType() == 1) {
            sprite.play(Animations.B);
          }
          if(getPrivateType() == 2) {
            sprite.play(Animations.C);
          }
          if(getPrivateType() == 3) {
            sprite.play(Animations.D);
          }

        }
      });
    }

    if(player.isAttacked
      && playerEntity == entity) {
        defend2(player.attackerType);
    }


    arrowLine1.setComponent({
      id: "line",
      once: (line) => {
        line.visible = false;
      },
    });

    arrowLine2.setComponent({
      id: "line",
      once: (line) => {
        line.visible = false;
      },
    });

    arrowLine3.setComponent({
      id: "line",
      once: (line) => {
        line.visible = false;
      },
    });

    
  });





  defineExitSystem(world, [Has(Character)], ({ entity }) => {
    objectPool.remove(entity);
  });

  defineSystem(world, [Has(Character)], ({ entity }) => {
    const character = getComponentValue(Character, entity);
    if(!character)
      return;
    const pixelPosition = tileCoordToPixelCoord(decodePosition(entity), TILE_WIDTH, TILE_HEIGHT);
    const characterObj = objectPool.get(entity, "Sprite");

    if (character.isDead) {
      characterObj.setComponent({
        id: 'animation',
        once: (sprite) => {
          sprite.play(Animations.Dead);
        }
      });
    } else if (character.attackedAt != 0) {
      characterObj.setComponent({
        id: 'animation',
        once: (sprite) => {
          sprite.play(Animations.Attacked);
        }
      });
    } else
    {
      characterObj.setComponent({
        id: 'animation',
        once: (sprite) => {
          let characterAnimation = character.revealedValue;
          const playerIsOwner = "0x" + playerEntity.slice(26).toLowerCase() == "" + character.owner.toLowerCase()
          if(playerIsOwner) {
            characterAnimation = secretCharacterValues[character.id];
          }
          if(playerIsOwner) {
            //sprite.setBackgroundColor("#0000ff");
          }
          switch (characterAnimation)  {
            case 1:
              sprite.play(Animations.A);
              break;
            case 2:
              sprite.play(Animations.B);
              break;
            case 3:
              sprite.play(Animations.C);
              break;
            case 4:
              sprite.play(Animations.D);
              break;
            default:
              sprite.play(Animations.Unknown);
          }
        }
      });
    }

    characterObj.setComponent({
      id: "position",
      once: (sprite) => {
        sprite.setPosition(pixelPosition.x, pixelPosition.y);
      }
    });

    arrowLine1.setComponent({
      id: "line",
      once: (line) => {
        line.visible = false;
      },
    });

    arrowLine2.setComponent({
      id: "line",
      once: (line) => {
        line.visible = false;
      },
    });

    arrowLine3.setComponent({
      id: "line",
      once: (line) => {
        line.visible = false;
      },
    });
  });

  function calculateDirection(start: { x: number, y: number }, end: { x: number, y: number }) {
    if (end.y < start.y) return Directions.UP;
    if (end.y > start.y) return Directions.DOWN;
    if (end.x < start.x) return Directions.LEFT;
    if (end.x > start.x) return Directions.RIGHT;
    return null;
  }


  input.onKeyPress((keys) => keys.has("W"), () => {
    move2(Directions.UP);
  });

  input.onKeyPress((keys) => keys.has("S"), () => {
    move2(Directions.DOWN);
  });

  input.onKeyPress((keys) => keys.has("A"), () => {
    move2(Directions.LEFT);
  });

  input.onKeyPress((keys) => keys.has("D"), () => {
    move2(Directions.RIGHT);
  });
};