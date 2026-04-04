local ltn12 = require("ltn12")
local http = require("socket.http")
local json = require("cjson")
local htmlparser = require("htmlparser")

AmazonScrapingClass = {}
AmazonScrapingClass.__index = AmazonScrapingClass

function AmazonScrapingClass:new(link)
    local self = setmetatable({}, AmazonScrapingClass)
    self.link = link
    local token = os.getenv("SPLASH_URL")
    if not token then
        error("SPLASH_URL não definido!")
    end
    self.splash = token
    self.lua_script = [[
    function main(splash, args)
        splash:go(args.url)
        splash:wait(2)  -- Wait for JS to execute
        return splash:html()
    end
    ]]
    return self
end

function AmazonScrapingClass:parseHtmlCenter()
    local response = {}
    local request_data = json.encode({
        lua_source = self.lua_script,
        url = self.link
    })
    http.request({
        url = self.splash .. "/execute",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#request_data)
        },
        source = ltn12.source.string(request_data),
        sink = ltn12.sink.table(response)
    })
    local htmlRendered = table.concat(response)
    local root = htmlparser.parse(htmlRendered, 5000)

    return root:select("div#centerCol")[1]
end

function AmazonScrapingClass:parseHtHtmlRoot()
    center = center or true
    local response = {}
    local request_data = json.encode({
        lua_source = self.lua_script,
        url = self.link
    })
    http.request({
        url = self.splash .. "/execute",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#request_data)
        },
        source = ltn12.source.string(request_data),
        sink = ltn12.sink.table(response)
    })
    local htmlRendered = table.concat(response)
    local root = htmlparser.parse(htmlRendered, 7000)
    print("getado: " .. root:gettext())
    return root
end

function AmazonScrapingClass:productTitle(centerCol)
    return centerCol:select("span#productTitle")[1]:getcontent()
end

function AmazonScrapingClass:productImage(root)
    print(root:gettext())
    return root:select("img#landingImage")[1].attributes.src
end


function AmazonScrapingClass:fromPrice(centerCol)
    local fromPrice = centerCol:select("span.apex-basisprice-value")[1]
    if fromPrice ~= nil then
        local precoInicial = string.gsub(fromPrice:select("span.a-offscreen")[1]:getcontent(), "R$", "")
        return precoInicial
    else
        return false
    end
end

function AmazonScrapingClass:price(centerCol)
    local priceHole = centerCol:select("span.apex-pricetopay-value")[1]
    local preco = priceHole.nodes[2].nodes[1]:getcontent() .. priceHole.nodes[2].nodes[2]:getcontent():gsub("<[^>]+>", "") .. priceHole.nodes[2].nodes[3]:getcontent()
    return preco
end


return AmazonScrapingClass