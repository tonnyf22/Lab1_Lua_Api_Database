local database = {}

local API = require("LuaORM.API")
local Guys;

database.set_up_connection = function()
	API.ORM:initialize({
		connection = "LuaSQL/MySQL",
		database = {
			databaseName = "lua_to_api_to_database",
			host = "127.0.0.1",
			portNumber = 3306,
			userName = "root",
			password = "root"
		},
		logger = { isEnabled = false, isDebugEnabled = false }
	})
end

database.create_model = function()
	local Model = API.Model
	local fieldTypes = API.fieldTypes

	-- define float for LuaORM
	fieldTypes.float = API.FieldType({
		luaDataType = "number",
		SQLDataType = "float"
	})

	Guys = Model({
		name = "guys",
		columns = {
			{ name = "id", isPrimaryKey = true, fieldType = fieldTypes.unsignedIntegerField, unique = true },
			{ name = "name", fieldType = fieldTypes.charField, maxLength = 255 },
			{ name = "gender", fieldType = fieldTypes.charField, maxLength = 255 },
			{ name = "probability", fieldType = fieldTypes.float },
		}
	},
		{ createTable = true }
	)
end

database.get_all_data = function()
	-- -- need to fix this !!!
	-- if not Guys then
	-- 	database.create_model()
	-- end

	local rows = Guys:get():find()
	return rows
end

database.query_data_by_name = function(name)
	local row = Guys:get():where({ name = name }):findOne()
	if row then
		local data = {
			name = row.name,
			gender = row.gender,
			probability = row.probability
		}
		return data
	else
		return nil
	end
end

database.write_data = function(data)
	local d = data
	Guys:new({
		name = d.name,
		gender = d.gender,
		probability = d.probability
	}):save()
end

database.close_connection = function()
	if API.ORM then
		API.ORM:close()
	end
end

return database
