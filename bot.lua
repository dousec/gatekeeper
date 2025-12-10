local discordia = require 'discordia'
local fs = require 'fs'
local discordiaFilesDir = './discordia_files/'

fs.mkdirSync(discordiaFilesDir)
require 'lib.loadenv' ()

local bot = discordia.Client {
    largeThreshold = 30,
    logLevel = discordia.enums.logLevel.debug,
    logFile = discordiaFilesDir .. os.date("%Y-%m-%d") .. '.log',
    gatewayFile = discordiaFilesDir .. 'gateway.json'
}

bot:on('messageCreate', function(message)
    if message.author.bot then return end

    message:reply('alive')
end)

bot:run('Bot ' .. os.getenv('DISCORD_BOT_TOKEN'))
