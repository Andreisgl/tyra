/*
# _____        ____   ___
#   |     \/   ____| |___|
#   |     |   |   \  |   |
#-----------------------------------------------------------------------
# Copyright 2022, tyra - https://github.com/h4570/tyra
# Licensed under Apache License 2.0
# Sandro Sobczyński <sandro.sobczynski@gmail.com>
*/

#pragma once

#include <tyra>

namespace Tyra {

class Tutorial09 : public Game {
 public:
  Tutorial09(Engine* engine);
  ~Tutorial09();

  void init();
  void loop();

 private:
  Engine* engine;
};

}  // namespace Tyra
