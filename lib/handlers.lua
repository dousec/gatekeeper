local fs = require 'fs'
local path = require 'path'

local function loadCommands(bot)
    local files = fs.readdirSync('commands')

    for _, file in ipairs(files) do
        local name = path.basename(file, '.lua')

        if not file:match('%.lua$') then
            goto continue
        end

        local command = require('commands.'..name)

        bot.commands[name] = command
        bot.client:info('"' .. name .. '" command loaded')

        ::continue::
    end

    bot.client:info(table.count(bot.commands) .. ' command(s) loaded in total')
end

local function loadEvents(bot)
    local files = fs.readdirSync('events')

    for _, file in ipairs(files) do
        local name = path.basename(file, '.lua')

        if not file:match('%.lua$') then
            goto continue
        end

        local eventHandler = require('events.'..name)

        bot.events[name] = eventHandler(bot)
        bot.client:info('"' .. name .. '" event handler loaded')

        ::continue::
    end

    bot.client:info(table.count(bot.events) .. ' event handler(s) loaded in total')
end

return {
    loadCommands = loadCommands,
    loadEvents = loadEvents
}
