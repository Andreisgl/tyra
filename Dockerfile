# syntax=docker/dockerfile:1

# Toolchain image for building Tyra: the official PS2DEV image plus vclpp.
#
# The base is pinned by digest, so the compiler (GCC 15.2), ps2sdk, bin2c, openvcl
# and dvp-as are exactly the ones this fork was ported and tested against. To move to
# a newer PS2DEV, pull ps2dev/ps2dev, read the new digest from the output, replace it
# below and rebuild the engine.
#
# Tyra's VU programs (engine/src/**/*.vclpp) are built with
#   vclpp -> openvcl -> dvp-as
# openvcl ships with PS2DEV (its image lacks the C++ runtime, added below); vclpp is
# not part of PS2DEV, so it is built here from a pinned commit. Nothing proprietary
# is used.
#
#   docker build -t tyra .

ARG PS2DEV_IMAGE=ps2dev/ps2dev@sha256:1511fde1e42e2c8c192e08a308d9c90d3d69613f6c8022ec71aac7202d477336

FROM ${PS2DEV_IMAGE} AS vclpp-build
RUN apk add --no-cache g++ make git
RUN git clone https://github.com/glampert/vclpp.git /vclpp \
    && git -C /vclpp checkout 6d787b640efaf793f5993ded336951e4136dc3d3 \
    && make -C /vclpp

# ------------------------------------------------------------------------------

FROM ${PS2DEV_IMAGE}

# GNU tools Tyra's Makefile.base uses (find, sed, fmt, cp), git, rsync (the VS Code tasks
# copy sources into the container with it), and the C++ runtime that openvcl and vclpp need.
RUN apk add --no-cache bash make git rsync coreutils findutils sed grep libstdc++ libgcc

COPY --from=vclpp-build /vclpp/vclpp /usr/local/bin/vclpp

WORKDIR /src
CMD ["/bin/bash"]
