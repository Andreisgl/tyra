# syntax=docker/dockerfile:1
FROM ubuntu:20.04

# Install necessary packages for PS2DEV and VCLPP.
RUN apt-get update
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y git make g++ texinfo bison flex gettext libgmp3-dev \
    libmpfr-dev libmpc-dev gcc binutils cmake wget patch zlib1g-dev libgsl-dev \
    unzip

# Setup PS2DEV env
ENV PS2DEV /usr/local/ps2dev
RUN mkdir -p $PS2DEV
RUN chown -R $USER: $PS2DEV
ENV PS2SDK $PS2DEV/ps2sdk
ENV GSKIT $PS2DEV/gsKit
ENV PATH $PATH:${PS2DEV}/bin:${PS2DEV}/ee/bin:${PS2DEV}/iop/bin:${PS2DEV}/dvp/bin:${PS2SDK}/bin

# Compile PS2DEV (build-all.sh also builds openvcl and masp, the VU tools Tyra uses)
RUN mkdir -p /temp/ps2dev
RUN git clone https://github.com/ps2dev/ps2dev.git /temp/ps2dev
WORKDIR "/temp/ps2dev"
RUN ./build-all.sh

# Compile VCLPP
RUN mkdir -p /temp/vclpp
RUN git clone https://github.com/glampert/vclpp.git /temp/vclpp
WORKDIR "/temp/vclpp"
RUN make

# ------------------------------------------------------------------------------

# Start from clean image
FROM ubuntu:20.04

# Set ENV variables
ENV PS2DEV /usr/local/ps2dev
ENV PS2SDK $PS2DEV/ps2sdk
ENV PATH $PATH:${PS2DEV}/bin:${PS2DEV}/ee/bin:${PS2DEV}/iop/bin:${PS2DEV}/dvp/bin:${PS2SDK}/bin

# Copy stuff from previous stage
COPY --from=0 ${PS2DEV} ${PS2DEV}
COPY --from=0 /temp/vclpp/vclpp /usr/bin/vclpp

# Install packages for Tyra (make, libmpc, psmisc)
RUN apt-get update
RUN apt-get install -y make rsync libmpc-dev psmisc

# Set chmod
RUN chmod 755 /usr/bin/vclpp

WORKDIR /src
CMD ["/bin/bash"]