local fs = require 'fs'
local path = require 'path'

local function loadCommands(bot)
    local files = fs.readdirSync('commands')

    for _, file in ipairs(files) do
        local name = path.basename(file, '.lua')

        if not file:match('%.lua$') then
            goto continue
        end

        local command = require('./commands/' .. name)
        if not command or type(command.run) ~= 'function' then
            bot.client:error(('Command file "%s" does not return a valid command, skipping'):format(name))
            goto continue
        end

        bot.commands[name] = command
        bot.client:info(('" %s" command loaded'):format(name))

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

        local eventFn = require('./events/' .. name)
        if type(eventFn) ~= 'function' then
            bot.client:error(('Event file "%s" does not return a function, skipping'):format(name))
            goto continue
        end

        bot.events[name] = eventFn
        bot.client:info(('"%s" event handler loaded'):format(name))

        ::continue::
    end

    bot.client:info(table.count(bot.events) .. ' event handler(s) loaded in total')
end

return {
    loadCommands = loadCommands,
    loadEvents = loadEvents
}
