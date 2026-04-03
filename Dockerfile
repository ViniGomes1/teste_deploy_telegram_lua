FROM openresty/openresty:noble

RUN apt-get update && apt-get install -y \
    curl unzip build-essential libssl-dev\
    && rm -rf /var/lib/apt/lists/*

# Usa o luarocks do próprio OpenResty (compatível com LuaJIT)
RUN /usr/local/openresty/luajit/bin/luajit -e "print('LuaJIT OK')"

RUN opm get ledgetech/lua-resty-http
RUN opm get openresty/lua-resty-string

RUN luarocks install luasec
RUN luarocks install luasocket
RUN luarocks install htmlparser

WORKDIR /app
COPY . .

COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]