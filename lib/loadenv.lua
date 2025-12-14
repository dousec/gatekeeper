function load(path)
    path = path or '.env'
    local f, err = io.open(path, 'r')

    if not f then
        return nil, err
    end

    for line in f:lines() do
        line = line:match('^%s*(.-)%s*$')

        if line ~= "" and not line:match('^#') then
            local key, value = line:match('^([%w_]+)%s*=%s*(.*)$')

            if key then
                value = value:gsub('^([\'"])(.*)%1$', '%2')

                if _G.process and process.env then
                    process.env[key] = value
                end
            end
        end
    end
    f:close()
    return true
end

return load
