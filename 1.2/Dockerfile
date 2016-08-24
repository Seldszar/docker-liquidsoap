FROM buildpack-deps:jessie

# Set environment variables
ENV GOSU_VERSION 1.7
ENV OCAML_VERSION 4.02.3
ENV LIQUIDSOAP_VERSION 1.2.1
ENV LIQUIDSOAP_PACKAGES aacplus alsa ao bjack cry dssi faad fdkaac ffmpeg flac frei0r gavl \
  inotify ladspa lame lastfm lo mad ogg opus portaudio pulseaudio samplerate schroedinger \
  soundtouch speex taglib theora voaacenc vorbis xmlplaylist

# Install GOSU
RUN set -x \
  && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
  && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
  && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
  && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true

# Includes non-free packages
RUN sed -i "s/jessie main/jessie main contrib non-free/" /etc/apt/sources.list

# Install dependencies
RUN apt-get update \
  && apt-get install -y --no-install-recommends aspcud libtool-bin sudo unzip

# Install OPAM
RUN wget -O - "https://raw.githubusercontent.com/ocaml/opam/master/shell/opam_installer.sh" | sh -s /usr/local/bin

# Configure the Liquidsoap user
RUN adduser --disabled-password --gecos '' liquidsoap \
  && echo 'liquidsoap ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/liquidsoap

# Set user to `liquidsoap` for installation
WORKDIR /home/liquidsoap

# Install Liquidsoap
RUN gosu liquidsoap bash -c " \
  opam init -a -y --comp $OCAML_VERSION \
    && opam install -y depext \
    && opam depext $LIQUIDSOAP_PACKAGES liquidsoap=$LIQUIDSOAP_VERSION \
    && opam install -y $LIQUIDSOAP_PACKAGES liquidsoap=$LIQUIDSOAP_VERSION"

# Update shared library cache to add the AAC+ library compiled during the Liquidsoap installation
RUN ldconfig

# Copy files into container
COPY docker-entrypoint.sh /

# Setup Docker entrypoint
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

# Launch Liquidsoap
CMD ["liquidsoap"]
