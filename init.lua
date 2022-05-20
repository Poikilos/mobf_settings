mobf_settings_version = "0.0.1"

inventory_plus.pages["mobf"] = "  Mobf Settings  "

function get_animal_list(start_at)

    local retval = ""
    local line = 3

    for i,val in ipairs(mobf_registred_mob) do
        
        if i > start_at then
	        if line <= 8 then
	            retval = retval .. "label[0.5," .. line .. ";" .. val .. "]"
	        end
	        
	        if line > 8 and
	            line <= 16 then
	            
	            local temp_line = line - 5.5
	            retval = retval .. "label[6.5," .. temp_line .. ";" .. val .. "]"
	        end
	        
	        line = line + 0.5
	    end
    end

    return retval
end

function get_known_animals_form(page)
    local retval = ""

    if page == "mobf_list_page1" then
        
        retval = "label[0.5,2.25;Known Mobs, Page 1]"
                 .."label[0.5,2.5;-------------------------------------------]"
                 .."label[6.5,2.5;----------------------------------------]"
                 .. get_animal_list(0)
                 .."button[3,9.5;2,0.5;mobf_list_page2;Next]"
        return retval
    end
    
    if page == "mobf_list_page2" then
        retval = "label[0.5,2.25;Known Mobs, Page 2]"
                .."label[0.5,2.5;-------------------------------------------]"
                .."label[6.5,2.5;----------------------------------------]"
                .. get_animal_list(17)
                .."button[3,9.5;2,0.5;mobf_list_page3;Next]"
                .."button[0.5,9.5;2,0.5;mobf_list_page1;Prev]"
        return retval
    end
    
    if page == "mobf_list_page3" then
        retval = "label[0.5,2.25;Known Mobs, Page 3]"
                .."label[0.5,2.5;-------------------------------------------]"
                .."label[6.5,2.5;----------------------------------------]"
                .. get_animal_list(33)
                .."button[3,9.5;2,0.5;mobf_list_page4;Next]"
                .."button[0.5,9.5;2,0.5;mobf_list_page2;Prev]"
        return retval
    end
    
    if page == "mobf_list_page4" then
        retval = "label[0.5,2.25;Known Mobs, Page 4]"
                .."label[0.5,2.5;-------------------------------------------]"
                .."label[6.5,2.5;----------------------------------------]"
                .. get_animal_list(49)
                .."button[3,9.5;2,0.5;mobf_list_page5;Next]"
                .."button[0.5,9.5;2,0.5;mobf_list_page3;Prev]"
        return retval
    end
    
    if page == "mobf_list_page5" then
        retval = "label[0.5,2.25;Known Mobs, Page 5]"
                .."label[0.5,2.5;-------------------------------------------]"
                .."label[6.5,2.5;----------------------------------------]"
                .. get_animal_list(65)
                .."button[0.5,9.5;2,0.5;mobf_list_page4;Prev]"
        return retval
    end
    
    
    if page == "mobf_restart_required" then
        retval = "label[0.5,2.25;This settings require to restart Game!]"
                .."label[0.5,2.5;-------------------------------------------]"
                .."label[6.5,2.5;----------------------------------------]"
    
        if minetest.setting_getbool("mobf_disable_animal_spawning") then
            retval = retval .. "button[0.5,3.75;4,0.5;mobf_enable_spawning;Spawning is disabled]"
        else
            retval = retval .. "button[0.5,3.75;4,0.5;mobf_disable_spawning;Spawning is enabled]"
        end
        
        if minetest.setting_getbool("mobf_disable_3d_mode") then
            retval = retval .. "button[0.5,4.5;4,0.5;mobf_enable_3dmode;3D Mode is disabled]"
        else
            retval = retval .. "button[0.5,4.5;4,0.5;mobf_disable_3dmode;3D Mode is enabled]"
        end
    
        return retval
    end
    
    return ""
end

-- get_formspec
local get_formspec = function(player,page)

    --mobf version > 1.4.4 required
    --local version = mobf_get_version()
    local version = "<=1.4.4"
    
    local pageform = get_known_animals_form(page)
    
	return "size[13,10]"
	.."button[11,9.5;2,0.5;main; Mainmenu ]"
	.."button[0.5,0.75;3,0.5;mobf_list_page1; Known Mobs ]"
	.."button[4,0.75;3,0.5;mobf_restart_required; Settings ]"
	.."label[5.5,0;MOBF " .. version .. "]"
	.. pageform
	

end

-- register_on_player_receive_fields
minetest.register_on_player_receive_fields(function(player, formname, fields)
    print("Fields: " .. dump(fields))
    if fields.mobf or
        fields.mobf_list_page1 then
        inventory_plus.set_inventory_formspec(player, get_formspec(player,"mobf_list_page1"))
        return true
    end
    
    if fields.mobf_list_page2 then
        inventory_plus.set_inventory_formspec(player, get_formspec(player,"mobf_list_page2"))
        return true
    end
    
    if fields.mobf_list_page3 then
        inventory_plus.set_inventory_formspec(player, get_formspec(player,"mobf_list_page3"))
        return true
    end
    
    if fields.mobf_list_page4 then
        inventory_plus.set_inventory_formspec(player, get_formspec(player,"mobf_list_page4"))
        return true
    end
    
    if fields.mobf_list_page5 then
        inventory_plus.set_inventory_formspec(player, get_formspec(player,"mobf_list_page5"))
        return true
    end
    
    if fields.mobf_enable_spawning then
        minetest.setting_set("mobf_disable_animal_spawning","true")
    end
    
    if fields.mobf_disable_spawning then
        minetest.setting_set("mobf_disable_animal_spawning","false")
    end
        
    if fields.mobf_enable_3dmode then
        minetest.setting_set("mobf_disable_3d_mode","false")
    end
    
    if fields.mobf_disable_3dmode then
        minetest.setting_set("mobf_disable_3d_mode","true")
    end
    
    if fields.mobf_restart_required or
        fields.mobf_enable_spawning or
        fields.mobf_disable_spawning or
        fields.mobf_enable_3dmode or
        fields.mobf_disable_3dmode then
        inventory_plus.set_inventory_formspec(player, get_formspec(player,"mobf_restart_required"))
        return true
    end
    
    return false
end)

print("mod mobf_settings "..mobf_settings_version.." loaded")
