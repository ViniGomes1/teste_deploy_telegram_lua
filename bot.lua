local telegramBot = require("TelegramApi.TelegramApiConfigure")

local function process_update(update)
    if update.message then
        local chat_id = update.message.chat.id
        local text    = update.message.text or ""

        if text == "/start" then
            telegramBot:send_message(chat_id, "Olá! Bot funcionando via webhook!")
        else
            telegramBot:send_message(chat_id, "Você disse: " .. text)
        end
    end
end
return { process_update = process_update }