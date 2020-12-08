/*
# ______       ____   ___
#   |     \/   ____| |___|    
#   |     |   |   \  |   |       
#-----------------------------------------------------------------------
# Copyright 2020, tyra - https://github.com/h4570/tyra
# Licenced under Apache License 2.0
# Michał Mostowik <mostek3pl@gmail.com>
*/

#ifndef _PLAYER_
#define _PLAYER_

#define WATER_LEVEL -5.0F

#include "../camera.hpp"
#include <modules/pad.hpp>
#include <tamtypes.h>

class Player
{

public:
    float gravity, velocity, lift;
    Mesh mesh;
    Player();
    ~Player();
    void update(Pad &t_pad);
    const u8 &isJumping() { return bIsJumping; }

private:
    u8 bIsJumping;
    Vector3 playerNextPosition;
};

#endif
