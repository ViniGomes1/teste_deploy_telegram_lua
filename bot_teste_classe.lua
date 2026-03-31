


-- CODIGGO QUE PEGA
-- bot.lua
local cjson = require("cjson")
local http  = require("resty.http")  -- usa resty.http, não socket.http

-- Lê o token em runtime (não no topo do módulo)
local function get_api_url()
    local token = os.getenv("TELEGRAM_TOKEN")
    if not token then
        error("TELEGRAM_TOKEN não definido!")
    end
    return "https://api.telegram.org/bot" .. token
end

local function send_message(chat_id, text)
    local httpc = http.new()
    local body  = cjson.encode({ chat_id = chat_id, text = text })

    local res, err = httpc:request_uri(get_api_url() .. "/sendMessage", {
        method  = "POST",
        body    = body,
        headers = {
            ["Content-Type"] = "application/json",
        },
        ssl_verify = false,
    })

    if not res then
        ngx.log(ngx.ERR, "Erro ao enviar mensagem: ", err)
    end
end

local function process_update(update)
    if update.message then
        local chat_id = update.message.chat.id
        local text    = update.message.text or ""

        if text == "/start" then
            send_message(chat_id, "Olá! Bot funcionando via webhook!")
        else
            send_message(chat_id, "Você disse: " .. text)
        end
    end
end

--return { process_update = process_update }