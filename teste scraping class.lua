local AmazonScraping = require("ScappingClasses.AmazonScrapinClass")

local urlSemPromo = "https://amzn.to/41cCZPD"
local urlComPromo = "https://amzn.to/3PGoWz1" -- com promocao
local urlNoPix = "https://amzn.to/41cCZPD"

local amazonClass = AmazonScraping:new(urlNoPix)
local centerCol = amazonClass:parseHtmlCenter()
local title = amazonClass:productTitle(centerCol)
local price = amazonClass:price(centerCol)
local fromPrice = amazonClass:fromPrice(centerCol)

print(title)
print(price)
print(fromPrice)
