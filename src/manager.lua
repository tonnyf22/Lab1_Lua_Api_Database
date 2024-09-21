local manager = {}

local db =  require("database")
local api = require("api")

local get_frmtd_output = function(data)
	local d = data
	return
		string.format(
			"name: %s\n" ..
			"gender: %s\n" ..
			"probability: %f",
			d.name,
			d.gender,
			d.probability
		)
end

local data_in_db = function(name)
	local data = db.query_data_by_name(name)
	return data
end

local request_and_write = function(name)
	local data = api.get_response_data(name)
	db.write_data(data)
	return data
end

manager.make_request = function(name)
	db.set_up_connection()
	db.create_model()

	local response_frmtd
	local data

	data = data_in_db(name)
	if data then
		print("Showing fetched info from database... ")
	else
		print("No info in database; requiesting from api... ")
		data = request_and_write(name)
	end

	response_frmtd = get_frmtd_output(data)

	-- db.close_connection()

	return response_frmtd
end

return manager
