FROM ubuntu:latest

LABEL authors="pmunerot" maintainer="Pascal Munerot <pascal.munerot@gmail.com>"

LABEL description="docker image with a selection of development and documentation tools"

LABEL version="1.0"

ENV ENCODING=fr_FR.utf8

ARG language=en

ARG groupname=users

ARG username=pascal

ARG pass=password

ARG TIMEZONE="Europe/Paris"

ARG kuml_ver

ENV LANGUAGE=$language

#USER $username:$groupname

RUN useradd $username -m

RUN echo "$username:$pass" | chpasswd

ENV HOME=/home/$username

#RUN chown -R pascal:$groupname /home/$username && chmod -R 755 /home/$username

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y curl file micro vim jq xh coreutils default-jre

RUN apt-get install  --no-install-recommends -y python3 python3-pip pipx  python3-poetry python3-jinja2 python3-yaml yamllint golang delve

RUN apt-get install  --no-install-recommends -y npm nodejs node-corepack && corepack enable

RUN apt-get install  --no-install-recommends -y ruby pandoc graphviz hugo plantuml libsaxonhe-java xmlindent xmlstarlet xmlformat-doc xmldiff xml-core xml-rs && \
    gem install asciidoctor asciidoctor-pdf  pygments.rb coderay

RUN apt-get clean

RUN npm -g update && npm -g install typescript prettier vite react react-dom \
    react-scripts vuejs nextjs nvm openapi-generator openapi-generator-cli typst && \
    rm -rf /var/cache/npm


RUN mkdir -p /usr/share/fonts/TTF /opt/kmul /opt/plantuml

COPY fonts/*.ttf /usr/share/fonts/TTF

ENV JAVA_FONTS="/usr/share/fonts/TTF"

# RUN mkdir -p && mkdir -p

    # RUN apt-get install -y perl && \
    #     cpan install YAML && \
    #     cpan install PadWalker && \
    #     cpan install File::Find && \
    #     cpan install File::Copy && \
    #     cpan install Getopt::ArgParse && \
    #     cpan install Devel::Camelcadedb && \
    #     cpan install Net::Server::Log::Log::Log4perl #TODO:Fix tests error / downgrade package?

RUN pipx install uv ruff && pip cache purge

#RUN printf '#!/bin/bash\njava -jar /usr/bin/plantuml.jar $@' > /usr/bin/plantuml && chmod +x /usr/bin/plantuml

#ENV PLANTUML_BIN="/usr/bin/plantuml"

#COPY /usr/bin/plantuml .

#ENV JAVA_HOME=
#&& \    rm -rf /var/lib/apt/lists/*

COPY lib/kuml.zip .

RUN unzip ./kuml.zip -d /opt/kuml

#RUN curl -L -o kuml.zip https://github.com/kuml-dev/kUML/releases/download/v${KUML_VER}/kuml-runtime-${KUML_VER}-darwin-arm64.zip  && unzip kuml.zip -o -d /opt/kuml && export PATH="/opt/kuml/bin:$PATH" && rm -f kuml.zip

RUN chown -R pascal:$groupname /home/$username && chmod -R 755 /home/$username

COPY . .

ENV PATH=$PATH:$GOPATH/bin:/opt/kuml/bin


#RUN go install github.com/mikefarah/yq/v4@latest
    #&& go install goa.design/goa/v3/cmd/goa@latest \
    #&& go install github.com/fyne/fyne@latest \
    #&& go install -tool github.com/ogen-go/ogen/cmd/ogen@latest \
    #&& go install -tool github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest

WORKDIR /src

#RUN chdir /home/$username

ENTRYPOINT ["/bin/bash", ""]
