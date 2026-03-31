FROM openresty/openresty:noble

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libreadline-dev \
    libssl-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L -R -O https://www.lua.org/ftp/lua-5.5.0.tar.gz && \
    tar zxf lua-5.5.0.tar.gz && \
    cd lua-5.5.0 && \
    make linux && \
    make install && \
    cd .. && \
    rm -rf lua-5.5.0 lua-5.5.0.tar.gz


# 3. Instalar Luarocks a partir do código-fonte (Isso é CRUCIAL para linkar com o seu Lua 5.5)
RUN apt update && apt install -y \
    luarocks

ENV LUA_PATH="/usr/local/share/lua/5.5/?.lua;/usr/local/share/lua/5.5/?/init.lua;./?.lua;;"
ENV LUA_CPATH="/usr/local/lib/lua/5.5/?.so;;"

RUN apt update && apt install -y \
    lua-socket \
    zlib1g-dev

RUN luarocks install lua-cjson
RUN luarocks install luasocket
RUN luarocks install htmlparser
RUN luarocks install pegasus
RUN luarocks install luasec

WORKDIR /app
COPY . .

# Script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]