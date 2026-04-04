local telegramBot = require("TelegramApi.TelegramApiConfigure")
local AmazonScraping = require("ScappingClasses.AmazonScrapinClass")

local botBotado = telegramBot:new()

local function sendAmazonTextProduct(url)
    local outText = {}

    local amazonClass = AmazonScraping:new(url)
    local root = amazonClass:parseHtmlCenter()
    local centerCol = amazonClass:parseHtHtmlRoot()
    local title = amazonClass:productTitle(centerCol)
    local price = amazonClass:price(centerCol)
    local fromPrice = amazonClass:fromPrice(centerCol)
    local urlImage = amazonClass:productImage(root)
    
    if fromPrice == false then
        outText = {
            text = "<b>" .. title "</b>" .. "\n" .. "POR APENAS: " .. price .. "\n" .. "ACESSANDO PELO LINK: " .. url,
            imageUrl = urlImage
        }
    else

        outText = {
            text = "<b>" .. title "</b>" .. "\n" .. "DE: " .. fromPrice .. "\n" .. "PARA: " .. price  .. "\n" .. "\nACESSANDO PELO LINK: " .. url,
            imageUrl = urlImage
        }
    end

    return outText
end

local function process_update(update)
    if update.message then
        local chat_id = update.message.chat.id
        local text    = update.message.text or ""
        local cmd, arg = text:match("([^%s]+)%s+(.+)")

        if cmd == "/amazon" then
            local amazon = sendAmazonTextProduct("https://amzn.to/41cCZPD")
            botBotado:send_photo(chat_id, amazon.imageUrl, amazon.text, {parse_mode = 'HTML'})
        else
            botBotado:send_message(chat_id, "Você disse: " .. text)
        end
    end
end




return { process_update = process_update }