local AmazonScraping = require("ScappingClasses.AmazonScrapinClass")


print("Aguardando Splash inicializar...")
os.execute("sleep 5") 
-- Agora tenta a conexão usando a variável de ambiente
local url = os.getenv("SPLASH_URL")
print(url)

local urlSemPromo = "https://amzn.to/41cCZPD"
local urlComPromo = "https://amzn.to/3PGoWz1" -- com promocao

local amazonClass = AmazonScraping:new(urlSemPromo)
local centerCol = amazonClass:parseHtmlCenter()
local title = amazonClass:productTitle(centerCol)
local price = amazonClass:price(centerCol)
local fromPrice = amazonClass:fromPrice(centerCol)

print(title)
print(price)
print(fromPrice)
