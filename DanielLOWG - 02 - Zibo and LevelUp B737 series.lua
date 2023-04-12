-- ***********************************************************************************************************************************************************************************
-- My Lua Assistance - for zibo's Boeing 737-800 
-- ***********************************************************************************************************************************************************************************
-- Author: 		Daniel Mandlez (DanielLOWG former DanielMan @ x-plane.at and x-plane.org)
-- Verion:		1.1	
-- License:		Public Domain

-- Comments:	This Script will only work in combination with XFlightOfficer provided on x-plane.org together with in this package included procedure and monitor files
--				I use My Lua Assistance in combination with VoiceAttack provided on (VoiceAttack is provided on Steam).
--				Feel free to modify the following code for your use.
--				!!!!! Please keep in mind, that I'm not a software specialist --> doubtless some or even most of the code is weird to specialists ;-)
--				!!!!! There will be no support for the provided code, nor for changes done by your self !!!!!!	
--
-- Revised by:  KSI65 - April 2023 - Added support for Level Up B737-600, B737-700 & B737-900
-- Comments:    With huge thanks to DanielLOWG original author, I have modified this file to support the Level Up B737 series of aircraft. I have uploaded 
--              the 3 files required to make these scripts work. I assume that users have downloaded the FlywithLua & X-First Officer plugins that 
--				this script requires.
--
-- ***********************************************************************************************************************************************************************************


-- Acknowledgements
-- ***********************************************************************************************************************************************************************************
-- Great thanks to Carsten Lynker for providing FlywithLua
-- Great thanks to zibo for the amazing modification on the Boeing 737-800 
-- Great thanks to ParrotSim for XFirstOfficer, a plug-in we all were waiting for
-- Great thanks to DanielLOWG for writing these scripts that flying so much easier.
-- ***********************************************************************************************************************************************************************************


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- User Varibles can be changed
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local Baro_sync = true			-- true ... Barometers will synchronize with Captain's
								-- false .. Barometers won't synchronize with Captain's

								
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
-- Do not change code below, if you do not understand what you are going to change !!! ;-)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
	
	
	
	
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Local used Variables 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


local apu_procedure = false
local apu_item = 0
local apu_KeyIsHold = false
local apu_KeyIsHold_Time = 0

local act_condition = "ColdandDark"

local alt10000_passed = false
local last_flap_lever = 0

local bundle_TOGA = false
local bundle_ATH_OFF = false

local doors_closed = false

-- Memory States
local MEM_DM_proc_item = 0
local MEM_proc = "none"

local MEM_10kClimb = true
local MEM_10kDescent = true
local MEM_TransitionClimb = true
local MEM_TransitionDescent = true
local MEM_V2 = true
local MEM_TOGA_set = true
local MEM_Reverser_green = true
local MEM_AB_disarmed = true
local MEM_1000_toGo = true

-- Copilot special Operations
local set_HDG = false
	local set_HDG_val = 360
local set_ALT = false
	local set_ALT_val = 0
local set_IAS = false
	local set_IAS_val = 100
local set_PressAlt = false
	local set_PressAlt_val = 10000
local set_Trim = false
	local set_Trim_val = 0
	local Trim_dev = 0
local set_LdgAlt = false
	local set_LdgAlt_val = 0
local set_AutoBrake = false
	local set_AutoBrake_val = 1
local set_MIN = false
	local set_MIN_val = 0


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create custom Commands for Communication with XFirstOfficer (do not use to)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------






--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Total Fuel QTY --> Call out String
local function Fuel2String()

	local str = tostring(math.floor(Fuel_QTY_left + Fuel_QTY_right + Fuel_QTY_CTR)) .. " pounds"

	return str
end

-- Transponder Setting  --> Call out String
local function TransponderMode2String()

	local str = ""

	if Transponder_Mode == 1 then
		str = "Mode: Standby"
	elseif Transponder_Mode == 2 then
		str = "Mode: Altitude Off"
	elseif Transponder_Mode == 3 then
		str = "Mode: Altitude On"
	elseif Transponder_Mode == 4 then
		str = "Mode: T A"
	elseif Transponder_Mode == 5 then
		str = "Mode: T A, R A"
	end
	
	return str
	
end



-- Elevator String  --> Call out String
local function ElevatorTrim2String()

	local str = tostring(math.floor((8 * Elevator_Trim + 8) * 10)/10)
	return str
end

-- Caclulate Trim Value from DataRef
local function ElevatorTrimConvert(val)

	return (15 * (val+1) / 1.588244) - 1

end


-- Autobrake Setup --> Call out String
local function AutoBrakes()

	local str = ""
	
	if AutoBrake_Knob == 0 then
		str = "RTO"
	elseif AutoBrake_Knob == 1 then
		str = "Off"
	elseif AutoBrake_Knob == 2 then
		str = "1"
	elseif AutoBrake_Knob == 3 then
		str = "2"
	elseif AutoBrake_Knob == 4 then
		str = "3"
	elseif AutoBrake_Knob == 5 then
		str = "MAX"
	end	
		
	return str

end

-- Anti Ice Status --> Call out String
local function AntiIce()

	local str = ""

	if AntiIce_Wing_L_ON > 0 and AntiIce_Wing_R_ON > 0 and AntiIce_Engine_1_ON == 0 and AntiIce_Engine_2_ON == 0 then
		str = "Wings On"
	elseif AntiIce_Wing_L_ON == 0 and AntiIce_Wing_R_ON == 0 and AntiIce_Engine_1_ON > 0 and AntiIce_Engine_2_ON > 0 then
		str = "Engine On"
	elseif AntiIce_Wing_L_ON > 0 and AntiIce_Wing_R_ON > 0 and AntiIce_Engine_1_ON > 0 and AntiIce_Engine_2_ON > 0 then
		str = "Wings and Engine On"
	elseif AntiIce_Wing_L_ON == 0 and AntiIce_Wing_R_ON == 0 and AntiIce_Engine_1_ON == 0 and AntiIce_Engine_2_ON == 0 then	
		str = "Off"
	else
		str = "Unbalanced"
	end

	return str
	
end

-- LNAV armed/not armed  --> Call out String
local function LNAVStat2String()
	
	local str = ""
	
	if LNAV_Stat == 0 and HDG_Stat == 0 then 
		str = ""
	elseif LNAV_Stat == 1 then
		str = " LNAV Armed "
	elseif HDG_Stat == 1 then
		str = " Heading Armed "
	end
	
	return str
end





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Proceeding only if Aircraft is Boeing 737 NG by Level UP Series of B736, B737, B738 or B739
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if PLANE_ICAO == "B736" or PLANE_ICAO == "B737" or PLANE_ICAO == "B738" or PLANE_ICAO == "B739" then
		
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Key Bundles
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	function KeyBundle()	
	
		if DM_cmd_TOGA == true and bundle_TOGA == false then	-- Bind TO/GA Buttons to one Command
			command_begin("laminar/B738/autopilot/left_toga_press")
			command_begin("laminar/B738/autopilot/right_toga_press")
			XPLMSpeakString( "TOGA" )
			bundle_TOGA = true
		elseif DM_cmd_TOGA == false and bundle_TOGA == true then
			command_end("laminar/B738/autopilot/left_toga_press")
			command_end("laminar/B738/autopilot/right_toga_press")
			bundle_TOGA = false
		end

		if DM_cmd_AT_OFF == true and bundle_ATH_OFF == false  then	-- Bind A/T OFF Buttons to one Command
			command_begin("laminar/B738/autopilot/left_at_dis_press")
			command_begin("laminar/B738/autopilot/right_at_dis_press")
			bundle_ATH_OFF = true
		elseif DM_cmd_AT_OFF == false and bundle_ATH_OFF == true then
			command_end("laminar/B738/autopilot/left_at_dis_press")
			command_end("laminar/B738/autopilot/right_at_dis_press")
			bundle_ATH_OFF = false
		end
		
		
		if DM_cmd_next_procedure == true then
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = XFO_next_Procedure
			DM_cmd_next_procedure = false
		end
		
			
	end


	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- DataRefs
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if true then -- only to be able to collapse this hundrets of rows in Notepad++ ;-)
		-- Common
		
		DataRef( "Checklist_show", "laminar/B738/checklist/manip_enable")
		DataRef( "Chocks", "laminar/B738/fms/chock_status", "writeable")
		DataRef( "Parking_Brake", "laminar/B738/parking_brake_pos", "writeable")
		DataRef( "Altitude", "sim/cockpit2/gauges/indicators/altitude_ft_copilot")
		DataRef( "GroundSpeed_Model", "sim/flightmodel/position/groundspeed")
		DataRef( "GPWS_Test", "laminar/B738/system/gpws_test_running")


		-- Lights
		DataRef( "Lights_OVHD", "laminar/B738/electric/panel_brightness", "writeable",2)
		DataRef( "Lights_Panel0", "laminar/B738/electric/panel_brightness", "writeable",0)
		DataRef( "Lights_Panel1", "laminar/B738/electric/panel_brightness", "writeable",1)
		DataRef( "Lights_Panel3", "laminar/B738/electric/panel_brightness", "writeable",3)
		DataRef( "EMER_Lights", "laminar/B738/toggle_switch/emer_exit_lights")
		DataRef( "Landing_Light_left", "sim/cockpit2/switches/landing_lights_switch", "readonly", 0 )
		DataRef( "Landing_Light_right", "sim/cockpit2/switches/landing_lights_switch", "readonly", 3 )
		DataRef( "Taxi_Light", "laminar/B738/toggle_switch/taxi_light_brightness_pos")
		DataRef( "TurnOff_Light_left", "sim/cockpit2/switches/generic_lights_switch", "readonly", 2 )
		DataRef( "TurnOff_Light_right", "sim/cockpit2/switches/generic_lights_switch", "readonly", 3 )


		-- APU
		DataRef( "APU_Switch", "laminar/B738/switches/apu_start")
		DataRef( "APU_Ready", "laminar/B738/electrical/apu_bus_enable")

		--Fuel
		DataRef( "Fuel_Press_L1_low", "laminar/B738/annunciator/low_fuel_press_l1")
		DataRef( "Fuel_Press_L2_low", "laminar/B738/annunciator/low_fuel_press_l2")
		DataRef( "Fuel_Press_R1_low", "laminar/B738/annunciator/low_fuel_press_r1")
		DataRef( "Fuel_Press_R2_low", "laminar/B738/annunciator/low_fuel_press_r2")
		DataRef( "Fuel_QTY_CTR", "laminar/B738/fuel/center_tank_lbs")
		DataRef( "Fuel_QTY_left", "laminar/B738/fuel/left_tank_lbs")
		DataRef( "Fuel_QTY_right", "laminar/B738/fuel/right_tank_lbs")
		
		DataRef( "Fuel_Switch_L1", "laminar/B738/fuel/fuel_tank_pos_lft1")
		DataRef( "Fuel_Switch_L2", "laminar/B738/fuel/fuel_tank_pos_lft2")
		DataRef( "Fuel_Switch_R1", "laminar/B738/fuel/fuel_tank_pos_rgt1")
		DataRef( "Fuel_Switch_R2", "laminar/B738/fuel/fuel_tank_pos_rgt2")
		DataRef( "Fuel_Switch_CTR1", "laminar/B738/fuel/fuel_tank_pos_ctr1")
		DataRef( "Fuel_Switch_CTR2", "laminar/B738/fuel/fuel_tank_pos_ctr2")

		-- Controls
		DataRef( "Elevator_Trim", "sim/cockpit2/controls/elevator_trim")
		DataRef( "Rudder_Trim", "laminar/B738/flt_ctrls/rudder_trim/sel_dial_pos")
		DataRef( "Aileron_Trim", "laminar/B738/flt_ctrls/aileron_trim/switch_pos")
		DataRef( "Flaps_Lever", "laminar/B738/flt_ctrls/flap_lever")
		DataRef( "SpeedBrake_Armed", "laminar/B738/annunciator/speedbrake_armed")
		DataRef( "SpeedBrake_Lever", "laminar/B738/flt_ctrls/speedbrake_lever")

		-- Hydraulic
		DataRef( "Hyd_Elec_A", "laminar/B738/annunciator/hyd_el_press_a")
		DataRef( "Hyd_Elec_B", "laminar/B738/annunciator/hyd_el_press_b")
		DataRef( "Hyd_Brake_Pressure", "laminar/B738/brake/brake_press")
		DataRef( "Gear_Lever", "laminar/B738/switches/landing_gear")
		DataRef( "Gear_green1", "laminar/B738/annunciator/left_gear_safe")
		DataRef( "Gear_green2", "laminar/B738/annunciator/right_gear_safe")
		DataRef( "Gear_green3", "laminar/B738/annunciator/nose_gear_safe")
		DataRef( "Yaw_damper_ON", "laminar/B738/annunciator/yaw_damp")
		DataRef( "AutoBrake_Disarm", "laminar/B738/autobrake/autobrake_disarm")
		DataRef( "AutoBrake_Knob", "laminar/B738/autobrake/autobrake_pos")

		-- Electric / Nav
		DataRef( "Battery_ON", "sim/cockpit2/electrical/battery_on", 0)
		DataRef( "GPU_avail", "laminar/B738/gpu_available")
		DataRef( "APU_onBUS1", "laminar/B738/electrical/apu_power_bus1")
		DataRef( "APU_onBUS2", "laminar/B738/electrical/apu_power_bus2")
		DataRef( "Gen1_Off_BUS", "laminar/B738/annunciator/gen_off_bus1")
		DataRef( "Gen2_Off_BUS", "laminar/B738/annunciator/gen_off_bus2")

		DataRef( "Windowheat_ON1", "laminar/B738/annunciator/window_heat_l_side")
		DataRef( "Windowheat_ON2", "laminar/B738/annunciator/window_heat_l_fwd")
		DataRef( "Windowheat_ON3", "laminar/B738/annunciator/window_heat_r_fwd")
		DataRef( "Windowheat_ON4", "laminar/B738/annunciator/window_heat_r_side")

		DataRef( "IRS_align_left", "laminar/B738/annunciator/irs_align_left")
		DataRef( "IRS_align_right", "laminar/B738/annunciator/irs_align_right")
		DataRef( "IRS_switch_left", "laminar/B738/toggle_switch/irs_left")
		DataRef( "IRS_switch_right", "laminar/B738/toggle_switch/irs_right")

		DataRef( "Cabin_IFE", "laminar/B738/toggle_switch/ife_pass_seat_pos", "writeable")
		DataRef( "Cabin_Utility", "laminar/B738/toggle_switch/cab_util_pos", "writeable")
		
		DataRef( "Navigation_IRS_Source", "laminar/B738/toggle_switch/irs_source")
		DataRef( "Navigation_FMC_Source", "laminar/B738/toggle_switch/fmc_source")
		DataRef( "Navigation_VHF_NAV_Source", "laminar/B738/toggle_switch/vhf_nav_source")
		DataRef( "Display_Source", "laminar/B738/toggle_switch/dspl_source")
		DataRef( "PFD_Min_Cpt", "laminar/B738/EFIS_control/cpt/minimums_pfd")
		DataRef( "PFD_Min_FO", "laminar/B738/EFIS_control/fo/minimums_pfd")

		-- Engine
		DataRef( "Engine_Starter_Source", "laminar/B738/toggle_switch/eng_start_source", "writeable")
		DataRef( "Engine_Starter1", "laminar/B738/engine/starter1_pos")
		DataRef( "Engine_Starter2", "laminar/B738/engine/starter2_pos")
		DataRef( "Engine_Start_valve1", "laminar/B738/engine/start_valve1")
		DataRef( "Engine_Start_valve2", "laminar/B738/engine/start_valve2")
		DataRef( "Engine_N1_1", "laminar/B738/engine/indicators/N1_percent_1")
		DataRef( "Engine_N1_2", "laminar/B738/engine/indicators/N1_percent_2")
		DataRef( "Engine_N2_1", "laminar/B738/engine/indicators/N2_percent_1")
		DataRef( "Engine_N2_2", "laminar/B738/engine/indicators/N2_percent_2")

		DataRef( "Engine_N1_bug1", "laminar/B738/engine/eng1_N1_bug")
		DataRef( "Engine_N1_bug2", "laminar/B738/engine/eng2_N1_bug")
		
		DataRef( "Engine_Reverser1", "sim/flightmodel2/engines/thrust_reverser_deploy_ratio", "readonly", 0 )
		DataRef( "Engine_Reverser2", "sim/flightmodel2/engines/thrust_reverser_deploy_ratio", "readonly", 1 )



		-- Bleed Air & Pressurisation	
		DataRef( "Bleed_Duct_pressL", "laminar/B738/indicators/duct_press_L")
		DataRef( "Bleed_Duct_pressR", "laminar/B738/indicators/duct_press_R")
		DataRef( "Bleed1", "laminar/B738/toggle_switch/bleed_air_1_pos")
		DataRef( "Bleed2", "laminar/B738/toggle_switch/bleed_air_2_pos")
		DataRef( "Bleed_APU", "laminar/B738/toggle_switch/bleed_air_apu_pos")
		DataRef( "Trim_Air", "laminar/B738/air/trim_air_pos")
		DataRef( "Packl", "laminar/B738/air/l_pack_pos")
		DataRef( "Pack2", "laminar/B738/air/r_pack_pos")
		DataRef( "Isol_valve", "laminar/B738/air/isolation_valve_pos")
		DataRef( "Press_Mode", "laminar/B738/pressurization_mode")
		DataRef( "Press_FLT_ALT", "sim/cockpit2/pressurization/actuators/max_allowable_altitude_ft")			-- new
		DataRef( "Press_LAND_ALT", "laminar/B738/pressurization/knobs/landing_alt")			-- new


		-- Ice
		DataRef( "Probe_Heat1", "sim/cockpit2/ice/ice_pitot_heat_on_pilot")
		DataRef( "Probe_Heat2", "sim/cockpit2/ice/ice_pitot_heat_on_copilot")
--		DataRef( "WindowHeat_L_FWD", "laminar/B738/annunciator/window_heat_l_fwd")
--		DataRef( "WindowHeat_L_SIDE", "laminar/B738/annunciator/window_heat_l_side")
--		DataRef( "WindowHeat_R_FWD", "laminar/B738/annunciator/window_heat_r_fwd")
--		DataRef( "WindowHeat_R_SIDE", "laminar/B738/annunciator/window_heat_r_side")
		DataRef( "AntiIce_Wing_Switch", "laminar/B738/ice/wing_heat_pos", "writeable")
		DataRef( "AntiIce_Wing_L_ON", "laminar/B738/annunciator/wing_ice_on_L")
		DataRef( "AntiIce_Wing_R_ON", "laminar/B738/annunciator/wing_ice_on_R")
		DataRef( "AntiIce_Engine_1_Switch", "laminar/B738/ice/eng1_heat_pos", "writeable")
		DataRef( "AntiIce_Engine_2_Switch", "laminar/B738/ice/eng2_heat_pos", "writeable")
		DataRef( "AntiIce_Engine_1_ON", "laminar/B738/annunciator/cowl_ice_on_0")
		DataRef( "AntiIce_Engine_2_ON", "laminar/B738/annunciator/cowl_ice_on_1")
		

		-- Chrono
		DataRef( "Chrono_FO_min", "laminar/B738/clock/fo/chrono_minutes")
		DataRef( "Chrono_FO_sec", "laminar/B738/clock/fo/chrono_seconds")

		-- CDU / MCP / PFD / MFD
		DataRef( "ClimbRate_FO", "sim/cockpit2/gauges/indicators/vvi_fpm_copilot")
		DataRef( "Trans_alt", "laminar/B738/FMS/fmc_trans_alt")
		DataRef( "LNAV_Stat", "laminar/B738/autopilot/lnav_status")
		DataRef( "HDG_Stat", "laminar/B738/autopilot/hdg_sel_status")
		DataRef( "Speed_V1", "laminar/B738/FMS/v1_set")
		DataRef( "Speed_Vr", "laminar/B738/FMS/vr_set")
		DataRef( "Speed_V2", "laminar/B738/FMS/v2_set")
		DataRef( "Speed_Vref", "laminar/B738/FMS/vref")
		DataRef( "MCP_Speed", "laminar/B738/autopilot/mcp_speed_dial_kts")
		DataRef( "MCP_HDG", "laminar/B738/autopilot/mcp_hdg_dial")
		DataRef( "MCP_Alt", "laminar/B738/autopilot/mcp_alt_dial")
		DataRef( "MFD_QNH", "laminar/B738/EFIS/baro_sel_in_hg_pilot")
		DataRef( "MFD_QNH_ishpa", "laminar/B738/EFIS_control/capt/baro_in_hpa")
		DataRef( "MFD_QNH_CoPilot", "laminar/B738/EFIS/baro_sel_in_hg_copilot", "writeable")
		DataRef( "MFD_QNH_Standby", "laminar/B738/knobs/standby_alt_baro", "writeable")
		DataRef( "Flaps_TO", "laminar/B738/FMS/takeoff_flaps")
		DataRef( "Flaps_TO_set", "laminar/B738/FMS/takeoff_flaps_set")
		DataRef( "Flaps_Approach", "laminar/B738/FMS/approach_flaps")
		DataRef( "Flaps_Approach_set", "laminar/B738/FMS/approach_flaps_set")
		DataRef( "Trim_TO", "laminar/B738/FMS/trim_calc")
		DataRef( "Autothrottle_ARM", "laminar/B738/autopilot/autothrottle_status")
		DataRef( "Airspeed", "sim/cockpit2/gauges/indicators/airspeed_kts_pilot")
		DataRef( "FD_Capt", "laminar/B738/autopilot/pfd_fd_cmd")
		DataRef( "FD_FO", "laminar/B738/autopilot/pfd_fd_cmd_fo")
		
		DataRef( "MFD_lowerDU", "laminar/B738/systems/lowerDU_page") -- 0..OFF, 1..Engines, 2..Flight Controls
		
		DataRef( "MFD_Capt_Baro_Std", "laminar/B738/EFIS/baro_set_std_pilot")
		DataRef( "MFD_FO_Baro_Std", "laminar/B738/EFIS/baro_set_std_copilot")
		
		DataRef( "MFD_MIN_Baro_sel", "laminar/B738/EFIS_control/cpt/minimums", "writeable")
		DataRef( "MFD_MIN_dh", "laminar/B738/pfd/dh_pilot")

			-- Status
			DataRef( "AP_Stat_cmd_A", "laminar/B738/autopilot/cmd_a_status")
			DataRef( "AP_Stat_cmd_B", "laminar/B738/autopilot/cmd_b_status")

		-- Radio / Transponder
		DataRef( "Squawk", "sim/cockpit2/radios/actuators/transponder_code", "writeable")
		DataRef( "Transponder_Mode", "laminar/B738/knob/transponder_pos")
		

		-- Alarms and Warnings
		DataRef( "Master_Caution", "laminar/B738/annunciator/master_caution_light")
			-- Sixpacks
			DataRef( "SIX_AirCond", "laminar/B738/annunciator/six_pack_air_cond")
			DataRef( "SIX_APU", "laminar/B738/annunciator/six_pack_apu")
			DataRef( "SIX_Doors", "laminar/B738/annunciator/six_pack_doors")
			DataRef( "SIX_Electric", "laminar/B738/annunciator/six_pack_elec")
			DataRef( "SIX_Engine", "laminar/B738/annunciator/six_pack_eng")
			DataRef( "SIX_Fire", "laminar/B738/annunciator/six_pack_fire")
			DataRef( "SIX_Fuel", "laminar/B738/annunciator/six_pack_fuel")
			DataRef( "SIX_Hydraulic", "laminar/B738/annunciator/six_pack_hyd")
			DataRef( "SIX_Ice", "laminar/B738/annunciator/six_pack_ice")
			DataRef( "SIX_IRS", "laminar/B738/annunciator/six_pack_irs")
			DataRef( "SIX_Overhead", "laminar/B738/annunciator/six_pack_overhead")
	


		-- Doors
		DataRef( "Cabin_Door_LCK_Fail", "laminar/B738/annunciator/door_lock_fail")
		DataRef( "Door_FWD_1", "laminar/B738/annunciator/fwd_entry")
		DataRef( "Door_FWD_2", "laminar/B738/annunciator/fwd_service")
		DataRef( "Door_FWD_3", "laminar/B738/annunciator/left_fwd_overwing")
		DataRef( "Door_FWD_4", "laminar/B738/annunciator/right_fwd_overwing")
		DataRef( "Door_FWD_5", "laminar/B738/annunciator/fwd_cargo")
		DataRef( "Door_AFT_1", "laminar/B738/annunciator/aft_entry")
		DataRef( "Door_AFT_2", "laminar/B738/annunciator/aft_service")
		DataRef( "Door_AFT_3", "laminar/B738/annunciator/left_aft_overwing")
		DataRef( "Door_AFT_4", "laminar/B738/annunciator/right_aft_overwing")
		DataRef( "Door_AFT_5", "laminar/B738/annunciator/aft_cargo")

		DataRef( "Door_FWD_1_val", "737u/doors/L1")
		DataRef( "Door_FWD_2_val", "737u/doors/R1")
		DataRef( "Door_FWD_5_val", "737u/doors/Fwd_Cargo")
		DataRef( "Door_AFT_1_val", "737u/doors/L2")
		DataRef( "Door_AFT_2_val", "737u/doors/R2")
		DataRef( "Door_AFT_5_val", "737u/doors/aft_Cargo")
	end
	
	
	-- Init Briefing Variables
	GENERAL_Alt_Cruise = 0
	ATIS_Transition = 18000
	DEP_LAT = "OFF"
	DEP_Init_HDG = 360
	DEP_Alt = 5000
	DEP_IAS = 100
	DEP_Trim = 5.0
	DEP_minFuel = 0
	DEP_PushBack = false
	DEP_ICE_Wing = false
	DEP_ICE_Eng = false
	APP_AutoBrake_val = 1
	APP_Min_Radio = true 
	APP_Min_Alt = 0
	APP_Landing_Alt = 0
	APP_GA_HDG = 0
	APP_GA_ALT = 5000


	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Communication with XFlightOfficer Plugin
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	function XFirstOfficer_Com()
			
		-- Departure
		if XFO_fuel_on_board == 1 then
			XPLMSpeakString("Fuel: " .. Fuel2String() .. " onboard, " .. tostring(Fuel_Switch_L1 + Fuel_Switch_L2 + Fuel_Switch_R1 + Fuel_Switch_R2 + Fuel_Switch_CTR1 + Fuel_Switch_CTR2) .. " Pumps On")
			XFO_fuel_on_board = 0
		end
		
		if XFO_vSpeeds == 1 then
			XPLMSpeakString( "Take Off Speeds: V1 " .. tostring(math.floor(Speed_V1)) .. ", V rotate " .. tostring(math.floor(Speed_Vr)) .. ", V2 " .. tostring(math.floor(Speed_V2)))	
			XFO_vSpeeds = 0
		end
	
		if XFO_Trim_Setting == 1 then
			XPLMSpeakString("Stabilizer Trim: Set " .. ElevatorTrim2String().. "Checked")
			XFO_Trim_Setting = 0
		end	
	
		if XFO_Transponder == 1 then
			XPLMSpeakString("Transponder " .. TransponderMode2String() .. ", Squawk: " ..  DM_Squawk2String(Squawk))
			XFO_Transponder = 0
		end
	
		if	XFO_MCP_settings == 1 then
			XPLMSpeakString("MCP Setting: Speed " .. tostring(math.floor(MCP_Speed)) .. " knots,  Initial Heading " .. DM_HDG2String(MCP_HDG) .."," ..  LNAVStat2String() .. ", Initial Altitude " .. tostring(math.floor(MCP_Alt)) .. " feet, Altimeter: " .. DM_QNH2String(MFD_QNH, MFD_QNH_ishpa))
			XFO_MCP_settings = 0
		end
	
		if XFO_min_TO_Fuel == 1 then
			if math.floor(Fuel_QTY_left + Fuel_QTY_right + Fuel_QTY_CTR) > DEP_minFuel then
				XPLMSpeakString("Minimum Take Off Fuel: Checked " .. Fuel2String() .. " onboard" )
			else
				XPLMSpeakString("Minimum Take Off Fuel: " .. tostring(DEP_minFuel - math.floor(Fuel_QTY_left + Fuel_QTY_right + Fuel_QTY_CTR)) .. " pounds missing")
			end
			XFO_min_TO_Fuel = 0
		end
	
		if XFO_AntiIce == 1 then
			XPLMSpeakString("Anti Ice: " .. AntiIce())
			XFO_AntiIce = 0
		end
		
		if XFO_Flt_Land_Alt == 1 then
			XPLMSpeakString("Flight and Landing Altitude: Flight Altitude set " .. tostring(Press_FLT_ALT) .. " feet, and Landing Altitude set " .. tostring(Press_LAND_ALT) .. " feet")
			XFO_Flt_Land_Alt = 0
		end
		
		-- Approach
		if XFO_Land_Alt == 1 then
			XPLMSpeakString("Landing Altitude: Set " .. tostring(Press_LAND_ALT) .. " feet")
			XFO_Land_Alt = 0
		end
		
		if XFO_Flt_Minimums == 1 then
			if APP_Min_Radio == true then
				MFD_MIN_Baro_sel = 0
				XPLMSpeakString("Minimums: Decision Hight Set " .. MFD_MIN_dh .. " feet")
			elseif APP_Min_Radio == false then
				MFD_MIN_Baro_sel = 1
				XPLMSpeakString("Minimums: Decision Altitude Set " .. MFD_MIN_dh .. " feet")
			end
			XFO_Flt_Minimums = 0
		end
		
		if XFO_AutoBrakes == 1 then
			XPLMSpeakString("Auto Brake: Set ".. AutoBrakes())
			XFO_AutoBrakes = 0
		end
		
		if XFO_MCP_Missed_Approach == 1 then
			XPLMSpeakString("MCP Missed Approach: Heading: "  .. DM_HDG2String(MCP_HDG) .. ", Altitude " .. tostring(math.floor(MCP_Alt)) .. " feet")
			XFO_MCP_Missed_Approach = 0
		end
		
		
		-- Calculation for Trim Setting
		XFO_TO_Trim_Deviation = math.floor(ElevatorTrimConvert(Elevator_Trim)*100 - DEP_Trim*100, 1)
		if math.abs(XFO_TO_Trim_Deviation) < 5 then
			XFO_TO_Trim_Deviation = 0
		end
		
	
	end

	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Create Custom DataRef's 
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	-- Procedure initiation
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/procedure_call","Int")
			DataRef( "XFO_Procedure_Call", "DanielLOWG/XFO_Com/B738x/procedure_call", "writeable")
			XFO_Procedure_Call = 0
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/procedure_active","Int")
			DataRef( "XFO_Procedure_Active", "DanielLOWG/XFO_Com/B738x/procedure_active", "writeable")
			XFO_Procedure_Active = 0
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/next_procedure","Int")
			DataRef( "XFO_next_Procedure", "DanielLOWG/XFO_Com/B738x/next_procedure", "writeable")
			XFO_next_Procedure = 1
				
	
	-- Call Outs
		-- Departure
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/fuel_on_board","Int")
			DataRef( "XFO_fuel_on_board", "DanielLOWG/XFO_Com/B738x/fuel_on_board", "writeable")
			XFO_fuel_on_board = 0
		
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/v_speeds","Int")
			DataRef( "XFO_vSpeeds", "DanielLOWG/XFO_Com/B738x/v_speeds", "writeable")
			XFO_vSpeeds = 0
		
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/transponder","Int")
			DataRef( "XFO_Transponder", "DanielLOWG/XFO_Com/B738x/transponder", "writeable")
			XFO_Transponder = 0
			
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/trim_setting","Int")
			DataRef( "XFO_Trim_Setting", "DanielLOWG/XFO_Com/B738x/trim_setting", "writeable")
			XFO_Trim_Setting = 0
		
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/mcp_settings","Int")
			DataRef( "XFO_MCP_settings", "DanielLOWG/XFO_Com/B738x/mcp_settings", "writeable")
			XFO_MCP_settings = 0
		
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/min_TO_fuel","Int")
			DataRef( "XFO_min_TO_Fuel", "DanielLOWG/XFO_Com/B738x/min_TO_fuel", "writeable")
			XFO_min_TO_Fuel = 0
		
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/anti_ice","Int")
			DataRef( "XFO_AntiIce", "DanielLOWG/XFO_Com/B738x/anti_ice", "writeable")
			XFO_AntiIce = 0
		
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/flt_land_alt","Int")
			DataRef( "XFO_Flt_Land_Alt", "DanielLOWG/XFO_Com/B738x/flt_land_alt", "writeable")
			XFO_Flt_Land_Alt = 0
		
		-- Approach
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/land_alt","Int")
			DataRef( "XFO_Land_Alt", "DanielLOWG/XFO_Com/B738x/land_alt", "writeable")
			XFO_Land_Alt = 0
	
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/minimums","Int")
			DataRef( "XFO_Flt_Minimums", "DanielLOWG/XFO_Com/B738x/minimums", "writeable")
			XFO_Flt_Minimums = 0
			
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/autobrakes","Int")
			DataRef( "XFO_AutoBrakes", "DanielLOWG/XFO_Com/B738x/autobrakes", "writeable")
			XFO_AutoBrakes = 0	
			
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/mcp_missed_approach","Int")
			DataRef( "XFO_MCP_Missed_Approach", "DanielLOWG/XFO_Com/B738x/mcp_missed_approach", "writeable")
			XFO_MCP_Missed_Approach = 0	
		
	-- Special Operations
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/set_hdg_departure","Int")
			DataRef( "XFO_Set_HDG_Departure", "DanielLOWG/XFO_Com/B738x/set_hdg_departure", "writeable")
			XFO_Set_HDG_Departure = 0	
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/set_hdg_missed_approach","Int")
			DataRef( "XFO_Set_HDG_Missed_Approach", "DanielLOWG/XFO_Com/B738x/set_hdg_missed_approach", "writeable")
			XFO_Set_HDG_Missed_Approach = 0	
		
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/passing_alt_climb","Int")
			DataRef( "XFO_Passing_Alt_climb", "DanielLOWG/XFO_Com/B738x/passing_alt_climb", "writeable")
			XFO_Passing_Alt_Descent = 0	
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/passing_alt_descent","Int")
			DataRef( "XFO_Passing_Alt_Descent", "DanielLOWG/XFO_Com/B738x/passing_alt_descent", "writeable")
			XFO_Passing_Alt_Descent = 0	
	
	-- Values to XFO
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/trim_deviation","Float")
				DataRef( "XFO_TO_Trim_Deviation", "DanielLOWG/XFO_Com/B738x/trim_deviation", "writeable")
				XFO_TO_Trim_Deviation = 0
		define_shared_DataRef("DanielLOWG/XFO_Com/B738x/set_trim_after_landing","Int")
				DataRef( "XFO_Set_Trim_After_Landing", "DanielLOWG/XFO_Com/B738x/set_trim_after_landing", "writeable")
				XFO_Set_Trim_After_Landing = 0
	
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Do on Key stroke 
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	function func_keystroke()
	
		-- Continue Checklist
		if DM_cmd_checklist_continue == true then
			command_once("XFirstOfficer/Next")
			DM_cmd_checklist_continue = false
		end
	
		-- Call Procedures (Condition will be checked in XFlightOfficer Procedure)
		
		if DM_cmd_power_up == true then								
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 1
			DM_cmd_power_up = false
		elseif DM_cmd_apu_start == true then								
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 2
			DM_cmd_apu_start = false
		elseif DM_cmd_before_start_items == true then					
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 3
			DM_cmd_before_start_items = false
		elseif DM_cmd_before_start_checklist == true then
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 4
			DM_cmd_before_start_checklist = false
		elseif DM_cmd_after_start_items == true then					
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 5
			DM_cmd_after_start_items = false
		elseif DM_cmd_before_taxi_checklist == true then
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 6
			DM_cmd_before_taxi_checklist = false
		elseif DM_cmd_taxi_items == true then							
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 7
			DM_cmd_taxi_items = false
		elseif DM_cmd_after_TO_items == true then						
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 8
			DM_cmd_after_TO_items = false
		elseif DM_cmd_descent_items == true then									
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 9
			DM_cmd_descent_items = false
		elseif DM_cmd_approach_checklist == true then
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 10		
			DM_cmd_approach_checklist = false
		elseif DM_cmd_landing == true then									
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 11
			DM_cmd_landing = false
		elseif DM_cmd_after_landing == true then							
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 12
			DM_cmd_after_landing = false
		elseif DM_cmd_parking == true then									
			command_once("XFirstOfficer/Start_always")
			XFO_Procedure_Call = 13
			DM_cmd_parking = false
		elseif DM_cmd_checklist_abort == true then							-- Aborting Procedure
			-- nothing
			DM_cmd_checklist_abort = false
		elseif DM_cmd_go_arround == true then								-- Go Arround
			-- nothing
			DM_cmd_go_arround = false
		end 
		
		
		-- Gear Operations (CoPilot will check Conditions before acting)
		if DM_cmd_Gear_down == true then
			if Airspeed < 250 and Gear_Lever ~= 2 then
				XPLMSpeakString( "Speed checked, Gear Down" )
				command_once("laminar/B738/push_button/gear_down")
			elseif Gear_Lever == 2 then
				XPLMSpeakString( "Gear is already down" )
			else
				XPLMSpeakString( "Speed not OK" )
			end
			DM_cmd_Gear_down = false
		elseif DM_cmd_Gear_up == true then
			if ClimbRate_FO > 500 then
				XPLMSpeakString( "Gear Up" )
				command_once("laminar/B738/push_button/gear_up")
			else
				XPLMSpeakString( "Negative" )
			end
			DM_cmd_Gear_up = false
		end
		
		
		-- Flaps Operations (CoPilot will check Conditions before acting)
		if DM_cmd_Flaps_0 == true then
			if Flaps_Lever <= 0.125 then
				command_once("laminar/B738/push_button/flaps_0")
				XPLMSpeakString( "Flaps Up" )
			else
				XPLMSpeakString( "Negative!" )
			end
			DM_cmd_Flaps_0 = false
		elseif DM_cmd_Flaps_1 == true then
			if Flaps_Lever <= 0.625 and Airspeed <= 250 then
				command_once("laminar/B738/push_button/flaps_1")
				if Airspeed > 100 then
					XPLMSpeakString( "Speed checked: Flaps 1" )
				else
					XPLMSpeakString( "Flaps 1" )
				end
			else
				XPLMSpeakString( "Negative!" )
			end
			DM_cmd_Flaps_1 = false
		elseif DM_cmd_Flaps_2 == true and Airspeed <= 250 then
			if Flaps_Lever >= 0.125 and Flaps_Lever <= 0.625 then
				command_once("laminar/B738/push_button/flaps_2")
				if Airspeed > 100 then
					XPLMSpeakString( "Speed checked: Flaps 2" )
				else
					XPLMSpeakString( "Flaps 2" )
				end
			else
				XPLMSpeakString( "Negative!" )
			end
			DM_cmd_Flaps_2 = false
		elseif DM_cmd_Flaps_5 == true and Airspeed <= 250 then
			if Flaps_Lever >= 0.125 and Flaps_Lever <= 0.625 then
				command_once("laminar/B738/push_button/flaps_5")
				if Airspeed > 100 then
					XPLMSpeakString( "Speed checked: Flaps 5" )
				else
					XPLMSpeakString( "Flaps 5" )
				end
			else
				XPLMSpeakString( "Negative!" )
			end
			DM_cmd_Flaps_5 = false
		elseif DM_cmd_Flaps_10 == true and Airspeed <= 210 then
			if Flaps_Lever >= 0.125 and Flaps_Lever <= 0.625 then
				command_once("laminar/B738/push_button/flaps_10")
				if Airspeed > 100 then
					XPLMSpeakString( "Speed checked: Flaps 10" )
				else
					XPLMSpeakString( "Flaps 10" )
				end
			else
				XPLMSpeakString( "Negative!" )
			end
			DM_cmd_Flaps_10 = false
		elseif DM_cmd_Flaps_15 == true then
			if Flaps_Lever >= 0.125 and Flaps_Lever <= 1 and Airspeed <= 200 then
				command_once("laminar/B738/push_button/flaps_15")
				if Airspeed > 100 then
					XPLMSpeakString( "Speed checked: Flaps 15" )
				else
					XPLMSpeakString( "Flaps 15" )
				end
			else
				XPLMSpeakString( "Negative!" )
			end	
			DM_cmd_Flaps_15 = false
		elseif DM_cmd_Flaps_25 == true and Airspeed <= 190 then
			if Flaps_Lever >= 0.625 then
				command_once("laminar/B738/push_button/flaps_25")
				if Airspeed > 100 then
					XPLMSpeakString( "Speed checked: Flaps 25" )
				else
					XPLMSpeakString( "Flaps 25" )
				end
			else
				XPLMSpeakString( "Negative!" )
			end	
			DM_cmd_Flaps_25 = false
		elseif DM_cmd_Flaps_30 == true and Airspeed <= 175 then
			if Flaps_Lever >= 0.625 then
				command_once("laminar/B738/push_button/flaps_30")
				if Airspeed > 100 then
					XPLMSpeakString( "Speed checked: Flaps 30" )
				else
					XPLMSpeakString( "Flaps: 30" )
				end
			else
				XPLMSpeakString( "Negative!" )
			end	
			DM_cmd_Flaps_30 = false
		elseif DM_cmd_Flaps_40 == true then
			if Flaps_Lever >= 0.625 and Airspeed <= 162 then
				command_once("laminar/B738/push_button/flaps_40")
				if Airspeed > 100 then
					XPLMSpeakString( "Speed checked: Flaps Full" )
				else
					XPLMSpeakString( "Flaps Full" )
				end
			else
				XPLMSpeakString( "Negative!" )
			end	
			DM_cmd_Flaps_40 = false
		end	
		
	end
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Little Actions CoPilot is Acting or Monitoring 
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	function LittleActions()
	
		-- Barometer Synchronisation
		if Baro_sync == true then
			MFD_QNH_CoPilot = MFD_QNH
			MFD_QNH_Standby = MFD_QNH
		end

		-- Activate Climb and Decent Monitors
			-- in CLIMB
			if Altitude > 10500 and Altitude < 11500 then
				MEM_10kDescent = false
			end
			if Altitude > (ATIS_Transition + 500) and Altitude < (ATIS_Transition + 1500) then
				MEM_TransitionDescent = false
			end
		
			-- in DESCENT
			if Altitude < 9500 and Altitude > 8500 then
				MEM_10kClimb = false
			end
			if Altitude < (ATIS_Transition - 500) and Altitude > (ATIS_Transition - 1500) then
				MEM_TransitionClimb = false
			end
		
		-- Monitoring Passing 10k ft and Transition Altitude
		if ATIS_Transition == 10000 then
			-- Passing 10k and Transistion Altitude at same Time
				-- CLIMB
				if Altitude > 10000 and MEM_10kClimb == false and MEM_TransitionClimb == false then
					XFO_Passing_Alt_climb = 3
					command_once("XFirstOfficer/Start_always")
					MEM_10kClimb = true
					MEM_TransitionClimb = true
				end
				
				-- DESCENT
				if Altitude < 10000 and MEM_10kDescent == false and MEM_TransitionDescent == false then
					XFO_Passing_Alt_Descent = 3
					command_once("XFirstOfficer/Start_always")
					MEM_10kDescent = true
					MEM_TransitionDescent = true
				end
		
		else
		
			-- Passing 10k only
				-- in CLIMB
				if Altitude > 10000 and MEM_10kClimb == false then
					XFO_Passing_Alt_climb = 1
					command_once("XFirstOfficer/Start_always")
					MEM_10kClimb = true
				end	 
				
				-- in DESCENT
				if Altitude < 10000 and MEM_10kDescent == false then
					XFO_Passing_Alt_Descent = 1
					command_once("XFirstOfficer/Start_always")
					MEM_10kDescent = true
				end	
			
			-- Passing Transition Altitude only
				-- in CLIMB
				if Altitude > ATIS_Transition and MEM_TransitionClimb == false then
					XFO_Passing_Alt_climb = 2
					command_once("XFirstOfficer/Start_always")
					MEM_TransitionClimb = true
				end	 
				
				-- in DESCENT
				if Altitude < ATIS_Transition and MEM_TransitionDescent == false then
					XFO_Passing_Alt_Descent = 2
					command_once("XFirstOfficer/Start_always")
					MEM_TransitionDescent = true
				end	
		
		end
		
		
		-- Set Heading
		--[[
		
			HDG_set
			HDG_act
			HDG_dev
			if HDG_act == 0 then
				HDG_act = 360
			end
			
			
			HDG_dev = HDG_act - HDG_set
		
			if HDH_dev > 180 then
				HDG_dev = HDG_act - (HDG_set + 360) 
			end
		]]--
		
		local MCP_HDG_corr = MCP_HDG
		if MCP_HDG_corr == 0 then
			MCP_HDG_corr = 360
		end
		
			-- For Departure
			local HDG_dev =  DEP_Init_HDG - MCP_HDG_corr
			if HDG_dev > 180 then
				XFO_Set_HDG_Departure = HDG_dev - 360 
			else
				XFO_Set_HDG_Departure = HDG_dev
			end
		
			-- For Missed Approach
			local HDG_dev = APP_GA_HDG - MCP_HDG_corr
			if HDG_dev > 180 then
				XFO_Set_HDG_Missed_Approach = HDG_dev - 360 
			else
				XFO_Set_HDG_Missed_Approach = HDG_dev
			end
		
		--[[
		local HDG_dev = 0
		if XFO_Set_HDG_Departure == 1 or XFO_Set_HDG_Missed_Approach == 1 then
		
			if XFO_Set_HDG_Departure == 1 then
				HDG_dev = MCP_HDG - DEP_Init_HDG	-- Heading deviation relativ to Departure Briefing
			elseif XFO_Set_HDG_Missed_Approach == 1 then
				HDG_dev = MCP_HDG - APP_GA_HDG
			end
			
			if MCP_HDG == 0 then -- MCP_HDG range 0..359, set_HDG_val range 1..360
				HDG_dev = 360 - set_HDG_val
			end
			
			if HDG_dev == 0 then
				XFO_Set_HDG_Departure = 0
				XFO_Set_HDG_Missed_Approach = 0
			elseif HDG_dev <= -180 then 
				command_once("laminar/B738/autopilot/heading_dn")
			elseif HDG_dev > -180 and HDG_dev < 0 then
				command_once("laminar/B738/autopilot/heading_up")
			elseif HDG_dev > 0 and HDG_dev < 180 then 
				command_once("laminar/B738/autopilot/heading_dn")
			else
				command_once("laminar/B738/autopilot/heading_up")
			end

		end
		]]--
	
		-- Set Trim after Touch Down
		if XFO_Set_Trim_After_Landing == 1 then
			Trim_dev = math.floor(ElevatorTrimConvert(Elevator_Trim)*100 - 4*100, 1)
			if math.abs(Trim_dev) < 5 then
				XFO_Set_Trim_After_Landing = 0
				command_end("sim/flight_controls/pitch_trim_up")
				command_end("sim/flight_controls/pitch_trim_down")
			elseif Trim_dev <= 0 then 
				command_begin("sim/flight_controls/pitch_trim_up")
			else
				command_begin("sim/flight_controls/pitch_trim_down")
			end
		end
	
	
	end
	
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Aircraft Initialisation 
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	function init_ACF()
		
		PROC_List = {"Power Up", "Start APU", "Before Start Items", "Before Start Chkl", "After Start Items", "Before Taxi Chkl", "Taxi Items", "After T/O Items", "Descent Items", "Approach Items", "Landing Chkl", "After Landing Items", "Parking Items"}
		
		if Battery_ON == 0 then -- doing Initialisation if Battery is OFF
			
			Parking_Brake = 0	-- Parking_Brake OFF because of no Hydraulic
			
			command_once("sim/lights/beacon_lights_off")
			
			Squawk = 1200
			
			if Chocks == 0 then -- Chocks ON
				command_once("laminar/B738/toggle_switch/chock")
			end
		
			if Door_FWD_1_val == 0 then -- Open Entry Door
				command_once("laminar/B738/door/fwd_L_toggle")
			end
			if Door_FWD_5_val == 0 then
				command_once("laminar/B738/door/fwd_cargo_toggle")
			end
			if Door_AFT_5_val == 0 then
				command_once("laminar/B738/door/aft_cargo_toggle")
			end
		end
	end
	
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- Function Calls 
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	do_often("init_ACF()")
	do_every_frame("KeyBundle()")
	do_every_frame("XFirstOfficer_Com()")
	do_every_frame("LittleActions()")
	do_on_keystroke("func_keystroke()")
	if PLANE_ICAO == "B736" then
		XPLMSpeakString( "Welcome aboard Level Up Boeing 7 3 7 600!" )

		DanielLOWG_ACF_LU_B736 = true    -- Flag for Briefing Tool --> Allows myBriefing to obtain Data from the Aircraft
	
	elseif PLANE_ICAO == "B737" then
		XPLMSpeakString( "Welcome aboard Level Up Boeing 7 3 7 700!" )

		DanielLOWG_ACF_LU_B737 = true    -- Flag for Briefing Tool --> Allows myBriefing to obtain Data from the Aircraft

	elseif PLANE_ICAO == "B738" then
		XPLMSpeakString( "Welcome aboard Level Up Boeing 7 3 7 800!" )

		DanielLOWG_ACF_zibo_B738 = true    -- Flag for Briefing Tool --> Allows myBriefing to obtain Data from the Aircraft

	elseif PLANE_ICAO == "B739" then
		XPLMSpeakString( "Welcome aboard Level Up Boeing 7 3 7 900!" )

		DanielLOWG_ACF_LU_B739 = true    -- Flag for Briefing Tool --> Allows myBriefing to obtain Data from the Aircraft
	end
	
end




