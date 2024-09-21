local mng = require("manager")

io.write("Enter name: ")
local name = io.read()
local response = mng.make_request(name)
print(response)

