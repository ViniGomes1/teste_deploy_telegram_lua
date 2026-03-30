FROM openresty/openresty:noble

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    build-essential \
    libreadline-dev \
    libssl-dev \
    unzip \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L -R -O https://www.lua.org/ftp/lua-5.5.0.tar.gz && \
    tar zxf lua-5.5.0.tar.gz && \
    cd lua-5.5.0 && \
    make linux && \
    make install && \
    cd .. && \
    rm -rf lua-5.5.0 lua-5.5.0.tar.gz


# 3. Instalar Luarocks a partir do código-fonte (Isso é CRUCIAL para linkar com o seu Lua 5.5)
RUN wget https://luarocks.org/releases/luarocks-3.11.1.tar.gz && \
    tar zxpf luarocks-3.11.1.tar.gz && \
    cd luarocks-3.11.1 && \
    ./configure --prefix=/usr/local/openresty/luajit \
                --with-lua=/usr/local/openresty/luajit \
                --lua-suffix=jit \
                --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 && \
    make && \
    make install && \
    cd .. && \
    rm -rf luarocks-3.11.1*

ENV PATH="/usr/local/openresty/luajit/bin:${PATH}"

RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN luarocks install telegram-bot-lua && \
    luarocks install lua-cjson && \
    luarocks install luasocket && \
    luarocks install htmlparser && \
    luarocks install pegasus && \
    luarocks install luasec

WORKDIR /app
COPY . .

# Script de inicialização
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]