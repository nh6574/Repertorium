NsRepertorium = {}

NsRepertorium.config = SMODS.current_mod.config

-- assert(SMODS.current_mod.lovely,
--     "Lovely modules were not loaded.\nMake sure your N's Repertorium folder is not nested (there should be a bunch of files in the N's Repertorium folder and not just another folder).")

-- assert(SMODS.load_file("src/utils.lua"))()

-- Jokers
local joker_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "src/jokers")
for _, file in ipairs(joker_src) do
    sendInfoMessage("Loading " .. file, "Repertorium")
    assert(SMODS.load_file("src/jokers/" .. file))()
end

-- Others
local others_src = NFS.getDirectoryItems(SMODS.current_mod.path .. "src/others")
for _, file in ipairs(others_src) do
    sendInfoMessage("Loading " .. file, "Repertorium")
    assert(SMODS.load_file("src/others/" .. file))()
end
