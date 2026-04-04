local telegramBot = require("TelegramApi.TelegramApiConfigure")
local AmazonScraping = require("ScappingClasses.AmazonScrapinClass")

local botBotado = telegramBot:new()

local function sendAmazonTextProduct(url)
    local outText = {}

    local amazonClass = AmazonScraping:new(url)
    local root, centerCol = amazonClass:parseHtmlCenter()
    local title = amazonClass:productTitle(centerCol)
    local price = amazonClass:price(centerCol)
    local fromPrice = amazonClass:fromPrice(centerCol)
    local urlImage = amazonClass:productImage(root)
    local bestOffer = amazonClass:bestOffer(centerCol)
    local bestOfferText = string.gsub(bestOffer, "&nbsp;", "")

    if fromPrice == false then
        outText = {
            text = "<b>" .. title .. "</b>" .. "\n" .. 
            "\nPOR APENAS: " .. price .. 
            "\n".. bestOfferText .. 
            "\nACESSANDO PELO LINK: " .. url..
            "\n!!&#129421;Promoção sujeita a alteração, aproveite&#129421;!!",
            imageUrl = urlImage
        }
    else

        outText = {
            text = "<b>" .. title .. "</b>" .. 
            "\n\n" .. "DE: " .. "<del>" .. fromPrice .. "</del>" .. "\n"
            .. "PARA: " .. "<b>" .. price .. "</b>"  .. 
            "\n" .. bestOfferText .. 
            "\n\nACESSANDO PELO LINK: " .. url ..
            "\n\n!!&#129421;Promoção sujeita a alteração, aproveite&#129421;!!",
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
            if string.match(arg, "https://amzn.to/") then
                local amazon = sendAmazonTextProduct(arg)
                botBotado:send_photo(chat_id, amazon.imageUrl, amazon.text, {parse_mode = 'HTML'})
            else
                botBotado:send_message(chat_id, "o link amazon é incompatível, deve conter pelo menos https://amzn.to/")
            end
        elseif cmd == "/mercadolivre" then
            botBotado:send_message(chat_id,"mercado livre está em desenvolvimento atualmente")
        elseif cmd == "/sair" then
            botBotado:send_message(chat_id, "saindo(eu não sai verdadeiramente) &#128123; &#128123;", {parse_mode = 'HTML'})
        else
            botBotado:send_message(chat_id, "Primeiramente saiba que o bot tem apenas UMA funcionalidade, escolha ela abaixo \n" ..
            "/mercado_livre {link} para fazer um anuncio mercado livre a partir de um link \n" ..
            "/amazon {link} para fazer um anuncio amazon a partir de um link\n" ..
            "/sair para sair")
        end
    end
end


return { process_update = process_update }