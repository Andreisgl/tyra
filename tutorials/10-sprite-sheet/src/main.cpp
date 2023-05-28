/*
# _____        ____   ___
#   |     \/   ____| |___|
#   |     |   |   \  |   |
#-----------------------------------------------------------------------
# Copyright 2022-2023, tyra - https://github.com/h4570/tyra
# Licensed under Apache License 2.0
# Guido Diego Quispe Robles
# Sandro Sobczyński <sandro.sobczynski@gmail.com>
*/

#include "engine.hpp"
#include "tutorial_10.hpp"

/**
 * In this tutorial we will learn:
 * - How works the offset of the sprite
 * - how works the texture mapping  
 */

int main() {
  Tyra::Engine engine;
  Tyra::Tutorial10 game(&engine);
  engine.run(&game);
  return 0;
}
