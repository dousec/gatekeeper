local array = require './lib/utils/array'

--- @param bot Bot
--- @param message Message
return function(bot, message)
    if message.author.bot or not message.content:lower():startswith(bot.prefix:lower()) then return end
    local fullcommand = message.content:sub(#bot.prefix + 1):trim()
    local name = ''
    local args = {}

    for i, v in ipairs(fullcommand:split(' ')) do
        if v ~= '' then
            if i == 1 then
                name = v:lower()
            else
                args[#args + 1] = v
            end
        end
    end

    local command = bot.commands[name]
    if not command then return end

    local status, err = xpcall(
        function()
            command.run(message, table.unpack(args))
        end,
        debug.traceback
    )
    if not status then
        bot.client:error(
            ('Error executing command "%s":\n%s'):format(name, err)
        )

        message:reply {
            content = 'An internal error occurred at command execution, please try again later.',
            reference = { message = message }
        }
    end
end