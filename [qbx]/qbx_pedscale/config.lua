Config = {}

-- Configurações de Escala
Config.MinScale = 0.3          -- Escala mínima (30% do tamanho normal)
Config.MaxScale = 2.0           -- Escala máxima (200% do tamanho normal)
Config.DefaultHeight = 180      -- Altura padrão em centímetros (1.80m)
Config.DefaultScale = 1.0       -- Escala padrão

-- Permissões
Config.AdminOnly = false        -- Se true, apenas admins podem usar comandos
Config.AdminPermission = 'admin' -- Permissão necessária se AdminOnly = true

-- Comandos
Config.Commands = {
    scale = 'scale',            -- /scale <centímetros> - Define altura em cm
    setscale = 'setscale',      -- /setscale <escala> - Define escala diretamente
    big = 'big',                -- /big - Aumenta tamanho
    small = 'small',            -- /small - Diminui tamanho
    reset = 'resetscale',       -- /resetscale - Reseta para tamanho normal
    setscaleplayer = 'setscaleplayer', -- /setscaleplayer <id> <centímetros> - Admin only
}

-- Valores de Incremento
Config.BigIncrement = 0.2       -- Incremento ao usar /big
Config.SmallIncrement = 0.2    -- Decremento ao usar /small

-- Guardar no Banco de Dados
Config.SaveToDatabase = true   -- Se true, guarda a escala no banco de dados
Config.DatabaseTable = 'player_ped_scales' -- Nome da tabela (criar manualmente)

-- Mensagens
Config.Messages = {
    usage = 'Uso: /%s <centímetros>',
    usage_scale = 'Uso: /%s <escala> (0.3 - 2.0)',
    usage_admin = 'Uso: /%s <id> <centímetros>',
    invalid_number = 'Número inválido!',
    scale_set = 'Altura definida para %s cm (escala %.2f)',
    scale_set_other = 'Altura do jogador %s definida para %s cm (escala %.2f)',
    scale_reset = 'Altura resetada para o tamanho normal',
    scale_reset_other = 'Altura do jogador %s resetada',
    no_permission = 'Não tens permissão para usar este comando!',
    player_not_found = 'Jogador não encontrado!',
    too_small = 'Escala muito pequena! Mínimo: %.2f',
    too_large = 'Escala muito grande! Máximo: %.2f',
    big_used = 'Tamanho aumentado (escala: %.2f)',
    small_used = 'Tamanho diminuído (escala: %.2f)',
}

