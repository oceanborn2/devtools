FROM ubuntu:26.10

LABEL authors="pmunerot" \
      maintainer="Pascal Munerot <pascal.munerot@gmail.com>" \
      description="Development and documentation tools image" \
      version="1.0"

# Build arguments
ARG language=fr
ARG language_ext="fr_FR.UTF-8"
ARG language_all="fr_FR"
ARG groupname=users
ARG username=pascal
ARG timezone="Europe/Paris"
ARG kuml_ver

# Environment
ENV DEBIAN_FRONTEND=noninteractive \
    LANGUAGE=${language} \
    LANG=${language_ext} \
    TZ=${timezone} \
    JAVA_FONTS=/usr/share/fonts/TTF \
    GOPATH=/home/${username}/go \
    HOME=/home/${username}

ENV PATH="${PATH}:${GOPATH}/bin:/opt/kuml/bin:/usr/local/bin:${HOME}/.local/bin:${HOME}/.sdkman/bin"

# Base OS + development + documentation packages
RUN apt-get update -qq -y \
    && apt-get install --no-install-recommends -y -qq \
        bash \
        ca-certificates \
        netbase \
        iputils-ping \
        curl \
        file \
        sudo \
        git \
        zip \
        unzip \
        p7zip \
        locales \
        tzdata \
        micro \
        vim \
        jq \
        coreutils \
        default-jre \
        python3 \
        python3-pip \
        pipx \
        python3-poetry \
        python3-jinja2 \
        python3-yaml \
        yamllint \
        golang \
        delve \
        npm \
        nodejs \
        ruby \
        pandoc \
        graphviz \
        hugo \
        plantuml \
        libsaxonhe-java \
        xmlindent \
        xmlstarlet \
        xmlformat-doc \
        xmldiff \
        xml-core \
        xml-rs \
        wget \
        micro \
        bat \
        fzf \
        ripgrep \
        nmap \
#&& \
# sed -i \
#             -e 's/^# *fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' \
#             -e 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' \
#             -e 's/^# *en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' \
#             /etc/locale.gen \
    && locale-gen fr_FR.UTF-8  en_US.UTF-8 en_GB.UTF-8 \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*

# Ruby documentation tools
RUN gem install --no-document \
        asciidoctor \
        asciidoctor-pdf \
        pygments.rb \
        coderay \
    && gem cleanup

# Python tools
RUN pipx install uv && \
    pipx install ruff && \
    pipx install poetry

# Node / Javascript tools
RUN npm install --global \
        typescript \
        prettier \
        vite \
        typst && \
        npm cache clean --force

# Directories
RUN mkdir -p \
        /usr/share/fonts/TTF \
        /opt/kuml

# Fonts
COPY fonts/*.ttf /usr/share/fonts/TTF/

# kUML
# The ZIP is copied explicitly instead of relying on COPY . .
COPY lib/kuml.zip /tmp/kuml.zip

RUN mkdir -p /tmp/kuml /opt/kuml \
    && unzip -q /tmp/kuml.zip -d /tmp/kuml \
    && cp -a /tmp/kuml/kuml-*/. /opt/kuml/ \
    && rm -rf /tmp/kuml /tmp/kuml.zip

# yq and other golang tools
RUN go install github.com/mikefarah/yq/v4@latest # &&   go get -tool github.com/ogen-go/ogen/cmd/ogen@latest &&  go get -tool github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest

# install XH http tooling
RUN XH_VERSION=$(curl -s "https://api.github.com/repos/ducaale/xh/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+') && \
    echo "XH_VERSION: ${XH_VERSION}" && \
    wget -qO xh.tar.gz https://github.com/ducaale/xh/releases/latest/download/xh-v$XH_VERSION-x86_64-unknown-linux-musl.tar.gz && \
    mkdir xh-temp && \
    tar xf xh.tar.gz --strip-components=1 -C xh-temp && \
    mv xh-temp/xh /usr/local/bin && \
    rm -rf xh.tar.gz xh-temp


# OpenAPI Generator
ARG OPENAPI_GENERATOR_VERSION=7.23.0

RUN curl -fsSL \
      "https://repo1.maven.org/maven2/org/openapitools/openapi-generator-cli/${OPENAPI_GENERATOR_VERSION}/openapi-generator-cli-${OPENAPI_GENERATOR_VERSION}.jar" \
      -o /opt/openapi-generator-cli.jar \
 && printf '%s\n' \
      '#!/bin/sh' \
      'exec java -jar /opt/openapi-generator-cli.jar "$@"' \
      > /usr/local/bin/openapi-generator-cli \
 && chmod 755 /usr/local/bin/openapi-generator-cli \
 && openapi-generator-cli version

# User
RUN if ! getent group "${groupname}" >/dev/null; then \
        groupadd "${groupname}"; \
    fi \
    && useradd \
        --create-home \
        --shell /bin/bash \
        --gid "${groupname}" \
        "${username}" \
    && mkdir -p "${GOPATH}" \
    && chown -R "${username}:${groupname}" \
        "/home/${username}" \
        /opt/kuml

RUN chown -R ${username}:${groupname} /home/$username && chmod -R 755 /home/$username

COPY /etc /etc

WORKDIR /home/$username

# Runtime user
USER ${username}

# SDKMAN
RUN curl -s "https://get.sdkman.io" | bash ; \
    echo $HOME \
    chmod a+x "$HOME/.sdkman/bin/sdkman-init.sh" && \
    bash "$HOME/.sdkman/bin/sdkman-init.sh"

#RUN sdk install maven gradle kotlin

CMD ["/bin/bash"]

##########################################################################
# RUN apt-get install -y perl && \
    #     cpan install YAML && \
    #     cpan install PadWalker && \
    #     cpan install File::Find && \
    #     cpan install File::Copy && \
    #     cpan install Getopt::ArgParse && \
    #     cpan install Devel::Camelcadedb && \
    #     cpan install Net::Server::Log::Log::Log4perl #TODO:Fix tests error / downgrade package?


    #&& go install goa.design/goa/v3/cmd/goa@latest \
    #&& go install github.com/fyne/fyne@latest \
