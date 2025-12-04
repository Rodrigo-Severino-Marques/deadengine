fx_version 'cerulean'
game 'gta5'

author 'DeadEngine'
description 'Sistema de Escala de Peds - Permite alterar o tamanho de players e peds'
version '1.0.0'

dependencies {
    'ox_lib',
    'qbx_core'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html'
}

lua54 'yes'

