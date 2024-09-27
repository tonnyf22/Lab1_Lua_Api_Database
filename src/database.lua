local database = {}

local API = require("LuaORM.API")
local Guys;

local connection_values = function()
	local vals = {
		db_name = "lua_to_api_to_database",
		db_host = "127.0.0.1",
		db_port = 3306,
		db_usr = "root",
		db_pass = "root",
	}

	local db_init_file = io.open("db_init.txt", "r")
	if db_init_file then
		vals.db_name = db_init_file:read("*line")
		vals.db_host = db_init_file:read("*line")
		vals.db_port = db_init_file:read("*line").tonumber()
		vals.db_usr = db_init_file:read("*line")
		vals.db_pass = db_init_file:read("*line")
		vals.db_init_file:close()
	end

	return vals
end

database.set_up_connection = function()
	local db_conn = connection_values()

	API.ORM:initialize({
		connection = "LuaSQL/MySQL",
		database = {
			databaseName = db_conn.db_name,
			host = db_conn.db_host,
			portNumber = db_conn.db_port,
			userName = db_conn.db_usr,
			password = db_conn.db_pass
		},
		logger = { isEnabled = false, isDebugEnabled = false }
	})
end

database.create_model = function()
	local Model = API.Model
	local fieldTypes = API.fieldTypes

	-- define float for LuaORM
	fieldTypes.double = API.FieldType({
		luaDataType = "number",
		SQLDataType = "double"
	})

	Guys = Model({
		name = "guys",
		columns = {
			{ name = "id", isPrimaryKey = true, fieldType = fieldTypes.unsignedIntegerField, unique = true },
			{ name = "name", fieldType = fieldTypes.charField, maxLength = 255 },
			{ name = "gender", fieldType = fieldTypes.charField, maxLength = 255 },
			{ name = "probability", fieldType = fieldTypes.double },
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
