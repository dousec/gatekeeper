local discordia = require 'discordia'
local Bot = require './Bot'
local loadenv = require './lib.loadenv'

discordia.extensions.table()
discordia.extensions.string()
loadenv()

local bot = Bot {
    prefix = 'gk',
    filesDir = './discordia_files/'
}

bot:run()