ARG DEBIAN_VERSION

FROM debian:${DEBIAN_VERSION}

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    ruby \
    ruby-dev \
    zlib1g-dev \
    && apt-get purge -y && apt-get autoremove -y && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* \
    && gem update --system \
    && gem install rubygems-update \
    && update_rubygems

ARG GID
ARG GID_NAME
ARG UID
ARG UID_NAME

RUN addgroup --gid ${GID} ${GID_NAME} \
    && adduser --uid ${UID} --ingroup ${GID_NAME} --home /home/${UID_NAME} --shell /bin/bash --disabled-password --gecos "" ${UID_NAME}

COPY --chown=${UID_NAME}:${GID_NAME} _data /home/${UID_NAME}/

USER ${UID_NAME}
WORKDIR /home/${UID_NAME}/_data
