FROM ubuntu:latest

ENV ENCODING=fr_FR.utf8

# Avoid LANG as used by Unices
ARG language=en

ARG USER=pascal

ARG PASS=password

ARG TIMEZONE="Europe/Paris"

RUN printf "$USER $PASS"

RUN useradd $USER -m

RUN echo "$USER:$PASS" | chpasswd

ENV LANGUAGE=$language

LABEL authors="pmunerot" maintainer="Pascal Munerot <pascal.munerot@gmail.com>"

RUN apt-get update -y

RUN apt-get upgrade -y

RUN apt-get install -y curl file micro vim jq xh #yq : is the python version (3.x)

RUN apt-get install -y ruby

RUN gem install asciidoctor asciidoctor-pdf  pygments.rb coderay # rouge

RUN apt-get install -y python3 python3-pip python3-poetry

RUN apt-get install -y pandoc

RUN apt-get install -y default-jre graphviz python3-pandocfilters

RUN printf '#!/bin/sh\njava -jar /usr/bin/plantuml.jar $@' > /usr/bin/plantuml && chmod +x /usr/bin/plantuml

ENV PLANTUML_BIN="/usr/bin/plantuml"

RUN mkdir -p /usr/share/fonts/TTF

COPY fonts/*.ttf /usr/share/fonts/TTF

ENV JAVA_FONTS="/usr/share/fonts/TTF"

RUN apt-get install -y nodejs npm

RUN apt-get install -y node-corepack

RUN corepack enable

RUN npm -g update && npm -g install typescript prettier vite react react-dom react-scripts vuejs nextjs nvm

RUN npm install --g typst 

RUN apt-get install -y python3-jinja2 python3-yaml yamllint xmlindent xmlstarlet xmlformat-doc xmldiff xml-core xml-rs pipx

RUN pipx install uv ruff #TODO:uvx?

RUN apt-get install -y hugo plantuml # kuml-dev

# trying to download and install kuml but seems to download to the local os and not into the image layer ?
ENV KUML_VER="0.49.0"

RUN curl -L -o kuml.zip https://github.com/kuml-dev/kUML/releases/download/${KUML_VER}/kuml-runtime-${KUML_VER}-darwin-arm64.zip
##RUN curl -L -o kuml.zip https://github.com/kuml-dev/kUML/releases/download/${KUML_VER}/kuml-runtime-${KUML_VER}-darwin-arm64.zip
#RUN ls -lh kuml.zip #unzip kuml.zip && export PATH="$PWD/kuml-${KUML_VER}/bin:$PATH"
# RUN curl -L -o./kuml.zip https://github.com/kuml-dev/kUML/releases/download/0.49.0/kuml-runtime-0.49.0-darwin-arm64.zip ; file kuml.zip ; /usr/bin/unzip ./kuml.zip
#&& export PATH="$PWD/kuml-/bin:$PATH"

# RUN apt-get install -y perl && \
#     cpan install YAML && \
#     cpan install PadWalker && \
#     cpan install File::Find && \
#     cpan install File::Copy && \
#     cpan install Getopt::ArgParse && \
#     cpan install Devel::Camelcadedb && \
#     cpan install Net::Server::Log::Log::Log4perl #TODO:Fix tests error / downgrade package?

RUN apt-get install -y libsaxonhe-java

RUN chown -R pascal:users /home/pascal && chmod -R 755 /home/pascal

USER $USER:users

ENV HOME=/home/pascal

ENV GOPATH=$HOME/go

ENV PATH=$PATH:$GOPATH/bin

RUN go install github.com/mikefarah/yq/v4@latest



WORKDIR /src

RUN chdir /src

ENTRYPOINT ["/bin/bash", ""]
