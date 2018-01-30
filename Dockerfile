FROM snowplow-docker-registry.bintray.io/snowplow/base:0.1.0
# The version of the collector to download.
ENV ENRICH_VERSION="0.13.0"

# The name of the archive to download.
ENV ARCHIVE="snowplow_stream_enrich_${ENRICH_VERSION}.zip"

# Install the Scala Stream Collector.
RUN mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget -q http://dl.bintray.com/snowplow/snowplow-generic/${ARCHIVE} && \
    unzip -d ${SNOWPLOW_BIN_PATH} ${ARCHIVE} && \
    cd /tmp && \
    rm -rf /tmp/build

# Defines an entrypoint script delegating the lauching of stream enrich to the snowplow user.
# The script uses dumb-init as the top-level process.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Customizations by Cru
COPY resolver.json config.hocon ${SNOWPLOW_CONFIG_PATH}/
COPY enrichments ${SNOWPLOW_CONFIG_PATH}/enrichments
WORKDIR /home/snowplow
CMD docker-entrypoint.sh
