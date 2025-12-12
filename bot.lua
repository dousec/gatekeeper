local discordia = require 'discordia'
local fs = require 'fs'
local path = require 'path'

package.loaded.discordia = discordia
package.loaded.fs = fs
package.loaded.path = path

discordia.extensions.string()
discordia.extensions.table()

local array = require 'lib.utils.array'
local loadenv = require 'lib.loadenv'
local loadCommands = require 'lib.commands'

local discordiaFilesDir = './discordia_files/'
fs.mkdirSync(discordiaFilesDir)

local bot = discordia.Client {
    largeThreshold = 30,
    logLevel = discordia.enums.logLevel.debug,
    logFile = discordiaFilesDir .. os.date('%Y-%m-%d') .. '.log',
    gatewayFile = discordiaFilesDir .. 'gateway.json'
}

local prefix = 'gk'
local commands = loadCommands(bot)

bot:on('messageCreate', function(message)
    if message.author.bot then return end

    local parts = array.filter(
        message.content:split(' '),
        function(part) return part ~= '' end
    )

    if #parts < 2 or parts[1]:lower() ~= prefix then return end

    local name = parts[2]:lower()
    local args = array.filter(
        parts,
        function(_, index) return index > 2 end
    )

    local command = commands[name]
    if not command then return end

    command.run(message, args)
end)

loadenv()
bot:run('Bot ' .. os.getenv('DISCORD_BOT_TOKEN'))
