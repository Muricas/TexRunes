--[[

    TOOD:
        - Rebuild using Ace3
        - Add feature: prevent rune placement on switch
        - 

--]]

local addonName, ns = ...

local DEBUG = false

local function printMessage(msg, isDebugMessage)

    if DEBUG and not isDebugMessage then return end

    if msg then
        print('TexRunes: ' .. msg)
    end
end

local function debugMessage(msg)
    if DEBUG then
        printMessage(msg)
    end
end


local SPELL_TEXTURES = {
    [135944] = "spell_holy_prayerofmendingtga",
    [237570] = "spell_shadow_twistedfaith",
    [136160] = "spell_shadow_gathershadows",
    [253400] = "spell_holy_powerwordbarrier", -- Power Word: Barrier, Divine Sacrifice
    [135911] = "spell_holy_greaterblessingofsanctuary",
    [237514] = "spell_deathknight_bloodplague",
    [237566] = "spell_shadow_mindtwisting",
    [136149] = "spell_shadow_demonicfortitude",
    [135887] = "spell_holy_circleofrenewal",
    [237545] = "spell_holy_penance",
    [237565] = "spell_shadow_mindshear",
    [236227] = "ability_mage_wintersgrasp",             -- Fingers of Frost
    [236207] = "ability_mage_burnout",                  -- Burnout
    [135740] = "spell_arcane_mindmastery",              -- Enlightenment
    [135820] = "spell_fire_masterofelements",           -- Living Flame
    [132870] = "inv_enchant_essencenetherlarge",        -- Mass Regeneration
    [135734] = "spell_arcane_arcanetorrent",            -- Arcane Surge
    [135838] = "spell_frost_coldhearted",               -- Icy Veins
    [237538] = "spell_holy_borrowedtime",               -- Rewind Time
    [135844] = "spell_frost_frostblast",                -- Ice Lance
    [135735] = "spell_arcane_blast",                    -- Arcane Blast
    [236220] = "ability_mage_livingbomb",               -- Living Bomb
    [132871] = "inv_enchant_essencenethersmall",        -- Regeneration
    [133495] = "inv_mace_1h_stratholme_d_01",           -- Flagellation
    [136012] = "spell_nature_bloodlust",                -- Blood Frenzy
    [132215] = "ability_hunter_swiftstrike",            -- Raging Blow
    [236319] = "ability_warrior_warbringer",            -- Warbringer
    [136048] = "spell_nature_lightning",                -- Furious Thunder
    [136088] = "spell_nature_shamanrage",               -- Consumed by Rage, Shamanistic Rage
    [236317] = "ability_warrior_unrelentingassault",    -- Frenzied Assault
    [132342] = "ability_warrior_devastate",             -- Victory Rush
    [132347] = "ability_warrior_innerrage",             -- Endless Rage
    [135291] = "inv_sword_11",                          -- Devastate
    [134919] = "inv_relics_totemofrage",                -- Single-Minded Fury, Rebuke
    [132394] = "inv_axe_03",                            -- Quick Strike
    [135826] = "spell_fire_selfdestruct",               -- Lake of Fire
    [136168] = "spell_shadow_lifedrain",                -- Master Channeler
    [136169] = "spell_shadow_lifedrain02",              -- Soul Siphon
    [136150] = "spell_shadow_demonictactics",           -- Demonic Tactics
    [236296] = "ability_warlock_everlastingaffliction", -- Everlasting Affliction
    [135789] = "spell_fire_burnout",                    -- Incinerate
    [236293] = "ability_warlock_demonicpower",          -- Demonic Grace
    [237562] = "spell_shadow_demonicpact",              -- Demonic Pact
    [237558] = "spell_shadow_demonform",                -- Metamorphosis
    [136195] = "spell_shadow_shadetruesight",           -- Shadow Bolt Volley
    [236291] = "ability_warlock_chaosbolt",             -- Chaos Bolt
    [236298] = "ability_warlock_haunt",                 -- Haunt
    [135961] = "spell_holy_sealofblood",                -- Seal of Martyrdom
    [236250] = "ability_paladin_divinestorm",           -- Divine Storm
    [134229] = "inv_misc_horn_03",                      -- Horn of Lordaeron
    [134993] = "inv_shield_48",                         -- Aegis
    [135938] = "spell_holy_power",                      -- Inspiration Exemplar
    [135874] = "spell_holy_avengersshield",             -- Avenger's Shield
    [135956] = "spell_holy_retribution",                -- Exorcist
    [236247] = "ability_paladin_beaconoflight",         -- Beacon of Light
    [135891] = "spell_holy_crusaderstrike",             -- Crusader Strike
    [135984] = "spell_holy_unyieldingfaith",            -- Hand of Reckoning
    [132185] = "ability_hunter_pet_cat",                -- Aspect of the Lion
    [132177] = "ability_hunter_mastermarksman",         -- Master Marksman
    [132266] = "ability_mount_whitedirewolf",           -- Lone Wolf
    [236177] = "ability_hunter_cobrastrikes",           -- Cobra Strikes
    [132176] = "ability_hunter_killcommand",            -- Kill Command
    [132212] = "ability_hunter_snipershot",             -- Sniper Training
    [132209] = "ability_hunter_serpentswiftness",       -- Serpent Spread
    [132175] = "ability_hunter_harass",                 -- Flanking Strike
    [132270] = "ability_physical_taunt",                -- Beast Mastery
    [236176] = "ability_hunter_chimerashot2",           -- Chimera Shot
    [236178] = "ability_hunter_explosiveshot",          -- Explosive Shot
    [135430] = "inv_throwingknife_06",                  -- Carve
    [134877] = "inv_potion_97",                         -- Deadly Brew
    [132284] = "ability_rogue_bloodyeye",               -- Just a Flesh Wound
    [134536] = "inv_musket_02",                         -- Quick Draw
    [236280] = "ability_rogue_slaughterfromtheshadows", -- Slaughter from the Shadows
    [135610] = "inv_weapon_rifle_01",                   -- Between the Eyes
    [132350] = "ability_warrior_punishingblow",         -- Blade Dance
    [132287] = "ability_rogue_disembowel",              -- Envenom
    [132304] = "ability_rogue_shadowstrikes",           -- Mutilate
    [132291] = "ability_rogue_envelopingshadows",       -- Shadowstrike
    [132375] = "inv_1h_haremmatron_d_01",               -- Saber Slash
    [135428] = "inv_throwingknife_04",                  -- Shiv
    [237531] = "spell_deathknight_spelldeflection",     -- Main Gauche
    [237472] = "inv_staff_90",                          -- Fury of Stormrage
    [132143] = "ability_druid_swipe",                   -- Wild Strikes
    [132126] = "ability_druid_enrage",                  -- Survival of the Fittest
    [136152] = "spell_shadow_detectinvisibility",       -- Living Seed
    [236167] = "ability_druid_skinteeth",               -- Savage Roar
    [134206] = "inv_misc_herb_felblossom",              -- Lifebloom
    [133732] = "inv_misc_bone_taurenskull_01",          -- Skull Bash
    [135730] = "spell_arcane_arcane03",                 -- Starsurge
    [132135] = "ability_druid_mangle2",                 -- Mangle
    [236153] = "ability_druid_flourish",                -- Wild Growth
    [236216] = "ability_mage_firestarter",              -- Sunfire
    [132131] = "ability_druid_lacerate",                -- Lacerate
    [132147] = "ability_dualwield",                     -- Dual Wield Specialization
    [134963] = "inv_shield_17",                         -- Shield Mastery
    [136099] = "spell_nature_stormreach",               -- Overload
    [136107] = "spell_nature_tranquility",              -- Healing Rain
    [132132] = "ability_druid_lunarguidance",           -- Ancestral Guidance
    [136089] = "spell_nature_skinofearth",              -- Earth Shield
    [136025] = "spell_nature_earthquake",               -- Way of Earth
    [132315] = "ability_shaman_watershield",            -- Water Shield
    [237582] = "spell_shaman_lavaburst",                -- Lava Burst
    [236289] = "ability_shaman_lavalash",               -- Lava Lash
    [237583] = "spell_shaman_lavaflow",                 -- Molten Blast
}

local CHARACTER_SLOTS = {
    [5] = { button = CharacterChestSlot, name = "Chest" },
    [7] = { button = CharacterLegsSlot, name = "Legs" },
    [10] = { button = CharacterHandsSlot, name = "Hands" },
}

local TexRunesMainFrame = CreateFrame("Frame")

local defaults = {
    disableAutomaticRunePlacement = true,
    automaticMacroIcon = true,
    showLongSpellCooldowns = false,
    locked = false,
    visible = true,
    position = {
        point = 0,
        xOfs = 0,
        yOfs = 0
    },
    runeData = {}
}

local function userCanApplyRune()
    return
        not UnitIsDeadOrGhost("player")
        and not UnitAffectingCombat("player")
        and not UnitCastingInfo("player")
        and not (GetUnitSpeed("player") > 0)
end


local mainFrame = CreateFrame("Frame", addonName .. "MainFrame", UIParent)
mainFrame:SetSize(200, 100)
mainFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
mainFrame:SetMovable(true)
mainFrame:EnableMouse(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local point, _, _, xOfs, yOfs = self:GetPoint()
    TexRunesDB.position = { point = point, xOfs = xOfs, yOfs = yOfs }
end)

local function CreateRuneButtons(data, frame, categoryId)
    local maxButtonsPerRow = 2
    local buttonSpacing = 5
    local buttonSize = 36
    local headerHeight = 20
    local headerOffset = headerHeight + 10

    local totalRowWidth = (maxButtonsPerRow * buttonSize) + ((maxButtonsPerRow - 1) * buttonSpacing)
    frame:SetWidth(totalRowWidth)

    -- local numRows = math.ceil(#data / maxButtonsPerRow)
    -- local totalHeight = numRows * buttonSize + (numRows - 1) * buttonSpacing + headerOffset

    debugMessage('Setting frame ('..categoryId..') width to '..totalRowWidth)

    local header = CreateFrame("Frame", nil, frame)
    header:SetSize(totalRowWidth, headerHeight)
    header:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)

    local headerText = header:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    headerText:SetPoint("CENTER", header, "CENTER")
    headerText:SetText(CHARACTER_SLOTS[categoryId].name)
    headerText:SetTextColor(1, 0.84, 0)

    local lastButtonInRow = nil
    local firstButtonInRow = nil

    for i, rune in ipairs(data) do

        local button = CreateFrame("Button", addonName .. "UseRuneButton" .. i, frame)
        button:SetSize(buttonSize, buttonSize)

        if i % maxButtonsPerRow == 1 then
            -- This is the first button in a new row
            if i == 1 then
                -- This is the first button in the first row
                button:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -headerOffset)
            else
                -- This is the first button in subsequent rows
                button:SetPoint("TOPLEFT", firstButtonInRow, "BOTTOMLEFT", 0, -buttonSpacing)
            end
            firstButtonInRow = button
        else
            -- This is not the first button in a row
            button:SetPoint("LEFT", lastButtonInRow, "RIGHT", buttonSpacing, 0)
        end

        local icon = button:CreateTexture(nil, "ARTWORK")
        icon:SetSize(18, 18)
        icon:SetPoint("LEFT", button, "LEFT", 5, 0)

        local normalTexture = button:CreateTexture()
        normalTexture:SetAllPoints()
        normalTexture:SetTexture("Interface\\Icons\\" .. (SPELL_TEXTURES[rune.iconTexture] or "inv_misc_rune_06"))
        button:SetNormalTexture(normalTexture)

        local highlightTexture = button:CreateTexture()
        highlightTexture:SetAllPoints()
        highlightTexture:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
        highlightTexture:SetBlendMode("ADD")
        button:SetHighlightTexture(highlightTexture)

        button:SetScript("OnClick", function()
            if not userCanApplyRune() then return end

            -- determine if they have an item equipped
            if GetInventoryItemID("player", rune.equipmentSlot) == nil then
                printMessage('No ' .. CHARACTER_SLOTS[rune.equipmentSlot].name .. ' equipped.')
                PlaySound(846)
                return
            end

            C_Engraving.CastRune(rune.runeID)
            CHARACTER_SLOTS[rune.equipmentSlot].button:Click()
            StaticPopup1Button1:Click()
        end)

        button:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_CURSOR")
            GameTooltip:SetText("Activate " .. rune.runeName, 1, 1, 1)
            GameTooltip:Show()
        end)

        button:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        lastButtonInRow = button
    end
end

local function CreateCategories(parentFrame, categories)
    local previousFrame = nil

    for i, categoryId in ipairs(categories) do
        local frame = CreateFrame("Frame", "AttachedFrame" .. categoryId, parentFrame, "BackdropTemplate")
        frame:SetSize(130, 40) -- Set each frame's size

        -- Position the frame
        if previousFrame then
            -- Position to the right of the previous frame
            frame:SetPoint("LEFT", previousFrame, "RIGHT", 10, 0)
        else
            -- First frame, attach to the left of the parent frame
            frame:SetPoint("LEFT", parentFrame, "LEFT", 10, 0)
        end

        local runeData = {}
        local runes = C_Engraving.GetRunesForCategory(categoryId, true)
        for _, r in pairs(runes) do
            local data = {
                runeID = r.skillLineAbilityID,
                runeName = r.name,
                iconTexture = r.iconTexture,
                equipmentSlot = r.equipmentSlot
            }
            table.insert(runeData, data)
        end

        CreateRuneButtons(runeData, frame, categoryId)

        previousFrame = frame -- Update the reference to the last created frame
    end
end

local function lockWindow()
    mainFrame:SetMovable(false)
end

local function unlockWindow()
    mainFrame:SetMovable(true)
end

local function showWindow()
    mainFrame:Show()
end

local function hideWindow()
    mainFrame:Hide()
end

local isInitialized = false
function TexRunesMainFrame:OnEvent(event, addon)
    if not addon == "TexRunes" then return end

    if event == "ADDON_LOADED" and not isInitialized then
        TexRunesDB = TexRunesDB or CopyTable(defaults)
        self.db = TexRunesDB
        self:InitializeOptions()

        if TexRunesDB.position then
            local pos = TexRunesDB.position
            mainFrame:SetPoint(pos.point, UIParent, pos.point, pos.xOfs, pos.yOfs)
        end

        if TexRunesDB.locked then
            lockWindow()
        else
            unlockWindow()
        end

        if TexRunesDB.visible then
            showWindow()
        else
            hideWindow()
        end

        isInitialized = true
    end

    if event == "PLAYER_ENTERING_WORLD" or event == "NEW_RECIPE_LEARNED" then
        local categories = C_Engraving.GetRuneCategories(false, true)

        -- TODO: class check in case another class's runes are cached?
        if not categories or #categories == 0 then
            debugMessage('No rune categories found. Opening character frame')

            ShowUIPanel(CharacterFrame)
            C_Timer.After(1, function() HideUIPanel(CharacterFrame) end)
            categories = C_Engraving.GetRuneCategories(false, true)

            if not categories or #categories == 0 then
                debugMessage('Could not load rune categories. Hiding addon.')
                TexRunesMainFrame:Hide()
            end

            TexRunesMainFrame:Show()
        end

        CreateCategories(mainFrame, categories)
        mainFrame:Show()
    end
end

--[[ TODO: Track long spell CDs

local button = _G["TexRunesUseRuneButton4"]
local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
cooldown:SetAllPoints(button)

local function OnEvent(self, event, unitID, _, spellID)
    if unitID == "player" and spellID == 425207 then
        local spellDuration = select(2, GetSpellCooldown(425207))
        cooldown:SetCooldown(GetTime(), spellDuration)
    end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
eventFrame:SetScript("OnEvent", OnEvent)

--]]

TexRunesMainFrame:RegisterEvent("ADDON_LOADED")
TexRunesMainFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
TexRunesMainFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
TexRunesMainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
TexRunesMainFrame:RegisterEvent("NEW_RECIPE_LEARNED")
TexRunesMainFrame:SetScript("OnEvent", TexRunesMainFrame.OnEvent)

function TexRunesMainFrame:InitializeOptions()
    self.panel = CreateFrame("Frame")
    self.panel.name = "Tex Runes"

    local cb = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
    cb:SetPoint("TOPLEFT", 20, -20)
    cb.Text:SetText("Don't automatically add rune icons to action bars when activating rune")
    -- there already is an existing OnClick script that plays a sound, hook it
    cb:HookScript("OnClick", function(_, btn, down)
        self.db.disableAutomaticRunePlacement = cb:GetChecked()
    end)
    cb:SetChecked(self.db.disableAutomaticRunePlacement)

    -- local cb1 = CreateFrame("CheckButton", nil, self.panel, "InterfaceOptionsCheckButtonTemplate")
    -- cb1:SetPoint("TOPLEFT", 20, -40)
    -- cb1.Text:SetText("Automatically set macro icons")
    -- -- there already is an existing OnClick script that plays a sound, hook it
    -- cb1:HookScript("OnClick", function(_, btn, down)
    --     self.db.automaticMacroIcon = cb1:GetChecked()
    -- end)
    -- cb1:SetChecked(self.db.automaticMacroIcon)

    -- local btn = CreateFrame("Button", nil, self.panel, "UIPanelButtonTemplate")
    -- btn:SetPoint("TOPLEFT", cb, 0, -40)
    -- btn:SetText("Click me")
    -- btn:SetWidth(100)
    -- btn:SetScript("OnClick", function()
    -- 	print("You clicked me!")
    -- end)

    if DEBUG then
        local button = CreateFrame("Button", "MyButton", self.panel, "UIPanelButtonTemplate")
        button:SetSize(100, 30)                         -- Width, Height
        button:SetPoint("CENTER", self.panel, "CENTER") -- Position the button at the center of the screen
        button:SetText("Get Runes")

        -- Function to handle the button click
        button:SetScript("OnClick", function()
            local _, playerClass = UnitClass("player")

            local categories = C_Engraving.GetRuneCategories(false, false)
            for _, categoryId in pairs(categories) do
                local runes = C_Engraving.GetRunesForCategory(categoryId, false)
                for _, rune in pairs(runes) do
                    -- Create a table to store rune data along with player's class
                    local runeEntry = {
                        rune = rune,
                        class = playerClass
                    }

                    -- Insert the rune entry into the database
                    table.insert(self.db.runeData, runeEntry)
                end
            end
        end)

        -- Show the button
        button:Show()
    end

    InterfaceOptions_AddCategory(self.panel)
end

SLASH_TEXRUNES1 = "/runes"
SLASH_TEXRUNES2 = "/texrunes"

SlashCmdList.TEXRUNES = function(msg, editBox)
    if not msg or msg == "" then
        InterfaceOptionsFrame_OpenToCategory(TexRunesMainFrame.panel)
    end

    if msg == "test" then
        -- TexRunesUseRunButton4
        local cooldown = CreateFrame("Cooldown", nil, TexRunesUseRuneButton4, "CooldownFrameTemplate")
        cooldown:SetAllPoints(TexRunesUseRuneButton4) -- Make the cooldown overlay the same size as the button

        -- Example usage: start a cooldown of 30 seconds
        cooldown:SetCooldown(GetTime(), 30)

        return
    end

    -- if msg == "lock" then
    --     mainFrame:SetMovable(false)
    --     mainFrame:SetScript("OnDragStart", nil)
    --     mainFrame:SetScript("OnDragStop", nil)
    --     TexRunesDB.locked = true
    --     return
    -- end

    -- if msg == "unlock" then
    --     mainFrame:SetMovable(true)
    --     mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
    --     mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
    --     TexRunesDB.locked = false
    --     return
    -- end

    if msg == "show" then
        showWindow()
        TexRunesDB.visible = true
        return
    end

    if msg == "hide" then
        hideWindow()
        TexRunesDB.visible = false
        return
    end
end
