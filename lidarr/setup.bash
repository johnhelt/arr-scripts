#!/usr/bin/with-contenv bash
SMA_PATH="/usr/local/sma"

echo "*** install packages ***" && \
apk add -U --upgrade --no-cache \
  tidyhtml \
  musl-locales \
  musl-locales-lang \
  flac \
  jq \
  git \
  gcc \
  ffmpeg \
  imagemagick \
  opus-tools \
  opustags \
  python3-dev \
  libc-dev \
  py3-pip \
  npm \
  yt-dlp && \
echo "*** install freyr client ***" && \
apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing atomicparsley && \
npm install -g miraclx/freyr-js &&\
echo "*** install beets ***" && \
apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community beets && \
echo "*** install python packages ***" && \
pip install --upgrade --no-cache-dir \
  yq \
  pyacoustid \
  requests \
  pylast \
  mutagen \
  r128gain \
  tidal-dl \
  deemix && \
echo "************ setup SMA ************" && \
echo "************ setup directory ************" && \
mkdir -p ${SMA_PATH} && \
echo "************ download repo ************" && \
git clone https://github.com/mdhiggins/sickbeard_mp4_automator.git ${SMA_PATH} && \
mkdir -p ${SMA_PATH}/config && \
echo "************ create logging file ************" && \
mkdir -p ${SMA_PATH}/config && \
touch ${SMA_PATH}/config/sma.log && \
chgrp users ${SMA_PATH}/config/sma.log && \
chmod g+w ${SMA_PATH}/config/sma.log && \
echo "************ install pip dependencies ************" && \
python3 -m pip install --upgrade pip && \	
pip3 install -r ${SMA_PATH}/setup/requirements.txt

mkdir -p /custom-services.d
echo "Download QueueCleaner service..."
curl "$GITURL/universal/services/QueueCleaner" -o /custom-services.d/QueueCleaner
echo "Done"

echo "Download AutoConfig service..."
curl "$GITURL/lidarr/AutoConfig.service.bash" -o /custom-services.d/AutoConfig
echo "Done"

echo "Download Video service..."
curl "$GITURL/lidarr/Video.service.bash" -o /custom-services.d/Video
echo "Done"

echo "Download Tidal Video Downloader service..."
curl "$GITURL/lidarr/TidalVideoDownloader.bash" -o /custom-services.d/TidalVideoDownloader
echo "Done"

echo "Download Audio service..."
curl "$GITURL/lidarr/Audio.service.bash" -o /custom-services.d/Audio
echo "Done"

echo "Download AutoArtistAdder service..."
curl "$GITURL/lidarr/AutoArtistAdder.bash" -o /custom-services.d/AutoArtistAdder
echo "Done"

echo "Download UnmappedFilesCleaner service..."
curl "$GITURL/lidarr/UnmappedFilesCleaner.bash" -o /custom-services.d/UnmappedFilesCleaner
echo "Done"

mkdir -p /config/extended
echo "Download Script Functions..."
curl "$GITURL/universal/functions.bash" -o /config/extended/functions
echo "Done"

echo "Download PlexNotify script..."
curl "$GITURL/lidarr/PlexNotify.bash" -o /config/extended/PlexNotify.bash 
echo "Done"

echo "Download SMA config..."
curl "$GITURL/lidarr/sma.ini" -o /config/extended/sma.ini 
echo "Done"

if [ ! -f /config/extended/beets-config.yaml ]; then
	echo "Download Beets config..."
	curl "$GITURL/lidarr/beets-config.yaml" -o /config/extended/beets-config.yaml
	echo "Done"
fi

if [ ! -f /config/extended/beets-config-lidarr.yaml ]; then
	echo "Download Beets lidarr config..."
	curl "$GITURL/lidarr/beets-config-lidarr.yaml" -o /config/extended/beets-config-lidarr.yaml
	echo "Done"
fi

echo "Download Deemix config..."
curl "$GITURL/lidarr/deemix_config.json" -o /config/extended/deemix_config.json
echo "Done"

echo "Download Tidal config..."
curl "$GITURL/lidarr/tidal-dl.json" -o /config/extended/tidal-dl.json
echo "Done"

echo "Download LyricExtractor script..."
curl "$GITURL/lidarr/LyricExtractor.bash" -o /config/extended/LyricExtractor.bash
echo "Done"

echo "Download ArtworkExtractor script..."
curl "$GITURL/lidarr/ArtworkExtractor.bash" -o /config/extended/ArtworkExtractor.bash
echo "Done"

echo "Download Beets Tagger script..."
curl "$GITURL/lidarr/BeetsTagger.bash" -o /config/extended/BeetsTagger.bash
echo "Done"

if [ ! -f /config/extended/beets-genre-whitelist.txt ]; then
	echo "Download beets-genre-whitelist.txt..."
	curl "$GITURL/lidarr/beets-genre-whitelist.txt" -o /config/extended/beets-genre-whitelist.txt
	echo "Done"
fi

if [ ! -f /config/extended.conf ]; then
	echo "Download Extended config..."
	curl "$GITURL/lidarr/extended.conf" -o /config/extended.conf
	chmod 777 /config/extended.conf
	echo "Done"
fi

chmod 777 -R /config/extended
chmod 777 -R /root
exit
