fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'

author "68_zoom"
description '68_zoom - Camera zoom functionality'
version "1.0.0"

client_scripts {
    'client/zoom.lua',
}

server_script 'version.lua'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
}

ox_lib 'locale'

files {
    'classes/zoom.lua',
    'modules/**/*.lua',
    'locales/*.json',
}
