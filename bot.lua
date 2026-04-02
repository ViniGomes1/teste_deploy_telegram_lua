local telegramBot = require("TelegramApi.TelegramApiConfigure")
local botBotado = telegramBot:new()

local function process_update(update)
    if update.message then
        local chat_id = update.message.chat.id
        local text    = update.message.text or ""
        local cmd, arg = text:match("^(/(%w+))%s*(.*)$")

        if cmd == "/start" then
            botBotado:send_photo(chat_id, "https://m.media-amazon.com/images/I/61A9XU5z-JL._AC_SX679_.jpg", "<b>Olá! Bot funcionando via webhook!</b>", {parse_mode = 'HTML'})
        else
            botBotado:send_message(chat_id, "Você disse: " .. text)
        end
    end
end
return { process_update = process_update }