/*
# ______       ____   ___
#   |     \/   ____| |___|    
#   |     |   |   \  |   |       
#-----------------------------------------------------------------------
# Copyright 2020, tyra - https://github.com/h4570/tyra
# Licenced under Apache License 2.0
# Sandro Sobczyński <sandro.sobczynski@gmail.com>
*/

#include "ari.hpp"

int main()
{
    Engine engine = Engine();
    Ari game = Ari(&engine);
    game.engine->init(&game, 128);
    SleepThread();
    return 0;
}
