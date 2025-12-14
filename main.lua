local discordia = require 'discordia'
discordia.extensions.string()
discordia.extensions.table()

require 'lib.loadenv'()
local bot = require './bot'

local token = os.getenv('DISCORD_BOT_TOKEN')
assert(
    token,
    '"DISCORD_BOT_TOKEN" is not set in the environment variables'
)

for eventName, eventHandler in pairs(bot.events) do
    bot.client:on(eventName, eventHandler)
end

bot.client:run('Bot ' .. token)