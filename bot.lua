local discordia = require 'discordia'
local fs = require 'fs'
local path = require 'path'
local handlers = require './lib/handlers'

local discordiaFilesDir = './discordia_files/'
local created = fs.mkdirSync(discordiaFilesDir)

if created then
    print('Created discordia files directory at "' .. path.resolve(discordiaFilesDir) .. '"')
end

local client = discordia.Client {
    largeThreshold = 30,
    logLevel = discordia.enums.logLevel.debug,
    logFile = discordiaFilesDir .. os.date('%Y-%m-%d') .. '.log',
    gatewayFile = discordiaFilesDir .. 'gateway.json'
}
local prefix = os.getenv('DISCORD_BOT_PREFIX') or '!'

local bot = {
    client = client,
    prefix = prefix,
    commands = {},
    events = {}
}

handlers.loadCommands(bot)
handlers.loadEvents(bot)

return bot