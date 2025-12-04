games {'gta5'}

fx_version 'cerulean'

description 'Define zones of different shapes and test whether a point is inside or outside of the zone'
version '2.6.2'

ui_page 'html/clipboard.html'

files {
  'html/clipboard.html'
}

client_scripts {
  'client.lua',
  'BoxZone.lua',
  'EntityZone.lua',
  'CircleZone.lua',
  'ComboZone.lua',
  'creation/client/*.lua',
  'client_viewer.lua'
}

server_scripts {
  'creation/server/*.lua',
  'server.lua',
  'server_viewer.lua'
}
