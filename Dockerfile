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

RUN apt-get install -y curl micro vim jq #yq : is the python version (3.x)

RUN apt-get install -y ruby

RUN gem install asciidoctor asciidoctor-pdf rouge pygments.rb coderay

RUN apt-get install -y python3 python3-pip python3-poetry

RUN apt-get install -y pandoc

RUN apt-get install -y default-jre graphviz python3-pandocfilters

RUN printf '#!/bin/sh\njava -jar /usr/bin/plantuml.jar $@' > /usr/bin/plantuml && chmod +x /usr/bin/plantuml

ENV PLANTUML_BIN="/usr/bin/plantuml"

RUN mkdir -p /usr/share/fonts/TTF

COPY fonts/*.ttf /usr/share/fonts/TTF

ENV JAVA_FONTS="/usr/share/fonts/TTF"

RUN apt-get install -y node-typescript npm yarn

RUN npm install --global typst

RUN apt-get install -y python3-jinja2 python3-yaml yamllint xmlindent xmlstarlet xmlformat-doc xmldiff xml-core xml-rs

RUN apt-get install -y hugo plantuml

RUN chown -R pascal:users /home/pascal && chmod -R 777 /home/pascal

USER $USER:users

ENV HOME=/home/pascal

ENV GOPATH=$HOME/go

ENV PATH=$PATH:$GOPATH/bin

RUN go install github.com/mikefarah/yq/v4@latest


WORKDIR /cv

COPY ./adoc /cv

COPY ./fonts /cv/fonts

COPY ./img /cv/img

COPY ./cv.yaml /cv

#RUN chdir /cv

ENTRYPOINT ["/cv/render.sh", ""]
