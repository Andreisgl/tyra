# syntax=docker/dockerfile:1

# The Tyra toolchain image is built once, from the Tyra repository (it is not
# published anywhere):
#   cd <tyra repository> && docker compose build      (or: docker build -t tyra .)
# It already contains git, make, rsync, the PS2DEV toolchain and vclpp.
ARG TYRA_IMAGE=tyra
FROM ${TYRA_IMAGE}

WORKDIR /src
CMD ["/bin/bash"]
