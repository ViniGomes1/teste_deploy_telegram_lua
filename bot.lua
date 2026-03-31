local TELEGRAM_TOKEN = os.getenv("TELEGRAM_TOKEN")
local bot = require("telegram-bot-lua").configure(TELEGRAM_TOKEN)

-- Função que processa o update recebido via webhook
function process_update(update)
    if update.message then
        local chat_id = update.message.chat.id
        local text = update.message.text

        if text == "/start" then
            bot.send_message(chat_id, "Olá! Bot funcionando via webhook!")
        end
        -- Adicione seus handlers aqui
    end
end

return { process_update = process_update }