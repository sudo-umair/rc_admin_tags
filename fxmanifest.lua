fx_version 'cerulean'
game 'gta5'

name 'rc_admin_tags'
description 'Overhead staff tags for ESX & QBCore, with identifier overrides for txAdmin superadmins'
author 'oo_mayr'
version '1.0.0'

shared_scripts {
    'config.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'bridge/server.lua',
    'server/main.lua',
}
