local http = require("socket.http")
local htmlparser = require("htmlparser")

MercadoLivreScrapingClass = {}
MercadoLivreScrapingClass.__index = MercadoLivreScrapingClass

function MercadoLivreScrapingClass:new(link)
    local self = setmetatable({}, MercadoLivreScrapingClass)
    self.link = link
    return self
end

function MercadoLivreScrapingClass:bodyHtml()
    local body = http.request(self.link)
    return htmlparser.parse(body, 3000)
end

function MercadoLivreScrapingClass:content()
    local body = self:bodyHtml()
    return body:select("div.poly-card__content")
end

function MercadoLivreScrapingClass:portada()
    local body = self:bodyHtml()
    return body:select("div.poly-card__portada")
end

function MercadoLivreScrapingClass:polyContent()
    local content = self:content()
    return content[1]:select("div.poly-component__price")[1]
end

function MercadoLivreScrapingClass:title()
    local content = self:content()
    return content[1]:select("a.poly-component__title")[1]:getcontent()
end

function MercadoLivreScrapingClass:currentPrice(polyContent)
    local CurrentPrice = ""
    local noInteiroPoly = polyContent:select("span.andes-money-amount")[1]:gettext()
    CurrentPrice = noInteiroPoly:gsub("<[^>]+>", "")
    return CurrentPrice
end

function MercadoLivreScrapingClass:previousPrice(polyContent)
    local PreviousPrice = ""
    if polyContent:select("s.andes-money-amount")[1] ~= nil then
        if polyContent:select("s.andes-money-amount")[1].nodes[3] ~= nil then
            PreviousPrice = polyContent:select("s.andes-money-amount")[1].nodes[1].nodes[1]:getcontent() .. 
                polyContent:select("s.andes-money-amount")[1].nodes[2]:getcontent() .. 
                polyContent:select("s.andes-money-amount")[1].nodes[3]:getcontent() .. 
                polyContent:select("s.andes-money-amount")[1].nodes[4]:getcontent()
        else
            PreviousPrice = polyContent:select("s.andes-money-amount")[1].nodes[1].nodes[1]:getcontent() .. 
            polyContent:select("s.andes-money-amount")[1].nodes[2]:getcontent()
        end
    end

    return PreviousPrice
end

function MercadoLivreScrapingClass:discountPercentage(polyContent)
    local discountPercentage = ""
    if polyContent:select("div.poly-price__current")[1].nodes[2] ~= nil then
        discountPercentage = polyContent:select("div.poly-price__current")[1].nodes[2]:getcontent()
    end
    return discountPercentage
end


function MercadoLivreScrapingClass:priceInstallments(polyContent)
    local priceInstallments = ""
    if polyContent:select("span.poly-price__installments")[1] ~= nil then
        local noInteiro = polyContent:select("span.poly-price__installments")[1]:gettext()
        priceInstallments = noInteiro:gsub("<[^>]+>", "")
    end
    return priceInstallments
end

function MercadoLivreScrapingClass:picture()
    return self:portada()[1]:select("img.poly-component__picture")[1].attributes.src
end


return MercadoLivreScrapingClass