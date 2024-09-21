local api = {}

local http = require("socket.http")
local cjson = require("cjson")

local get_response_raw = function(name)
	local url = "https://api.genderize.io/?name=" .. name

	local response, status = http.request(url)
	if status == 200 then
		return response
	else
		print("Request failed with " .. status .. " code")
		return nil
	end
end

api.get_response_data = function(name)
	local raw = get_response_raw(name)
	local data = cjson.decode(raw)
	return data
end

return api
