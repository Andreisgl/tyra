/*
# ______       ____   ___
#   |     \/   ____| |___|
#   |     |   |   \  |   |
#-----------------------------------------------------------------------
# Copyright 2022, tyra - https://github.com/h4570/tyra
# Licenced under Apache License 2.0
# Sandro Sobczyński <sandro.sobczynski@gmail.com>
*/

#include "states/game/debug_object.hpp"
#include <loaders/3d/obj_loader/obj_loader.hpp>
#include <file/file_utils.hpp>

using Tyra::Color;
using Tyra::FileUtils;
using Tyra::ObjLoader;

namespace Demo {

DebugObject::DebugObject(TextureRepository* repo) {
  ObjLoader loader;
  auto* data =
      loader.load(FileUtils::fromCwd("game/models/debug.obj"), 1, .5F, true);
  data->normalsEnabled = false;
  data->textureCoordsEnabled = false;
  mesh = new StaticMesh(*data);
  delete data;
  mesh->getMaterial(0)->color = Color(192.0F, 32.0F, 32.0F, 128.0F);
  rotator = 0.0F;
  allocateOptions();

  pair = new RendererStaticPair{mesh, options};
}

void DebugObject::setPosition(const Vec4& v) {
  mesh->translation.identity();
  mesh->rotation.identity();
  mesh->translation.translate(v);
  mesh->rotation.rotateX(rotator);
  mesh->rotation.rotateY(rotator);
  mesh->rotation.rotateZ(rotator);

  rotator += 0.05F;
  if (rotator >= 360.0F) rotator = 0.0F;
}

DebugObject::~DebugObject() {
  delete mesh;
  delete options;
  delete pair;
}

void DebugObject::allocateOptions() {
  options = new StaPipOptions();
  options->shadingType = Tyra::TyraShadingGouraud;
  options->blendingEnabled = false;
  options->antiAliasingEnabled = false;
}

}  // namespace Demo
