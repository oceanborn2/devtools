FROM ubuntu:latest

LABEL authors="pmunerot" maintainer="Pascal Munerot <pascal.munerot@gmail.com>"

LABEL description="docker image with a selection of development and documentation tools"

LABEL version="1.0"

ENV ENCODING=fr_FR.utf8

# Avoid LANG as used by Unices
ARG language=en

ARG groupname=users

ARG username=pascal

ARG pass=password

ARG TIMEZONE="Europe/Paris"

ENV LANGUAGE=$language

#USER $username:$groupname

RUN useradd $username -m

RUN echo "$username:$pass" | chpasswd

ENV HOME=/home/$username

RUN chown -R pascal:$groupname /home/$username && chmod -R 755 /home/$username

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y curl file micro vim jq xh coreutils && \
    apt-get install -y default-jre && \
    apt-get install -y python3 python3-pip pipx  python3-poetry python3-jinja2 python3-yaml yamllint && \
    apt-get install -y golang delve && \
    apt-get install -y ruby && gem install asciidoctor asciidoctor-pdf  pygments.rb coderay && \
    apt-get install -y pandoc graphviz python3-pandocfilters && \
    apt-get install -y nodejs node-corepack npm && \
    corepack enable && \
    apt-get clean

RUN mkdir -p /usr/share/fonts/TTF /opt/kmul /opt/plantuml

COPY fonts/*.ttf /usr/share/fonts/TTF

ENV JAVA_FONTS="/usr/share/fonts/TTF"

## JS & Typescript
RUN npm -g update && npm -g install typescript prettier vite react react-dom \
    react-scripts vuejs nextjs nvm openapi-generator openapi-generator-cli && \
    npm -g install typst && \
    rm -rf /var/cache/npm

    #apt-get install -y hugo plantuml && \
    # && apt-get install -y libsaxonhe-java #xmlindent xmlstarlet xmlformat-doc xmldiff xml-core xml-rs
    # RUN apt-get install -y perl && \
    #     cpan install YAML && \
    #     cpan install PadWalker && \
    #     cpan install File::Find && \
    #     cpan install File::Copy && \
    #     cpan install Getopt::ArgParse && \
    #     cpan install Devel::Camelcadedb && \
    #     cpan install Net::Server::Log::Log::Log4perl #TODO:Fix tests error / downgrade package?

RUN pipx install uv ruff
##&&     pipx cache purge && \    pip cache purge



#RUN printf '#!/bin/bash\njava -jar /usr/bin/plantuml.jar $@' > /usr/bin/plantuml && chmod +x /usr/bin/plantuml
#COPY /usr/bin/plantuml .
#ENV PLANTUML_BIN="/usr/bin/plantuml"
#ENV JAVA_HOME=
#&& \    rm -rf /var/lib/apt/lists/*

# trying to download and install kuml but seems to download to the local os and not into the image layer ?
ENV KUML_VER=0.49.0

COPY lib/kuml.zip .
#RUN curl -L -o kuml.zip https://github.com/kuml-dev/kUML/releases/download/v${KUML_VER}/kuml-runtime-${KUML_VER}-darwin-arm64.zip  && unzip kuml.zip -o -d /opt/kuml && export PATH="/opt/kuml/bin:$PATH" && rm -f kuml.zip
RUN unzip ./kuml.zip -d /opt/kuml

RUN chown -R pascal:$groupname /home/$username && chmod -R 755 /home/$username

ENV PATH=$PATH:$GOPATH/bin:/opt/kuml/bin


RUN go install github.com/mikefarah/yq/v4@latest
    #&& go install goa.design/goa/v3/cmd/goa@latest \
    #&& go install github.com/fyne/fyne@latest \
    #&& go install -tool github.com/ogen-go/ogen/cmd/ogen@latest \
    #&& go install -tool github.com/oapi-codegen/oapi-codegen/v2/cmd/oapi-codegen@latest

WORKDIR /src

RUN chdir /home/$username

ENTRYPOINT ["/bin/bash", ""]
