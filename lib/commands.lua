local fs = require 'fs'
local path = require 'path'

local map = require 'lib.utils.array'.map

local function load(bot)
    local commands = {}
    local files = fs.readdirSync('commands')

    for _, file in ipairs(files) do
        local name = path.basename(file, '.lua')

        if not file:match('%.lua$') then
            goto continue
        end

        local command = require('commands.'..name)

        commands[name] = command
        bot:info('"'..name..'" command loaded')

        ::continue::
    end

    ---@diagnostic disable-next-line: undefined-field
    bot:info(table.count(commands)..' command(s) loaded in total')

    return commands
end

return load