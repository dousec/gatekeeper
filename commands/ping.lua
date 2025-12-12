local description = 'Ping command'

--- @param message Message
local function run(message)
    return message:reply('Pong')
end

return {
    description = description,
    run = run
}
