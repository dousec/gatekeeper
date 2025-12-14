local array = require './lib/utils/array'

return function (bot)
    return function(message)
        if message.author.bot then return end

        local parts = array.filter(
            message.content:split(' '),
            function(part) return part ~= '' end
        )

        if #parts < 2 or parts[1]:lower() ~= bot.prefix then return end

        local name = parts[2]:lower()
        local args = array.filter(
            parts,
            function(_, index) return index > 2 end
        )
        local command = bot.commands[name]

        if not command then return end
        command.run(message, args)
    end
end