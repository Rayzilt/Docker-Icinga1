FROM debian:stable-slim
LABEL maintainer="Rayzilt - <docker@rayzilt.nl>"

# Set apt non-interactive
ENV DEBIAN_FRONTEND noninteractive

# Install icinga-core
RUN set -x \
	&& apt update \
	&& apt --no-install-recommends install -y lsb-release wget gnupg openssl ca-certificates git\
	&& DEBIAN_CODE_NAME=`lsb_release -c -s` \
	&& wget -O - https://packages.icinga.com/icinga.key | apt-key add - \
	&& echo "deb http://packages.icinga.com/debian icinga-$DEBIAN_CODE_NAME main" | tee /etc/apt/sources.list.d/icinga.list \
	&& apt purge -y lsb-release wget gnupg \
	&& apt update \
	&& echo "icinga-common icinga/check_external_commands boolean true" | debconf-set-selections \
	&& apt --no-install-recommends install -y icinga-core \
	&& apt autoremove --purge -y \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/*

CMD ["bash"]

LABEL org.label-schema.name="Icinga" \
	org.label-schema.description="Icinga Version 1.x" \
	org.label-schema.version=$DATE \
	org.label-schema.usage="https://hub.docker.com/r/rayzilt/icinga1-core" \
	org.label-schema.url="https://icinga.com" \
	org.label-schema.vendor="Rayzilt" \
	org.label-schema.build-date=$DATE \
	org.label-schema.schema-version="1.0" \
