/*
# ______       ____   ___
#   |     \/   ____| |___|    
#   |     |   |   \  |   |       
#-----------------------------------------------------------------------
# Copyright 2020, tyra - https://github.com/h4570/tyra
# Licenced under Apache License 2.0
# Sandro Sobczyński <sandro.sobczynski@gmail.com>
*/

#ifndef _TYRA_MD2_MODEL_
#define _TYRA_MD2_MODEL_

#include <tamtypes.h>
#include <math3d.h>
#include "math/vector3.hpp"
#include "math/point.hpp"

typedef struct
{
    u32 startFrame;
    u32 endFrame;
    float speed;
    float interpolation;
    u32 animType;
    u32 currentFrame;
    u32 nextFrame;
} MD2AnimState;

typedef struct
{
    u16 verticeIndexes[3];
    u16 coordIndexes[3];
} MD2Triangle;

/** Class which have common types for all 3D objects */
class MD2Model
{

public:
    u32 verticesPerFrameCount, framesCount, coordinatesCount, trianglesCount;
    Vector3 *vertices __attribute__((aligned(16)));
    Point *coordinates;
    u32 *normalIndexes;
    MD2Triangle *triangles;
    MD2AnimState animState;
    /** File name without extension */
    char *filename;
    MD2Model(char *t_md2File);
    ~MD2Model();
    u32 getCurrentFrameData(VECTOR *o_vertices, VECTOR *o_normals, VECTOR *o_coordinates, VECTOR *o_colors, Vector3 &t_cameraPos, float t_scale, u8 t_shouldBeBackfaceCulled);
    void allocateMemory();

private:
    Vector3 calcVector;
    Vector3 calc3Vectors[3];
};

#endif
