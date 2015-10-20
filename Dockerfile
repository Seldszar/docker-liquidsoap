FROM debian:jessie
MAINTAINER Alexandre Breteau contact@seldszar.fr

# OCAML environment version to install
ENV OCAML_VERSION 4.02.3

# Upgrade distribution
RUN apt-get -q -y update

# Install system-wide dependencies
RUN apt-get -q -y install wget git make autoconf automake supervisor

# Install Liquidsoap dependencies
RUN apt-get -q -y install libpcre3-dev libao-dev libmad0-dev libshout3-dev \
  libvorbis-dev libid3tag0-dev libasound2-dev liblo-dev libfaad-dev \
  libflac-dev ladspa-sdk libsoundtouch-dev libjack-dev libsamplerate0-dev \
  libtag1-dev lame libmp3lame-dev libshine-dev libopus-dev libschroedinger-dev \
  libvo-aacenc-dev libportaudio-ocaml-dev libpulse-ocaml-dev \
  libgstreamer-ocaml-dev libgavl-ocaml-dev libavutil-dev libswscale-dev \
  libfrei0r-ocaml-dev dssi-dev libfaad-dev

# Install OCAML dependencies
RUN apt-get -q -y install opam ocaml-findlib libpcre-ocaml-dev libtool

# Clear APT cache
RUN apt-get clean

# Liquidsoap compilation needs a non-root user
RUN adduser --disabled-password --gecos '' liquidsoap
USER liquidsoap

# Go to Liquidsoap user home directory
WORKDIR /home/liquidsoap

# Clone Liquidsoap repository
RUN git clone --recursive https://github.com/savonet/liquidsoap-full.git

# Initialize OCAML
RUN opam init --comp $OCAML_VERSION

# Set OCAML related environment variables
ENV CAML_LD_LIBRARY_PATH "/home/liquidsoap/.opam/$OCAML_VERSION/lib/stublibs"
ENV MANPATH "/home/liquidsoap/.opam/$OCAML_VERSION/man:$MANPATH"
ENV MAKELEVEL ""
ENV MAKEFLAGS ""
ENV PERL5LIB "/home/liquidsoap/.opam/$OCAML_VERSION/lib/perl5"
ENV OCAML_TOPLEVEL_PATH "/home/liquidsoap/.opam/$OCAML_VERSION/lib/toplevel"
ENV PATH "/home/liquidsoap/.opam/$OCAML_VERSION/bin:$PATH"

# Install Liquidsoap OCAML dependencies
RUN opam install -y ocamlfind dtools duppy mm pcre xmlm camomile

# Go to Liquidsoap repository
WORKDIR liquidsoap-full

# Copy provided package file
COPY ./PACKAGES ./

# Configure Liquidsoap
RUN ./configure

# Compile Liquidsoap
RUN make

# Returns to root user
USER root

# Install Liquidsoap
RUN make install

# Set executable permissions
RUN touch /run.sh && chmod 777 /run.sh

# Copy Supervisor files
COPY ./supervisor.sh /
COPY ./supervisord.conf /etc/

# Run Liquidsoap help command if no arguments are defined
CMD ["liquidsoap", "--help"]

# Define Liquidsoap as entry point
ENTRYPOINT ["liquidsoap"]
