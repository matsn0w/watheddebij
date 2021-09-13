-- convert a table to string
local function dump(table)
    -- check if the input is a table
    if type(table) ~= 'table' then
        return
    end

    local s = ''
    local length = #table

    -- loop through all items in the table
    for k, item in pairs(table) do
        -- append the item to the string
        s = s .. '- ' .. item.name .. (k ~= length and '\n' or '')
    end

    return s
end

local function load_items()
    -- load the items file
    local file = LoadResourceFile(GetCurrentResourceName(), '/data/items.json')

    -- decode the json
    local items = json.decode(file)

    return items
end

local function search()
    -- load the items
    local items = load_items()

    -- get a random index
   local index = math.floor(math.random() * #items) + 1

    -- get the item
    local item = items[index]

    -- start without any items found
    local found = {}

    -- loop through all items
    for i, item in pairs(items) do
        -- get a random number between 0 and 1
        local number = math.random()

        -- check if the number is less then the given chance
        if number < item.chance then
            -- add the item to the found table
            table.insert(found, item)
        end
    end

    -- build the result string
    local found_string = (#found > 0) and '\n' .. dump(found) or 'geen!'

    -- show the found items
    TriggerClientEvent('chat:addMessage', -1, {
        color = { 255, 0, 0},
        multiline = true,
        args = { 'Gevonden items:', found_string }
    })
end

-- register the search command
RegisterCommand('fouilleer', function (source, args)
    search()
end, false)

-- register command suggestion
TriggerClientEvent('chat:addSuggestion', -1, '/fouilleer', 'Fouilleer een verdachte', {})
