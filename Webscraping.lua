local http = require("socket.http")
local htmlparser = require("htmlparser")

local body = http.request('https://meli.la/2R2WMiA')

local documento = htmlparser.parse(body)

local content = documento:select("div.poly-card__content")
local portada = documento:select("div.poly-card__portada")

local polyContent = content[1]:select("div.poly-component__price")[1]

local title = content[1]:select("a.poly-component__title")[1]:getcontent()

print(title)
local CurrentPrice = ""
local noInteiroPoly = polyContent:select("span.andes-money-amount")[1]:gettext()
CurrentPrice = noInteiroPoly:gsub("<[^>]+>", "")

print(CurrentPrice)

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

print(PreviousPrice)

local discountPercentage
if polyContent:select("div.poly-price__current")[1].nodes[2] ~= nil then
    discountPercentage = polyContent:select("div.poly-price__current")[1].nodes[2]:getcontent()
end

local picture = portada[1]:select("img.poly-component__picture")[1].attributes.src

print(discountPercentage)
print(picture)

local priceInstallments = ""

if polyContent:select("span.poly-price__installments")[1] ~= nil then
    local noInteiro = polyContent:select("span.poly-price__installments")[1]:gettext()
    priceInstallments = noInteiro:gsub("<[^>]+>", "")
end

print(priceInstallments)