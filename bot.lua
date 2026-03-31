-- bot.lua

local cjson = require("cjson")
local http  = require("socket.http")
local ltn12 = require("ltn12")

local TOKEN = os.getenv("TELEGRAM_TOKEN")
local API   = "https://api.telegram.org/bot" .. TOKEN

-- Envia mensagem via API REST pura (sem depender da lib)
local function send_message(chat_id, text)
    local body = cjson.encode({
        chat_id = chat_id,
        text    = text
    })

    local response = {}
    http.request({
        url     = API .. "/sendMessage",
        method  = "POST",
        headers = {
            ["Content-Type"]   = "application/json",
            ["Content-Length"] = #body
        },
        source = ltn12.source.string(body),
        sink   = ltn12.sink.table(response)
    })
end

-- Processa o update recebido pelo webhook
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

return { process_update = process_update }