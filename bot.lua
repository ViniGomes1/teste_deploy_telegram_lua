local telegramBot = require("TelegramApi.TelegramApiConfigure")
local AmazonScraping = require("ScappingClasses.AmazonScrapinClass")

local botBotado = telegramBot:new()

local function sendAmazonTextProduct(url)
    local outText = {}

    local amazonClass = AmazonScraping:new(url)
    local root = amazonClass:parseHtmlCenter(false)
    local centerCol = amazonClass:parseHtmlCenter()
    --local title = amazonClass:productTitle(centerCol)
    --local price = amazonClass:price(centerCol)
    print(centerCol:getcontent())
    local fromPrice = amazonClass:fromPrice(centerCol)
    local urlImage = amazonClass:urlImage(root)
    if fromPrice == false then
        outText = {
            --text = "<b>" .. title "</b>" .. "\n" .. "POR APENAS: " .. price .. "\n" .. "ACESSANDO PELO LINK: " .. url,
            imageUrl = urlImage
        }
    else

        outText = {
            --text = "<b>" .. title "</b>" .. "\n" .. "DE: " .. fromPrice .. "\n" .. "PARA: " .. price  .. "\n" .. "\nACESSANDO PELO LINK: " .. url,
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
            print("o arg: " .. arg .. "o cmd: " .. cmd)
            local amazonClass = AmazonScraping:new("https://amzn.to/41cCZPD")
            local root = amazonClass:parseHtmlCenter(false)
            local urlImage = amazonClass:urlImage(root)
            botBotado:send_photo(chat_id, urlImage, "algo", {parse_mode = 'HTML'})
        else
            botBotado:send_message(chat_id, "Você disse: " .. text)
        end
    end
end




return { process_update = process_update }