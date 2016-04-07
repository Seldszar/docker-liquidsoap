FROM debian:jessie

ENV OCAML_VERSION 4.02.3
ENV LIQUIDSOAP_VERSION 1.2.0

RUN echo "deb http://www.deb-multimedia.org jessie main non-free" > /etc/apt/sources.list.d/debian-multimedia.list

RUN apt-get update
RUN apt-get dist-upgrade -y

RUN apt-get install -y --allow-unauthenticated deb-multimedia-keyring
RUN apt-get update

# Install dependencies
RUN apt-get install -y autoconf automake build-essential bzip2 libfftw3-dev libpcre3-dev libtool-bin m4 patch pkg-config unzip wget
RUN apt-get install -y dssi-dev frei0r-plugins-dev ladspa-sdk libao-dev libasound2-dev libavutil-dev libfaad-dev libfdk-aac-dev libflac-dev libgavl-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libjack-dev liblo-dev libmad0-dev libopus-dev libmp3lame-dev libogg-dev libpulse-dev libsamplerate0-dev libschroedinger-dev libsoundtouch0-dev libspeex-dev libswscale-dev libtag1-dev libvo-aacenc-dev libvorbis-dev libtheora-dev portaudio19-dev ncurses-dev

# Download, compile & install AAC+ library
RUN wget "http://tipok.org.ua/downloads/media/aacplus/libaacplus/libaacplus-2.0.2.tar.gz"
RUN tar -zxvf libaacplus-2.0.2.tar.gz
WORKDIR libaacplus-2.0.2
RUN ./autogen.sh --enable-shared --enable-static
RUN make
RUN make install
RUN ldconfig

# Install OPAM
RUN wget "https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh" -O - | sh -s /usr/local/bin

# Create the Liquidsoap user
RUN adduser --disabled-password --gecos '' liquidsoap
USER liquidsoap

# Install Liquidsoap
RUN opam init -a -y --comp $OCAML_VERSION

# Set OCAML related environment variables (`opam config env` workaround)
ENV CAML_LD_LIBRARY_PATH "/home/liquidsoap/.opam/$OCAML_VERSION/lib/stublibs"
ENV MANPATH "/home/liquidsoap/.opam/$OCAML_VERSION/man:$MANPATH"
ENV PERL5LIB "/home/liquidsoap/.opam/$OCAML_VERSION/lib/perl5"
ENV OCAML_TOPLEVEL_PATH "/home/liquidsoap/.opam/$OCAML_VERSION/lib/toplevel"
ENV PATH "/home/liquidsoap/.opam/$OCAML_VERSION/bin:$PATH"

# Install Liquidsoap & dependencies
RUN opam install -y aacplus alsa ao bjack cry dssi cry dssi faad fdkaac ffmpeg flac frei0r gavl inotify ladspa lame lastfm lo mad ogg opus portaudio pulseaudio samplerate schroedinger soundtouch speex taglib theora voaacenc vorbis xmlplaylist
RUN opam install -y liquidsoap=$LIQUIDSOAP_VERSION

ENTRYPOINT ["liquidsoap"]
