-- bot.lua
local cjson = require("cjson")
local http  = require("resty.http")  -- usa resty.http, não socket.http

print("Achado telegram api")

TelegramApiConfigure = {}
TelegramApiConfigure.__index = TelegramApiConfigure

function TelegramApiConfigure:new()
    local self = setmetatable({}, TelegramApiConfigure)
    self.link = "https://api.telegram.org/bot"
    return self
end

function TelegramApiConfigure:get_api_url()
    local token = os.getenv("TELEGRAM_TOKEN")
    if not token then
        error("TELEGRAM_TOKEN não definido!")
    end
    return self.link .. token
end

function TelegramApiConfigure:send_message(chat_id, text, opts)
    opts = opts or {}
    local httpc = http.new()
    local body  = cjson.encode({
        chat_id = chat_id, 
        text = text,
        parse_mode = opts.parse_mode
    })

    local res, err = httpc:request_uri(self.get_api_url .. "/sendMessage", {
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

return TelegramApiConfigure