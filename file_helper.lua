--[[
    File Helper Module
    Chris Wineland
    2021-09-05
]]

local FileHelper = {}

function FileHelper.get_file_data(file_name)
    local file = io.open(file_name, "rb")
    local file_content = file:read("*all")
    fileio.close()
    return file_content
end

return FileHelper