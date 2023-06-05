# Python Dockerfile
# last update: Cédric FARINAZZO <cedric.farinazzo@alten.com> - 04/04/2022

FROM python:3.9.11-slim-buster

# Create user
ENV USER=app
ENV UID=1000

RUN set -eux; \
    addgroup --system --gid ${UID} ${USER}; \
    adduser --no-create-home --disabled-login --disabled-password --uid ${UID} --ingroup ${USER} ${USER};

# Create app and data folders
ENV WORK_DIR=/app
ENV DATA_DIR=/data
RUN set -eux; \
    mkdir -p ${WORK_DIR} ${DATA_DIR}; \
    chown -R ${USER} ${WORK_DIR}; \
    chown -R ${USER} ${DATA_DIR}

WORKDIR ${WORK_DIR}

# Install tini - https://github.com/krallin/tini
RUN apt-get update && \
    apt-get install -y tini && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Install dependencies
COPY --chown=${USER}:${USER} requirements.txt .
RUN apt-get update && \
    apt-get install -y gcc libmariadb-dev iputils-ping && \
    pip install --no-cache-dir -r ./requirements.txt && \
    apt-get remove -y gcc && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Copy sources
COPY --chown=${USER}:${USER} . ${WORK_DIR}
RUN chmod +x ${WORK_DIR}/docker-entrypoint.sh

# Change to app user
USER ${USER}

# Git hash
ARG GIT_HASH
ENV GIT_HASH=${GIT_HASH:-dev}

ENTRYPOINT ["tini", "--", "./docker-entrypoint.sh"]
