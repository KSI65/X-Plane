-- ***********************************************************************************************************************************************************************************
-- My Lua Briefing - to use with My Lua Assistance or as Stand Alone Application
-- ***********************************************************************************************************************************************************************************
-- Author: 		Daniel Mandlez (DanielLOWG former DanielMan @ x-plane.at and x-plane.org)
-- Verion:		1.1	
-- License:		Public Domain

-- Comments:	This Script is written to be usable with My Lua Assistance
--				Feel free to modify the following code for your use.
--				!!!!! Please keep in mind, that I'm not a software specialist --> doubtless some or even most of the code is weird to specialists ;-)
--				!!!!! There will be no support for the provided code, nor for changes done by your self !!!!!!	
--
--
--
-- Revised by:  KSI65 - April 2023 - Added support for Level Up B737-600, B737-700 & B737-900
-- Comments:    With huge thanks to DanielLOWG original author, I have modified this file to support the Level Up B737 series of aircraft. I have uploaded 
--              the 3 files required to make these scripts work. I assume that users have downloaded the FlywithLua & X-First Officer plugins that 
--							this script requires.
--							PLEASE NOTE: This has been tested only with X-Plane 11. No testing has been done with X-Plane 12.
--
--
-- ***********************************************************************************************************************************************************************************


-- Acknowledgements
-- ***********************************************************************************************************************************************************************************
-- Great thanks to Carsten Lynker for providing FlywithLua
-- Great thanks to DanielLOWG for writing these scripts.
-- ***********************************************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
-- Modify your Hangar List 
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								



Your_Hangar_List = {B737,A320,CONC,B767,DA62}

-- Following are included so far: A320, CONC, B737, B767, DA62








--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
-- Do not change code below, if you do not understand what you are going to change !!! ;-)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
	



local INIT = false -- Initialisation not done if it false --> changing true when done in the last program row


-- to make sure the script doesn't stop old FlyWithLua versions
if not SUPPORTS_FLOATING_WINDOWS then
    logMsg("floating windows not supported by your FlyWithLua version")
    INIT = true -- Initialisation will not follow because of no Floating Windows
	return
end

-- Rounding like an Commercialist
local function round(x)
  return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Create Custom DataRef's
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- This DataRef's makes it possible to use values from Briefing for any kind of copilot actions (for example: XFirstOfficer)

define_shared_DataRef("DanielLOWG/Briefing/FlightInformation/Cruise_Alt","Int")
	DataRef( "DREF_GENERAL_Cruise_Alt", "DanielLOWG/Briefing/FlightInformation/Cruise_Alt", "writeable")

define_shared_DataRef("DanielLOWG/Briefing/ATIS/QNH_inHG","Float")
	DataRef( "DREF_ATIS_QNH_inHG", "DanielLOWG/Briefing/ATIS/QNH_inHG", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/ATIS/QNH_is_HPa","Int")
	DataRef( "DREF_ATIS_QNH_is_HPa", "DanielLOWG/Briefing/ATIS/QNH_is_HPa", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/ATIS/Temperature","Int")
	DataRef( "DREF_ATIS_Temperature", "DanielLOWG/Briefing/ATIS/Temperature", "writeable")	

define_shared_DataRef("DanielLOWG/Briefing/Departure/Init_Alt","Int")
	DataRef( "DREF_DEP_Init_Alt", "DanielLOWG/Briefing/Departure/Init_Alt", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Departure/Init_HDG","Int")
	DataRef( "DREF_DEP_Init_HDG", "DanielLOWG/Briefing/Departure/Init_HDG", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Departure/Init_Speed","Int")
	DataRef( "DREF_DEP_Init_Speed", "DanielLOWG/Briefing/Departure/Init_Speed", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Departure/Flaps","Int")
	DataRef( "DREF_DEP_Flaps", "DanielLOWG/Briefing/Departure/Flaps", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Departure/AntiIce_Wing","Int")
	DataRef( "DREF_DEP_AntiIce_Wing", "DanielLOWG/Briefing/Departure/AntiIce_Wing", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Departure/AntiIce_Engine","Int")
	DataRef( "DREF_DEP_AntiIce_Engine", "DanielLOWG/Briefing/Departure/AntiIce_Engine", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Departure/Briefing_Confirmed","Int")
	DataRef( "DREF_DEP_Briefing_Confirmed", "DanielLOWG/Briefing/Departure/Briefing_Confirmed", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Departure/v1","Int")
	DataRef( "DREF_DEP_v1", "DanielLOWG/Briefing/Departure/v1", "writeable")	
define_shared_DataRef("DanielLOWG/Briefing/Departure/vr","Int")
	DataRef( "DREF_DEP_vr", "DanielLOWG/Briefing/Departure/vr", "writeable")	
define_shared_DataRef("DanielLOWG/Briefing/Departure/v2","Int")
	DataRef( "DREF_DEP_v2", "DanielLOWG/Briefing/Departure/v2", "writeable")	


define_shared_DataRef("DanielLOWG/Briefing/Approach/Flaps","Int")
	DataRef( "DREF_APP_Flaps", "DanielLOWG/Briefing/Approach/Flaps", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Approach/Apt_Elevation","Int")
	DataRef( "DREF_APP_Apt_Elev", "DanielLOWG/Briefing/Approach/Apt_Elevation", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Approach/Min_App_Speed","Int")
	DataRef( "DREF_APP_Min_Speed", "DanielLOWG/Briefing/Approach/Min_App_Speed", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Approach/Autobrakes","Int")
	DataRef( "DREF_APP_AutoBrakes", "DanielLOWG/Briefing/Approach/Autobrakes", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Approach/Min_is_Baro","Int")
	DataRef( "DREF_APP_Min_is_Baro", "DanielLOWG/Briefing/Approach/Min_is_Baro", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Approach/Minimums","Int")
	DataRef( "DREF_APP_Minimums", "DanielLOWG/Briefing/Approach/Minimums", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Approach/Briefing_Desc_Confirmed","Int")
	DataRef( "DREF_APP_Briefing_Desc_Confirmed", "DanielLOWG/Briefing/Approach/Briefing_Desc_Confirmed", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/Approach/Briefing_App_Confirmed","Int")
	DataRef( "DREF_APP_Briefing_App_Confirmed", "DanielLOWG/Briefing/Approach/Briefing_App_Confirmed", "writeable")	

define_shared_DataRef("DanielLOWG/Briefing/GoArround/HDG","Int")
	DataRef( "DREF_GA_HDG", "DanielLOWG/Briefing/GoArround/HDG", "writeable")
define_shared_DataRef("DanielLOWG/Briefing/GoArround/Alt","Int")
	DataRef( "DREF_GA_Alt", "DanielLOWG/Briefing/GoArround/Alt", "writeable")



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- DataRef's
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DataRef( "DREF_COM1_MHz", "sim/cockpit2/radios/actuators/com1_standby_frequency_Mhz")
DataRef( "DREF_COM1_kHz", "sim/cockpit2/radios/actuators/com1_standby_frequency_khz")

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Custom Commands
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Menu Commands
	create_command( "DanielLOWG/myBriefing/Briefing_Menu", "Briefing Menu", "DM_cmd_briefing_menu = true", "", "DM_cmd_briefing_menu = false" )	


-- Radio Commands
	create_command( "DanielLOWG/myBriefing/Radio/next_Station", "next COM Station", "DM_cmd_COM_next = true", "", "" )
	create_command( "DanielLOWG/myBriefing/Radio/last_Station", "last COM Station", "DM_cmd_COM_last = true", "", "" )	
	create_command( "DanielLOWG/myBriefing/Radio/set_COM_Station_Stby1", "set COM Station to Standby1", "DM_cmd_COM1_set = true", "", "" )	
	
	DataRef( "Squawk", "sim/cockpit2/radios/actuators/transponder_code", "writeable")

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Variables
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Variable to check if myLuaCopilot is active for which plane
local myLuaCopilot_avail_Acf = ""	


-- Style Variables (Font size, colors, and so on....)
local STYLE_Font_size = 1.0	-- General Standard Font Size
local STYLE_Alert = 0xFF0000FF
local STYLE_Headline = 0xFF006AFF
local STYLE_Briefing = 0xFF00FF6B


-- Windows
local WIN_BriefingMenu_show = false
local WIN_BriefingMenu_width = 150

local WIN_FlightInfo_show = false
local WIN_FlightInfo_active = false

local WIN_ATIS_show = false
local WIN_ATIS_active = false

local WIN_DepBriefing_show = false
local WIN_DepBriefing_active = false

local WIN_AppBriefing_show = false
local WIN_AppBriefing_active = false





-- Radio Station Names and Frequency Variables
local Radio_COM_Station_ID = 1
local Radio_COM_Station_List_Name = {"Unicom"}
local Radio_COM_Station_List_Frq = {122.800}
local Radio_COM_Station_act_Name = Radio_COM_Station_List_Name[Radio_COM_Station_ID]
local Radio_COM_Station_act_Frq = Radio_COM_Station_List_Frq[Radio_COM_Station_ID]
	-- Copilot Knob turning Variables
	local set_COM1_MHz_Standby = false
	local set_COM1_kHz_Standby = false
		local set_COM1_Standby_val = 122.800
local Radio_COM_Station_show_Timer = 0

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- All Varibales which should be reseted for new flight
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function newFlight()
	-- General Flight Information 
	GENERAL_FlightNumber = ""	-- Flight Number
	GENERAL_Callsign = ""	-- Callsign will be build by Call sign and Aircraft Category
	GENERAL_Callsign_show = true	-- Show Callsign on Screen
		
		-- List of Selectable Aircrafts and accompanying Aircraft Categories
		GENERAL_Acf_ID = 1 -- initial ID 
		GENERAL_Acf_Model_ID = 1
		
		GENERAL_Acf_List = {}
		for i = 1, #Your_Hangar_List do
			GENERAL_Acf_List[i] = Your_Hangar_List[i]
		end
		
		-- GENERAL_Acf_Category_List = Your_Hangar_List_Category
		
		GENERAL_Acf = Your_Hangar_List[GENERAL_Acf_ID]
		GENERAL_Acf_Name = GENERAL_Acf:getName()
		GENERAL_Acf_Models = GENERAL_Acf:getModels()
		GENERAL_Acf_Model = GENERAL_Acf_Models[GENERAL_Acf_Model_ID]
		GENERAL_Acf_Category = GENERAL_Acf:getCategory()
	
		
		DEP_Flaps_actList = GENERAL_Acf:getDEP_Flaps()
		APP_Flaps_actList = GENERAL_Acf:getAPP_Flaps()
		APP_AutoBrake_actList = GENERAL_Acf:getAutobrake()
		APP_AutoBrake_actValList = GENERAL_Acf:getAutobrake_val()
		
	
	
	-- Used for Clearence Request phrase
		GENERAL_Park = "" -- Gate or Stand Number
		GENERAL_Dest = "" -- Destination
		
		DREF_GENERAL_Cruise_Alt = 5000	-- Flight Altitude will be used for automaticaly set Flight Altitude in the Aircraft by myLuaCopilot
						
		QNH_is_HPa = true	-- QNH setting HPa or inHG --> connected with ATIS selection

	-- ATIS/AWOS (self explanating)
		ATIS_Info = ""
		ATIS_Rwy = ""
		ATIS_Transition = 10000
		ATIS_Wind = ""
		ATIS_Temp = ""
			DREF_ATIS_Temperature = tonumber(ATIS_Temp)
		ATIS_Dew = ""
		ATIS_QNH_inHg = 29.92


	-- Departure Briefing
		DEP_Navi = "Clearence"	-- Departure Briefing Window Tab Navigation 
	
		-- Clearence Tab
			DEP_WPT = ""	-- SID Waypoint of Departure Route (example: RUPET)
			DEP_SID = ""	-- SID Identifier (example: 2M)
			DEP_RWY = ""	-- Runway
			DREF_DEP_Init_Alt = 5000	-- Initial Altitude
			DEP_Squawk = 1200	-- Squawk Code
			DEP_Squawk_txt = tostring(DEP_Squawk)
			DEP_remarks = ""	-- Any Additional Information given at Clearence

		-- Departure Config Tab
			DEP_PushBack = false

			DEP_minFuel = 0	-- Minimum Take Off Fuel --> will be crosschecked with remaining fuel before Take Off with myLuaCopilot
			DEP_Trim = 0.0	-- T/O Trim
			DEP_Flaps = 0	-- T/O Flaps --> Selectable from List by Aircraft Type
				DEP_Flaps_conf = 1
				DEP_Flaps_str = "0"

			-- V-Speeds
			DEP_V1 = 100
				DREF_DEP_v1 = DEP_V1
			DEP_V2 = 100
				DREF_DEP_v2 = DEP_V2
			DEP_VR = 100
				DREF_DEP_vr = DEP_VR

			-- Autopilot Settings
			DEP_LAT = "OFF"	-- Lateral Mode: OFF, LNAV, HDG
			DEP_Init_HDG = 360	-- Initial Heading
			DREF_DEP_Init_Speed = 100	-- Initial Speed
							-- Initial Altitude is given by Clearence

			-- Anti Ice Settings
			DEP_ICE_Wing = false
			DEP_ICE_Eng = false
			
			DREF_DEP_Briefing_Confirmed = 0
		
		-- Radio Tab
			-- Station Names
			DEP_COM1_Gnd_lbl = ""
			DEP_COM1_Twr_lbl = ""
			DEP_COM1_Dep_lbl = ""
			DEP_COM1_Ctr_lbl = ""
			-- Station Frequencies
			DEP_COM1_Gnd_frq = 122.8
			DEP_COM1_Twr_frq = 122.8
			DEP_COM1_Dep_frq = 122.8
			DEP_COM1_Ctr_frq = 122.8
			-- Flag if the Station is available --> if false Station will not be listed
			DEP_COM1_Gnd_use = false
			DEP_COM1_Twr_use = false
			DEP_COM1_Dep_use = false
			DEP_COM1_Ctr_use = false

	-- Approach
		APP_Navi = "Clearence"	-- Approach Briefing Window Tab Navigation 
			
			-- Arrival Clearence
				APP_Arrival_WPT = ""		-- STAR Arrival Waypoint --> Last Waypoint of filed Route
				APP_Arrival_Ident = ""		-- STAR Arrival Identifier
				APP_Transition_WPT = ""		-- STAR Transition Waypoint or IAF --> normaly last Waypoint of STAR Arrival Waypoint 
				APP_Transition_Ident = ""	-- STAR Transition Identifier if avail
				APP_RWY = ""				-- Arrival Runway

				APP_Remarks1 = ""
				APP_Remarks2 = ""
			-- Approach Config
				
				-- Speeds and Flaps
					APP_Vref = 0	-- Landing Reference Speed
					DREF_APP_Min_Speed = 0	-- Approach Speed --> will automaticaly set 5kts above Vref on Vref change
					-- Flaps Landing Config --> same as for Departure
					APP_Flaps = 0	 
					APP_Flaps_conf = 1
					APP_Flaps_str = "0"
			

				-- Type of Approach 
					APP_AppType_List = {"VISUAL","ILS","VOR","NDB","RNAV"}
						APP_AppType_ID = 1
						APP_AppType = APP_AppType_List[APP_AppType_ID]
							APP_ILS_CRS = 360
							APP_ILS_Frq = 110.90
								APP_ILS_set_act1 = false
								APP_ILS_set_stby1 = false
								APP_ILS_set_act2 = false
								APP_ILS_set_stby2 = false
							APP_VOR_CRS = 360
							APP_VOR_Frq = 110.90
								APP_VOR_set_act1 = false
								APP_VOR_set_stby1 = false
								APP_VOR_set_act2 = false
								APP_VOR_set_stby2 = false
							APP_NDB_Frq = 110.90
								APP_NDB_set_act1 = false
								APP_NDB_set_stby1 = false
								APP_NDB_set_act2 = false
								APP_NDB_set_stby2 = false

				-- 	MISC relevant Parameters --> myLuaCopilot will set it in Descent Phase if available
					APP_Min_Radio = true 	-- Minimums: Radio/Baro
					DREF_APP_Minimums = 0			-- Minimums: Altitude 
					APP_RWY_Track = 360		-- Runway Track
					DREF_APP_Apt_Elev = 0		-- Landing Altitude (Airport Elevation) for Pressurisation if necessary for this Aircraft Type
					DREF_APP_AutoBrakes = 1	-- Autobrake
						APP_AutoBrake_str = "0"
						APP_AutoBrake_val = 0
				
				-- Go Arround Parameters --> myLuaCopilot will set it during Landing Checklist if available
					APP_GA_HDG = APP_RWY_Track		-- Go Arround Heading
					DREF_GA_Alt = 5000	-- Go Arround Altitude


					DREF_APP_Briefing_Desc_Confirmed = 0
					DREF_APP_Briefing_App_Confirmed = 0
					
			-- Radio Tab
				-- Station Names
				APP_COM1_Gnd_lbl = ""
				APP_COM1_Twr_lbl = ""
				APP_COM1_Dir_lbl = ""
				APP_COM1_App_lbl = ""
				APP_COM1_Ctr_lbl = ""
				-- Station Frequencies
				APP_COM1_Gnd_frq = 122.8
				APP_COM1_Twr_frq = 122.8
				APP_COM1_Dir_frq = 122.8
				APP_COM1_App_frq = 122.8
				APP_COM1_Ctr_frq = 122.8
				-- Flag if the Station is available --> if false Station will not be listed
				APP_COM1_Gnd_use = false
				APP_COM1_Twr_use = false
				APP_COM1_Dir_use = false
				APP_COM1_App_use = false
				APP_COM1_Ctr_use = false
				
	
	
	-- Init Procedures
	if XFO_next_Procedure ~= nil then
		PROC_next = XFO_next_Procedure
	else
		PROC_next = 0
	end
	--[[
	if PROC_List == nil then
		PROC_List = {"No Action"}
	end
	]]--
	
	
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- All Varibales which should be reseted for new ATIS/AWOS Informations
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function newATIS()
	-- ATIS/AWOS
	ATIS_Info = ""			-- Information Identifier 
	ATIS_Rwy = ""			-- Runways in use
	ATIS_Transition = 10000	-- Transition Altitude
	ATIS_Wind = ""			-- Windinformation xxx/xx Direction/Speed
	ATIS_Temp = ""			-- Temperatur
	ATIS_Dew = ""			-- Dewpoint
	ATIS_QNH_inHg = 29.92	-- QNH will be inHg for all calculations
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Briefing Windows
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- General Flight Information Window
function WIN_FlightInfo_draw(WIN_FlightInfo, x, y)

	WIN_FlightInfo_active = true

	-- Gui position parameter
	local win_width = imgui.GetWindowWidth()
    local win_height = imgui.GetWindowHeight()
	
	local InIdent = " "	-- Is used for all Input fields as Label and will be added with one space after each use to be unique
	
	local firstColumn_width = 180
	
	
	-- Table
	imgui.Columns(2,"FlightInfo1",false)
	imgui.SetColumnWidth(0, firstColumn_width)
	imgui.SetColumnWidth(1, 250)


	-- Flight Call Sign	
		imgui.TextUnformatted("Call Sign:")
		imgui.SetColumnWidth(1, 250)
										
			local changed, newGENERAL_Callsign_show = imgui.Checkbox("Show", GENERAL_Callsign_show)
			if changed then
				GENERAL_Callsign_show = newGENERAL_Callsign_show
			end
		
		imgui.NextColumn()
			
		imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
		imgui.TextUnformatted(GENERAL_Callsign)
		imgui.PopStyleColor()
		imgui.NextColumn()

		imgui.Separator()
	
	-- Flight Number	
		imgui.TextUnformatted("Flight Number:")
		imgui.NextColumn()
		
		local changed, new_GENERAL_FlightNumber = imgui.InputText(InIdent, GENERAL_FlightNumber, 15)
		if changed then
			GENERAL_FlightNumber = new_GENERAL_FlightNumber
		end
			InIdent = InIdent .. " "
					
		imgui.NextColumn()
	
	-- Aircraft Type
		imgui.TextUnformatted("Aircraft Type:")
		imgui.NextColumn()
		
		if imgui.BeginCombo(InIdent, GENERAL_Acf_List[GENERAL_Acf_ID]:getName()) then
            for i = 1, #GENERAL_Acf_List do
                if imgui.Selectable(GENERAL_Acf_List[i]:getName(), GENERAL_Acf_ID == i) then
                    GENERAL_Acf_ID = i			
                end
            end
            imgui.EndCombo()
        end
			InIdent = InIdent .. " "
		
			GENERAL_Acf_Models = GENERAL_Acf:getModels()
			GENERAL_Acf_Model = GENERAL_Acf_Models[GENERAL_Acf_Model_ID]
		
		
		Airplane_Select() -- Select Aircraft Data		
			
		--GENERAL_Acf_Model
		if imgui.BeginCombo(InIdent, GENERAL_Acf_Models[GENERAL_Acf_Model_ID]) then
            for i = 1, #GENERAL_Acf_Models do
                if imgui.Selectable(GENERAL_Acf_Models[i], GENERAL_Acf_Model_ID == i) then
                    GENERAL_Acf_Model_ID = i
                end
            end
            imgui.EndCombo()
        end
			InIdent = InIdent .. " "

		
		
		


		imgui.NextColumn()

		imgui.TextUnformatted(" ")
		imgui.NextColumn()

		imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF21FF00)
		imgui.TextUnformatted(myLuaCopilot_avail_Acf)
		imgui.PopStyleColor()
		imgui.NextColumn()

	-- Parking Position
		imgui.TextUnformatted("Parking Position:")
		imgui.NextColumn()
		
		local changed, new_GENERAL_Park = imgui.InputText(InIdent, GENERAL_Park, 15)
		if changed then
			GENERAL_Park = new_GENERAL_Park
		end
			InIdent = InIdent .. " "
		imgui.NextColumn()
	
	-- Destination
		imgui.TextUnformatted("Destination:")
		imgui.NextColumn()
		
		local changed, new_GENERAL_Dest = imgui.InputText(InIdent, GENERAL_Dest, 15)
		if changed then
			GENERAL_Dest = new_GENERAL_Dest
		end
			InIdent = InIdent .. " "
		imgui.NextColumn()

	-- Cruising Altitude
		imgui.TextUnformatted("Cruising Altitude:")
		imgui.NextColumn()
		
		local changed, new_DREF_GENERAL_Cruise_Alt = imgui.InputInt(InIdent, DREF_GENERAL_Cruise_Alt, 1000)
		if changed then
			DREF_GENERAL_Cruise_Alt = new_DREF_GENERAL_Cruise_Alt
		end
			InIdent = InIdent .. " "
		imgui.NextColumn()
	imgui.Separator()


	-- Settings

	-- Barometer Setting
		imgui.SetColumnWidth(1, 250)
		imgui.TextUnformatted("Barometer Setting:")
		imgui.NextColumn()
		
			if imgui.RadioButton("HPa", QNH_is_HPa == true) then
				QNH_is_HPa = true
			end
			--imgui.SameLine()
			if imgui.RadioButton("inHG", QNH_is_HPa == false) then
				QNH_is_HPa = false
			end
		imgui.NextColumn()
	
	imgui.Separator()
	
	-- Clear all Data entered --> New Flight
	if imgui.Button("New Flight") then
		newFlight()
	end
	
	
	
end
function WIN_FlightInfo_close(WIN_FlightInfo)
	WIN_FlightInfo_show = false
	WIN_FlightInfo_active = false
	open_myBriefingMenu()
end

-- ATIS/AWOS Window
function WIN_ATIS_draw(WIN_ATIS, x, y)

	WIN_ATIS_active = true



	-- Gui position parameter
	local win_width = imgui.GetWindowWidth()
    local win_height = imgui.GetWindowHeight()
	
	local InIdent = " "	-- Is used for all Input fields as Label and will be added with one space after each use to be unique
	
	local firstColumn_width = 180
	
	-- Table
	imgui.Columns(2,"ATIS1",false)
	imgui.SetColumnWidth(0, firstColumn_width)
		
	-- Information Identifier	
		imgui.SetColumnWidth(1, 40)
		imgui.TextUnformatted("Information:")
		imgui.NextColumn()
			local changed, new_ATIS_Info = imgui.InputText(InIdent, ATIS_Info, 2)
			if changed then
				ATIS_Info = new_ATIS_Info
			end
				InIdent = InIdent .. " "
		imgui.NextColumn()
	
	-- Runway in use
		imgui.SetColumnWidth(1, 200)
		imgui.TextUnformatted("Runway's in use:")
		imgui.NextColumn()
			local changed, new_ATIS_Rwy = imgui.InputText(InIdent, ATIS_Rwy, 40)
			if changed then
				ATIS_Rwy = new_ATIS_Rwy
			end
				InIdent = InIdent .. " "
		imgui.NextColumn()
	
	-- Transition Level
		imgui.SetColumnWidth(1, 200)
		imgui.TextUnformatted("Transition Alt/Level:")
		imgui.NextColumn()
			local changed, new_ATIS_Transition = imgui.InputInt(InIdent, ATIS_Transition, 1000)
			if changed then
				ATIS_Transition = new_ATIS_Transition
			end
				InIdent = InIdent .. " "
		imgui.NextColumn()
		
	-- Wind
		imgui.SetColumnWidth(1, 200)
		imgui.TextUnformatted("Wind:")
		imgui.NextColumn()
			local changed, new_ATIS_Wind = imgui.InputText(InIdent, ATIS_Wind, 20)
			if changed then
				ATIS_Wind = new_ATIS_Wind
			end
				InIdent = InIdent .. " "
		imgui.NextColumn()
		
	-- Temperatur
		imgui.SetColumnWidth(1, 50)
		imgui.TextUnformatted("Temperatur:")
		imgui.NextColumn()
			local changed, new_ATIS_Temp = imgui.InputText(InIdent, ATIS_Temp, 4)
			if changed then
				ATIS_Temp = new_ATIS_Temp
			end
				InIdent = InIdent .. " "
		imgui.NextColumn()
			
	-- Dewpoint
		imgui.SetColumnWidth(1, 50)
		imgui.TextUnformatted("Dewpoint:")
		imgui.NextColumn()
			local changed, new_ATIS_Dew = imgui.InputText(InIdent, ATIS_Dew, 4)
			if changed then
				ATIS_Dew = new_ATIS_Dew
			end
				InIdent = InIdent .. " "
		imgui.NextColumn()
	
	
	-- QNH
		imgui.SetColumnWidth(1, 150)
		imgui.TextUnformatted("QNH:")
		imgui.NextColumn()
			if QNH_is_HPa == true then
				local QNH = DM_round(ATIS_QNH_inHg / 0.02952999)
				
				local changed, new_QNH = imgui.InputInt("HPa", QNH, 1)
				if changed then
					ATIS_QNH_inHg = new_QNH * 0.02952999
				end
			else
				local changed, new_QNH = imgui.InputFloat("inHG", ATIS_QNH_inHg, 0.01, 0, "%.2f", 0.1)
				if changed then
					ATIS_QNH_inHg = new_QNH
				end
			end
		
			-- QNH Selection HPa/inHG
			if imgui.RadioButton("HPa", QNH_is_HPa == true) then
				QNH_is_HPa = true
			end
			imgui.SameLine()
			if imgui.RadioButton("inHG", QNH_is_HPa == false) then
				QNH_is_HPa = false
			end
		
		
		imgui.NextColumn()
	imgui.Separator()
	
	-- Clear ATIS
	if imgui.Button("Reset ATIS/AWOS") then
		newATIS()
	end
		
	
	
	
end
function WIN_ATIS_close(WIN_ATIS)
	WIN_ATIS_show = false
	WIN_ATIS_active = false
	open_myBriefingMenu()
end


-- Departure Briefing Window
function WIN_DepBriefing_draw(WIN_DepBriefing, x, y)

	WIN_DepBriefing_active = true

	-- Gui position parameter
	local win_width = imgui.GetWindowWidth()
    local win_height = imgui.GetWindowHeight()
	
	local InIdent = " "	-- Is used for all Input fields as Label and will be added with one space after each use to be unique
	
	local Buttons_per_row = 3
	local firstColumn_width = 180
	
	local Text_next = ""
	local QNH_str = ""
	
	-- QNH String
		if QNH_is_HPa == true then
			QNH_str = tostring(DM_round(ATIS_QNH_inHg / 0.02952999))
		else
			QNH_str =  tostring(DM_round(ATIS_QNH_inHg * 10^2)*10^-2) 
		end
	
	
	
	-- Tab Buttons
		-- Clearence
			if DEP_Navi == "Clearence" then
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF006AFF)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFF006AFF)
			else
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF6F4624)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFFFA9642)
			end
			if imgui.Button("Clearence",(win_width - 32 ) / Buttons_per_row ,32) then
				DEP_Navi = "Clearence"
			end
			imgui.PopStyleColor()
			imgui.PopStyleColor()
			imgui.SameLine()
		
		-- Departure Configuration
			if DEP_Navi == "DEP_Config" then
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF006AFF)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFF006AFF)
			else
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF6F4624)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFFFA9642)
			end
			if imgui.Button("Departure Config",(win_width - 32) / Buttons_per_row ,32) then
				DEP_Navi = "DEP_Config"
			end
			imgui.PopStyleColor()
			imgui.PopStyleColor()
			imgui.SameLine()
		
		-- Radio Settings
			if DEP_Navi == "DEP_Radio" then
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF006AFF)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFF006AFF)
			else
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF6F4624)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFFFA9642)
			end
			if imgui.Button("Radio",(win_width - 32) / Buttons_per_row ,32) then
				DEP_Navi = "DEP_Radio"
			end
			imgui.PopStyleColor()
			imgui.PopStyleColor()
			--imgui.SameLine()
		imgui.Separator()
	
	
	-- Tab Content
		
		-- Clearence Tab
		if DEP_Navi == "Clearence" then
			InIdent = " "	-- Input Box Identifier Label
			imgui.Columns(2,"Depart",false)
			imgui.SetColumnWidth(0, firstColumn_width)
			imgui.SetColumnWidth(1, win_width - firstColumn_width-16)
			
			-- IFR Clearence Request Phrase generated with Data from General Flight Information and ATIS/AWOS
				imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
				imgui.TextUnformatted("Request Phrase:")
				imgui.PopStyleColor()
				
				imgui.NextColumn()
				
				-- Phrase
				imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFF9400)
					imgui.TextUnformatted("Station: \10" .. GENERAL_Callsign .. " at " .. GENERAL_Park .. ", " .. GENERAL_Acf_Name .. " " ..GENERAL_Acf_Model .. "\10with Information " .. ATIS_Info .. ", QNH " .. QNH_str .. ", \10request clearence to " .. GENERAL_Dest)
				imgui.PopStyleColor()
				imgui.NextColumn()
			
			imgui.Separator()		
			
			-- Clearence Parameters
				imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
				imgui.TextUnformatted("Clearence:")
				imgui.PopStyleColor()
				imgui.NextColumn()
				imgui.TextUnformatted("")
				imgui.NextColumn()	
				
				-- Destination
					imgui.SetColumnWidth(1, 150)
					imgui.TextUnformatted("Destination:")
					imgui.NextColumn()
										
					local changed, new_DEP_WPT = imgui.InputText(InIdent, GENERAL_Dest, 15)
					if changed then
						DEP_WPT = new_DEP_WPT
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
					
				-- SID
					imgui.SetColumnWidth(1, 150)
					imgui.TextUnformatted("SID:")
					imgui.NextColumn()
					
					-- Sid Waypoint
					local changed, new_DEP_WPT = imgui.InputText(InIdent, DEP_WPT, 15)
					if changed then
						DEP_WPT = new_DEP_WPT
					end
						InIdent = InIdent .. " "
					-- SID Identifier
					local changed, new_DEP_SID = imgui.InputText(InIdent, DEP_SID, 15)
					if changed then
						DEP_SID = new_DEP_SID
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
		
				-- Departure Runway
					imgui.SetColumnWidth(1, 50)
					imgui.TextUnformatted("Departure Runway:")
					imgui.NextColumn()
					
					local changed, new_DEP_RWY = imgui.InputText(InIdent, DEP_RWY, 15)
					if changed then
						DEP_RWY = new_DEP_RWY
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
			
				-- Initial Altitude
					imgui.SetColumnWidth(1, 150)
					imgui.TextUnformatted("Initial Altitude:")
					imgui.NextColumn()
					
					local changed, new_DREF_DEP_Init_Alt = imgui.InputInt(InIdent, DREF_DEP_Init_Alt, 1000)
					if changed then
						DREF_DEP_Init_Alt = new_DREF_DEP_Init_Alt
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
				
				-- Squawk Code
					imgui.SetColumnWidth(1, 73)
					imgui.TextUnformatted("Squawk Code:")
					imgui.NextColumn()
					
					local changed, new_DEP_Squawk_txt = imgui.InputText("", tostring(DEP_Squawk), 5)
					if changed then
						DEP_Squawk_txt = corr_squawk(new_DEP_Squawk_txt)
						DEP_Squawk = tonumber(DEP_Squawk_txt)
					end
						InIdent = InIdent .. " "
					
						imgui.SameLine()
						if imgui.Button("SET") then
							Squawk = DEP_Squawk
						end
							
					imgui.NextColumn()
				
				-- Remarks if there are extra informations at delivery
					imgui.SetColumnWidth(1, win_width - firstColumn_width-16)
					imgui.TextUnformatted("Remarks:")
					imgui.NextColumn()
					
					local changed, new_DEP_remarks = imgui.InputText(InIdent, DEP_remarks, 30)
					if changed then
						DEP_remarks = new_DEP_remarks
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
				imgui.Separator()
			
			-- Next Stations Available
				imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
				imgui.TextUnformatted("Stations:")
				imgui.PopStyleColor()
				imgui.NextColumn()
				imgui.TextUnformatted("")
				imgui.NextColumn()
				
					for i = 1, #Radio_COM_Station_List_Name do
						imgui.TextUnformatted(Radio_COM_Station_List_Name[i] .. ":")
						imgui.NextColumn()
						imgui.TextUnformatted(tostring(Radio_COM_Station_List_Frq[i]))
						imgui.NextColumn()
					end
			
			
			
	
		-- Departure Configuration Tab
		elseif DEP_Navi == "DEP_Config" then
			InIdent = " "	-- Input Box Identifier Label
			imgui.Columns(2,"Depart",false)
			imgui.SetColumnWidth(0, firstColumn_width)
			imgui.SetColumnWidth(1, win_width - firstColumn_width-16)
			
			-- Departure Briefing
				imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Briefing)
				imgui.TextUnformatted("Departure Briefing:")
				imgui.PopStyleColor()
				imgui.NextColumn()
				imgui.TextUnformatted("")
				imgui.NextColumn()
			-- Block Off Options			
				imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
				imgui.TextUnformatted("Block Off:")
				imgui.PopStyleColor()
				imgui.NextColumn()
				imgui.TextUnformatted("")
				imgui.NextColumn()
				
				-- Push Back Option
					imgui.SetColumnWidth(1, 180)
					imgui.TextUnformatted("Push Back:")
					imgui.NextColumn()
					
					local changed, newDEP_PushBack = imgui.Checkbox(InIdent, DEP_PushBack)
					if changed then
						DEP_PushBack = newDEP_PushBack
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
				--imgui.Separator()
					
			-- Aircraft Configuration 	
				imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
				imgui.TextUnformatted("Aircraft Configuration:")
				imgui.PopStyleColor()
				imgui.NextColumn()
				imgui.TextUnformatted("")
				imgui.NextColumn()
			
				-- Min Take Off Fuel
					imgui.SetColumnWidth(1, 180)
					imgui.TextUnformatted("Minimum T/O Fuel:")
					imgui.NextColumn()
					
					local changed, new_DEP_minFuel = imgui.InputInt(InIdent, DEP_minFuel, 100)
					if changed then
						DEP_minFuel = new_DEP_minFuel
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
				
				-- Elevator Trim
					imgui.SetColumnWidth(1, 180)
					imgui.TextUnformatted("Elevator Trim:")
					imgui.NextColumn()
					
					local changed, new_DEP_Trim = imgui.InputFloat(InIdent, DEP_Trim, 0.1, 0, "%0.2f", 0.01)
					if changed then
						DEP_Trim = new_DEP_Trim
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
				
				-- Flaps Setting by Aircraft
					imgui.SetColumnWidth(1, 100-5)
					if DanielLOWG_ACF_Concorde ~= true then
						imgui.TextUnformatted("Take Off Flaps:")
					else
						imgui.TextUnformatted("Reheaters for T/O:")
					end
					imgui.NextColumn()
				
					-- Select Flap Setting
						if imgui.BeginCombo(InIdent, DEP_Flaps_actList[DEP_Flaps_conf]) then
							for i = 1, #DEP_Flaps_actList do
								if imgui.Selectable(DEP_Flaps_actList[i], DEP_Flaps_conf == i) then
									DEP_Flaps_conf = i
								end
							end
							imgui.EndCombo()
						end
							InIdent = InIdent .. " "
						DEP_Flaps_str = DEP_Flaps_actList[DEP_Flaps_conf]
						DEP_Flaps = tonumber(DEP_Flaps_str)
							
					imgui.NextColumn()
				--imgui.Separator()
				
			-- V Speeds
				imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
				imgui.TextUnformatted("V-Speeds:")
				imgui.PopStyleColor()
				imgui.NextColumn()
				imgui.TextUnformatted("")
				imgui.NextColumn()
				
				-- V1
					imgui.SetColumnWidth(1, 130)
					imgui.TextUnformatted("V1 Min Reject T/O Speed:")
					imgui.NextColumn()
					
					local changed, new_DEP_V1 = imgui.InputInt(InIdent, DEP_V1, 1)
					if changed then
						DEP_V1 = new_DEP_V1
						DREF_DEP_v1 = DEP_V1
						if DEP_VR < DEP_V1 then
							DEP_VR = DEP_V1
							DREF_DEP_vr = DEP_VR
						end
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
				
				-- V Rotate
					imgui.SetColumnWidth(1, 130)
					imgui.TextUnformatted("VR Rotation Speed:")
					imgui.NextColumn()
					
					local changed, new_DEP_VR = imgui.InputInt(InIdent, DEP_VR, 1)
					if changed then
						DEP_VR = new_DEP_VR
						DREF_DEP_vr = DEP_VR
						if DEP_V2 < DEP_VR then
							DEP_V2 = DEP_VR
							DREF_DEP_v2 = DEP_V2
						end
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
				
					imgui.SetColumnWidth(1, 130)
					imgui.TextUnformatted("V2 T/O Safety Speed:")
					imgui.NextColumn()
				
				-- V2
					local changed, new_DEP_V2 = imgui.InputInt(InIdent, DEP_V2, 1)
					if changed then
						DEP_V2 = new_DEP_V2
						DREF_DEP_v2 = DEP_V2
						DREF_DEP_Init_Speed = new_DEP_V2 + 15 -- change Initial Speed with this option
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()					
				--imgui.Separator()
			
			-- Autopilot Configuration
				imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
				imgui.TextUnformatted("Autopilot Configuration:")
				imgui.PopStyleColor()
				imgui.NextColumn()
				imgui.TextUnformatted("")
				imgui.NextColumn()
				
				--[[
				-- Lateral Navigation
					imgui.SetColumnWidth(1, 150)
					imgui.TextUnformatted("Lateral Control:")
					imgui.NextColumn()
				
					if imgui.RadioButton("OFF", DEP_LAT == "OFF") then
						DEP_LAT = "OFF"
					end
					--imgui.SameLine()
					if imgui.RadioButton("LNAV", DEP_LAT == "LNAV") then
						DEP_LAT = "LNAV"
					end
					if imgui.RadioButton("HDG", DEP_LAT == "HDG") then
						DEP_LAT = "HDG"
					end
					imgui.NextColumn()
				]]--
				-- Initial Heading
					imgui.SetColumnWidth(1, 130)
					imgui.TextUnformatted("Initial Heading:")
					imgui.NextColumn()
					
					local changed, new_DEP_Init_HDG = imgui.InputInt(InIdent, DEP_Init_HDG, 1)
					if changed then
						DEP_Init_HDG = new_DEP_Init_HDG
					end
						InIdent = InIdent .. " "
					-- Correct Heading	
						if DEP_Init_HDG > 360 then
							DEP_Init_HDG = 1
						elseif DEP_Init_HDG < 1 then
							DEP_Init_HDG = 360
						end
					
					imgui.NextColumn()
					
				-- Initial Speed
					imgui.SetColumnWidth(1, 130)
					imgui.TextUnformatted("Initial Climb Speed:")
					imgui.NextColumn()
					
					local changed, new_DREF_DEP_Init_Speed = imgui.InputInt(InIdent, DREF_DEP_Init_Speed, 1)
					if changed then
						DREF_DEP_Init_Speed = new_DREF_DEP_Init_Speed
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()	
			
				-- Initial Altitude
					imgui.SetColumnWidth(1, 130)
					imgui.TextUnformatted("Initial Altitude:")
					imgui.NextColumn()
					
					local changed, new_DREF_DEP_Init_Speed = imgui.InputInt(InIdent, DREF_DEP_Init_Alt, 1)
					--[[ not changeable here
					if changed then
						DREF_DEP_Init_Speed = new_DREF_DEP_Init_Speed
					end
					]]--
						InIdent = InIdent .. " "
					--imgui.TextUnformatted(tostring(DREF_DEP_Init_Alt))
					imgui.NextColumn()
				--imgui.Separator()
				
				
			-- Anti Ice Configuration			
				imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
				imgui.TextUnformatted("Anti Ice:")
				imgui.PopStyleColor()
				imgui.NextColumn()
				imgui.TextUnformatted("")
				imgui.NextColumn()
				
				-- Wing Anti Ice
					imgui.SetColumnWidth(1, 180)
					imgui.TextUnformatted("Wing Anti Ice:")
					imgui.NextColumn()
					
					local changed, newDEP_ICE_Wing = imgui.Checkbox(InIdent, DEP_ICE_Wing)
					if changed then
						DEP_ICE_Wing = newDEP_ICE_Wing
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
				-- Engine Anti Ice
					imgui.SetColumnWidth(1, 180)
					imgui.TextUnformatted("Engine Anti Ice:")
					imgui.NextColumn()
					
					local changed, newDEP_ICE_Eng = imgui.Checkbox(InIdent, DEP_ICE_Eng)
					if changed then
						DEP_ICE_Eng = newDEP_ICE_Eng
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
				-- Departure Briefing Confirmation
					imgui.Separator()
					imgui.SetColumnWidth(1, 180)
					imgui.TextUnformatted("Briefing Confirmed:")
					imgui.NextColumn()
					
					if DREF_DEP_Briefing_Confirmed == 0 then
						local check = false
					else
						local check = true
					end
					
					local changed, newcheck = imgui.Checkbox(InIdent, check)
					if changed then
						check = newcheck
					end
						if check == true then
							DREF_DEP_Briefing_Confirmed = 1
						else
							DREF_DEP_Briefing_Confirmed = 0
						end
					

						InIdent = InIdent .. " "
					imgui.NextColumn()
				
				
				imgui.Separator()

				-- Request V Speeds, Trim and Flaps from Airplane from myLuaCopilot 
					imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF21FF00)
					imgui.TextUnformatted(myLuaCopilot_avail_Acf)
					imgui.PopStyleColor()
					
					imgui.NextColumn()
					
					if myLuaCopilot_avail_Acf == "Boeing 727 (FJS)" then
						if imgui.Button("Request Data") then
						-- V-Speeds
							DEP_V1 = Speed_V1
							DEP_VR = Speed_Vr
							DEP_V2 = Speed_V2
							DREF_DEP_Init_Speed = DEP_V2 + 15
						-- Trim Setting
							if Trim_TO ~= nil then
								DEP_Trim = Trim_TO
							end
						
						-- Select Flaps Setting from List
							for i = 1, #DEP_Flaps_actList do
								if DEP_Flaps_actList[i] == tostring(math.floor(Flaps_TO)) then
									DEP_Flaps_conf = i
								end
							end
						end
					end

					if myLuaCopilot_avail_Acf == "Boeing 737-600 (LU)" then
						if imgui.Button("Request Data") then
						-- V-Speeds
							DEP_V1 = Speed_V1
							DEP_VR = Speed_Vr
							DEP_V2 = Speed_V2
							DREF_DEP_Init_Speed = DEP_V2 + 15
						-- Trim Setting
							DEP_Trim = Trim_TO
						
						-- Select Flaps Setting from List
							for i = 1, #DEP_Flaps_actList do
								if DEP_Flaps_actList[i] == tostring(math.floor(Flaps_TO)) then
									DEP_Flaps_conf = i
								end
							end
						end
					end					

					if myLuaCopilot_avail_Acf == "Boeing 737-700 (LU)" then
						if imgui.Button("Request Data") then
						-- V-Speeds
							DEP_V1 = Speed_V1
							DEP_VR = Speed_Vr
							DEP_V2 = Speed_V2
							DREF_DEP_Init_Speed = DEP_V2 + 15
						-- Trim Setting
							DEP_Trim = Trim_TO
						
						-- Select Flaps Setting from List
							for i = 1, #DEP_Flaps_actList do
								if DEP_Flaps_actList[i] == tostring(math.floor(Flaps_TO)) then
									DEP_Flaps_conf = i
								end
							end
						end
					end

					if myLuaCopilot_avail_Acf == "Boeing 737-800 (Zibo/LU)" then
						if imgui.Button("Request Data") then
						-- V-Speeds
							DEP_V1 = Speed_V1
							DEP_VR = Speed_Vr
							DEP_V2 = Speed_V2
							DREF_DEP_Init_Speed = DEP_V2 + 15
						-- Trim Setting
							DEP_Trim = Trim_TO
						
						-- Select Flaps Setting from List
							for i = 1, #DEP_Flaps_actList do
								if DEP_Flaps_actList[i] == tostring(math.floor(Flaps_TO)) then
									DEP_Flaps_conf = i
								end
							end
						end
					end

					if myLuaCopilot_avail_Acf == "Boeing 737-900 (LU)" then
						if imgui.Button("Request Data") then
						-- V-Speeds
							DEP_V1 = Speed_V1
							DEP_VR = Speed_Vr
							DEP_V2 = Speed_V2
							DREF_DEP_Init_Speed = DEP_V2 + 15
						-- Trim Setting
							DEP_Trim = Trim_TO
						
						-- Select Flaps Setting from List
							for i = 1, #DEP_Flaps_actList do
								if DEP_Flaps_actList[i] == tostring(math.floor(Flaps_TO)) then
									DEP_Flaps_conf = i
								end
							end
						end
					end
					
					if myLuaCopilot_avail_Acf == "Boeing 767 (FlightFactor)" then
						if imgui.Button("Request Data") then
						-- V-Speeds
							DEP_V1 = Speed_V1
							DEP_VR = Speed_Vr
							DEP_V2 = Speed_V2
							DREF_DEP_Init_Speed = DEP_V2 + 15
						-- Trim Setting
							if Trim_TO ~= nil then
								DEP_Trim = Trim_TO
							end
						
						-- Select Flaps Setting from List
							for i = 1, #DEP_Flaps_actList do
								if DEP_Flaps_actList[i] == tostring(math.floor(Flaps_TO)) then
									DEP_Flaps_conf = i
								end
							end
						end
					end
					
					--imgui.SetColumnWidth(1, 300)
					imgui.NextColumn()

					

		-- Radio Stations 
		elseif DEP_Navi == "DEP_Radio" then
			InIdent = " "	-- Input Box Identifier Label
			imgui.Columns(2,"Depart",false)
			imgui.SetColumnWidth(0, firstColumn_width)
			imgui.SetColumnWidth(1, win_width - firstColumn_width-16)
			
			-- COM Radios
			imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
			imgui.TextUnformatted("COM Stations")	
			imgui.PopStyleColor()
			imgui.NextColumn()
			imgui.TextUnformatted("")	
			imgui.NextColumn()
			
			-- Ground Station		
				-- Select if Station is Active
				local changed, new_DEP_COM1_Gnd_use = imgui.Checkbox("Ground:", DEP_COM1_Gnd_use)
				if changed then
					DEP_COM1_Gnd_use = new_DEP_COM1_Gnd_use
				end
				imgui.NextColumn()
				
				-- Name of the Station
				local changed, new_DEP_COM1_Gnd_lbl = imgui.InputText(InIdent, DEP_COM1_Gnd_lbl, 30)
				if changed then
					DEP_COM1_Gnd_lbl = new_DEP_COM1_Gnd_lbl
				end
					InIdent = InIdent .. " "
				-- Frequency of the Station	
				local changed, new_DEP_COM1_Gnd_frq = imgui.InputFloat("MHz", DEP_COM1_Gnd_frq, 0.025, 0, "%.3f", 0.1)
				if changed then
					DEP_COM1_Gnd_frq = corr_COM(new_DEP_COM1_Gnd_frq)
				end
				imgui.NextColumn()
			--imgui.Separator()
			
			-- Tower Station		
				-- Select if Station is Active
				local changed, new_DEP_COM1_Twr_use = imgui.Checkbox("Tower:", DEP_COM1_Twr_use)
				if changed then
					DEP_COM1_Twr_use = new_DEP_COM1_Twr_use
				end
				imgui.NextColumn()
				
				-- Name of the Station
				local changed, new_DEP_COM1_Twr_lbl = imgui.InputText(InIdent, DEP_COM1_Twr_lbl, 30)
				if changed then
					DEP_COM1_Twr_lbl = new_DEP_COM1_Twr_lbl
				end
					InIdent = InIdent .. " "
				-- Frequency of the Station	
				local changed, new_DEP_COM1_Twr_frq = imgui.InputFloat("MHz ", DEP_COM1_Twr_frq, 0.025, 0, "%.3f", 0.1)
				if changed then
					DEP_COM1_Twr_frq = corr_COM(new_DEP_COM1_Twr_frq)
				end
				imgui.NextColumn()
			--imgui.Separator()
			
			-- Departure Station		
					-- Select if Station is Active
					local changed, new_DEP_COM1_Dep_use = imgui.Checkbox("Departure:", DEP_COM1_Dep_use)
					if changed then
						DEP_COM1_Dep_use = new_DEP_COM1_Dep_use
					end
				imgui.NextColumn()
				
				-- Name of the Station
				local changed, new_DEP_COM1_Dep_lbl = imgui.InputText(InIdent, DEP_COM1_Dep_lbl, 30)
				if changed then
					DEP_COM1_Dep_lbl = new_DEP_COM1_Dep_lbl
				end
					InIdent = InIdent .. " "
				-- Frequency of the Station	
				local changed, new_DEP_COM1_Dep_frq = imgui.InputFloat("MHz  ", DEP_COM1_Dep_frq, 0.025, 0, "%.3f", 0.1)
				if changed then
					DEP_COM1_Dep_frq = corr_COM(new_DEP_COM1_Dep_frq)
				end
				imgui.NextColumn()
			--imgui.Separator()
		
			-- Center Station		
					-- Select if Station is Active
					local changed, new_DEP_COM1_Ctr_use = imgui.Checkbox("Center:", DEP_COM1_Ctr_use)
					if changed then
						DEP_COM1_Ctr_use = new_DEP_COM1_Ctr_use
					end
				imgui.NextColumn()
				
				-- Name of the Station
				local changed, new_DEP_COM1_Ctr_lbl = imgui.InputText(InIdent, DEP_COM1_Ctr_lbl, 30)
				if changed then
					DEP_COM1_Ctr_lbl = new_DEP_COM1_Ctr_lbl
				end
					InIdent = InIdent .. " "
				-- Frequency of the Station	
				local changed, new_DEP_COM1_Ctr_frq = imgui.InputFloat("MHz   ", DEP_COM1_Ctr_frq, 0.025, 0, "%.3f", 0.1)
				if changed then
					DEP_COM1_Ctr_frq = corr_COM(new_DEP_COM1_Ctr_frq)
				end
				imgui.NextColumn()
			imgui.Separator()
	
	
		end
	
end
function WIN_DepBriefing_close(WIN_DepBriefing)
	WIN_DepBriefing_show = false
	WIN_DepBriefing_active = false
	open_myBriefingMenu()
end

-- Approach Briefing Window
function WIN_AppBriefing_draw(WIN_AppBriefing, x, y)

	WIN_AppBriefing_active = true

	-- Gui position parameter
	local win_width = imgui.GetWindowWidth()
    local win_height = imgui.GetWindowHeight()
	local win_height_floating = 0
	
	local InIdent = " "	-- Is used for all Input fields as Label and will be added with one space after each use to be unique
	
	local Buttons_per_row = 3
	local firstColumn_width = 180
	
	local Text_next = ""
	local QNH_str = ""
	
	
	
	
	-- QNH String
		if QNH_is_HPa == true then
			QNH_str = tostring(DM_round(ATIS_QNH_inHg / 0.02952999))
		else
			QNH_str =  tostring(DM_round(ATIS_QNH_inHg * 10^2)*10^-2) 
		end
	
	
	
	-- Tab Buttons
		win_height_floating = win_height_floating + 40
		-- Clearence
			if APP_Navi == "Clearence" then
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF006AFF)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFF006AFF)
			else
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF6F4624)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFFFA9642)
			end
			if imgui.Button("Clearence",(win_width - 32 ) / Buttons_per_row ,32) then
				APP_Navi = "Clearence"
			end
			imgui.PopStyleColor()
			imgui.PopStyleColor()
			imgui.SameLine()
		
		-- Departure Configuration
			if APP_Navi == "APP_Config" then
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF006AFF)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFF006AFF)
			else
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF6F4624)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFFFA9642)
			end
			if imgui.Button("Approach Config",(win_width - 32) / Buttons_per_row ,32) then
				APP_Navi = "APP_Config"
			end
			imgui.PopStyleColor()
			imgui.PopStyleColor()
			imgui.SameLine()
		
		-- Radio Settings
			if APP_Navi == "APP_Radio" then
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF006AFF)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFF006AFF)
			else
				imgui.PushStyleColor(imgui.constant.Col.Button, 0xFF6F4624)
				imgui.PushStyleColor(imgui.constant.Col.ButtonHovered, 0xFFFA9642)
			end
			if imgui.Button("Radio",(win_width - 32) / Buttons_per_row ,32) then
				APP_Navi = "APP_Radio"
			end
			imgui.PopStyleColor()
			imgui.PopStyleColor()
			--imgui.SameLine()
		imgui.Separator()
	
	-- Tab Content
		
		-- Clearence Tab
			if APP_Navi == "Clearence" then
				InIdent = " "	-- Input Box Identifier Label
				imgui.Columns(2,"Appr",false)
				imgui.SetColumnWidth(0, firstColumn_width)
				imgui.SetColumnWidth(1, win_width - firstColumn_width-16)
			
				-- ATIS
					-- Information Identifier	
					imgui.SetColumnWidth(1, 40)
					imgui.TextUnformatted("ATIS Information:")
					imgui.NextColumn()
						local changed, new_ATIS_Info = imgui.InputText(InIdent, ATIS_Info, 2)
						if changed then
							ATIS_Info = new_ATIS_Info
						end
							InIdent = InIdent .. " "
					imgui.NextColumn()
				
					-- QNH
						imgui.SetColumnWidth(1, 150)
						imgui.TextUnformatted("QNH:")
						imgui.NextColumn()
							if QNH_is_HPa == true then
								local QNH = DM_round(ATIS_QNH_inHg / 0.02952999)
								
								local changed, new_QNH = imgui.InputInt("HPa", QNH, 1)
								if changed then
									ATIS_QNH_inHg = new_QNH * 0.02952999
								end
							else
								local changed, new_QNH = imgui.InputFloat("inHG", ATIS_QNH_inHg, 0.01, 0, "%.2f", 0.1)
								if changed then
									ATIS_QNH_inHg = new_QNH
								end
							end
						
							--[[
							-- QNH Selection HPa/inHG
							if imgui.RadioButton("HPa", QNH_is_HPa == true) then
								QNH_is_HPa = true
							end
							imgui.SameLine()
							if imgui.RadioButton("inHG", QNH_is_HPa == false) then
								QNH_is_HPa = false
							end
							]]--
						
						imgui.NextColumn()
					imgui.Separator()
								
				-- Arrival
					imgui.SetColumnWidth(1, 100)
					imgui.TextUnformatted("Arrival:")
					imgui.NextColumn()
					
					-- Sid Waypoint
					local changed, new_APP_Arrival_WPT = imgui.InputText("(Waypoint)", APP_Arrival_WPT, 15)
					if changed then
						APP_Arrival_WPT = new_APP_Arrival_WPT
					end
						InIdent = InIdent .. " "
					-- SID Identifier
					local changed, new_APP_Arrival_Ident = imgui.InputText("(Ident)", APP_Arrival_Ident, 15)
					if changed then
						APP_Arrival_Ident = new_APP_Arrival_Ident
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
				
				imgui.Separator()
				
				-- Transition
					imgui.SetColumnWidth(1, 100)
					imgui.TextUnformatted("Transition:")
					imgui.NextColumn()
					
					-- Transition Waypoint
					local changed, new_APP_Transition_WPT = imgui.InputText("(Waypoint) ", APP_Transition_WPT, 15)
					if changed then
						APP_Transition_WPT = new_APP_Transition_WPT
					end
						InIdent = InIdent .. " "
					-- Transition Identifier
					local changed, new_APP_Transition_Ident = imgui.InputText("(Ident) ", APP_Transition_Ident, 15)
					if changed then
						APP_Transition_Ident = new_APP_Transition_Ident
					end
						InIdent = InIdent .. " "
					-- Runway
					local changed, new_APP_RWY = imgui.InputText("(RWY)", APP_RWY, 15)
					if changed then
						APP_RWY = new_APP_RWY
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
			
			
				-- Remarks if there are extra informations at delivery
					imgui.Separator()
					imgui.SetColumnWidth(1, win_width - firstColumn_width-16)
					imgui.TextUnformatted("Remarks:")
					imgui.NextColumn()
					
					local changed, new_APP_Remarks1 = imgui.InputText(InIdent, APP_Remarks1, 50)
					if changed then
						APP_Remarks1 = new_APP_Remarks1
					end
						InIdent = InIdent .. " "
					imgui.NextColumn()
					imgui.Separator()
			
					-- Next Stations Available
						imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
						imgui.TextUnformatted("Stations:")
						imgui.PopStyleColor()
						imgui.NextColumn()
						imgui.TextUnformatted("")
						imgui.NextColumn()
						
							for i = 1, #Radio_COM_Station_List_Name do
								imgui.TextUnformatted(Radio_COM_Station_List_Name[i] .. ":")
								imgui.NextColumn()
								imgui.TextUnformatted(tostring(Radio_COM_Station_List_Frq[i]))
								imgui.NextColumn()
							end
			
				-- Spacer
					imgui.SetColumnWidth(1, 300)
					imgui.TextUnformatted(" ")
					imgui.NextColumn()
					imgui.TextUnformatted(" ")
					imgui.NextColumn()
			
		-- Approach Configuration Tab
			elseif APP_Navi == "APP_Config" then
				InIdent = " "	-- Input Box Identifier Label
				imgui.Columns(2,"Appr",false)
				imgui.SetColumnWidth(0, firstColumn_width)
				imgui.SetColumnWidth(1, win_width - firstColumn_width-16)
			
				-- Descent Briefing
					imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Briefing)
					imgui.TextUnformatted("Descent Briefing:")
					imgui.PopStyleColor()
					imgui.NextColumn()
					imgui.TextUnformatted("")
					imgui.NextColumn()
			
					-- Landing Altitude (Airport Elevation)
						imgui.SetColumnWidth(1, 150)
						imgui.TextUnformatted("Airport Elevation:")
						imgui.NextColumn()
						
						local changed, new_DREF_APP_Apt_Elev = imgui.InputInt(InIdent, DREF_APP_Apt_Elev, 10)
						if changed then
							DREF_APP_Apt_Elev = new_DREF_APP_Apt_Elev
						end
							InIdent = InIdent .. " "
						imgui.NextColumn()
			
					-- Descent Briefing Confirmation
						imgui.Separator()
						imgui.SetColumnWidth(1, 180)
						imgui.TextUnformatted("Briefing Confirmed:")
						imgui.NextColumn()
						
						if DREF_APP_Briefing_Desc_Confirmed == 0 then
							local check1 = false
						else
							local check1 = true
						end
						
						local changed, newcheck1 = imgui.Checkbox(InIdent, check1)
						if changed then
							check1 = newcheck1
						end
							if check1 == true then
								DREF_APP_Briefing_Desc_Confirmed = 1
							else
								DREF_APP_Briefing_Desc_Confirmed = 0
							end

							InIdent = InIdent .. " "
							
						
						imgui.NextColumn()
					imgui.Separator()
			
			
					-- Approach
					imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Briefing)
					imgui.TextUnformatted("Approach Briefing:")
					imgui.PopStyleColor()
					imgui.NextColumn()
					imgui.TextUnformatted("")
					imgui.NextColumn()
					
					--[[				
					-- Runway
						imgui.SetColumnWidth(1, 130)
						imgui.TextUnformatted("Runway:")
						imgui.NextColumn()
						if APP_RWY == "" then
							imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Alert)
							imgui.TextUnformatted("Not determined!")
							imgui.PopStyleColor()
						else
							imgui.TextUnformatted(APP_RWY)
						end
						imgui.NextColumn()
					
					-- Runway Track (CRS)
						imgui.SetColumnWidth(1, 130)
						imgui.TextUnformatted("Runway Track:")
						imgui.NextColumn()
						
						local changed, new_APP_RWY_Track = imgui.InputInt(InIdent, APP_RWY_Track, 1)
						if changed then
							APP_RWY_Track = new_APP_RWY_Track
							APP_GA_HDG = APP_RWY_Track	-- Go Arround Heading will be set when change RWY Track
							APP_ILS_CRS = APP_RWY_Track	-- ILS CRS will be set when change RWY Track
						end
							InIdent = InIdent .. " "
						-- Correct Heading	
							if APP_RWY_Track > 360 then
								APP_RWY_Track = 1
							elseif APP_RWY_Track < 1 then
								APP_RWY_Track = 360
							end
						
						imgui.NextColumn()
					imgui.Separator()
					]]--
					-- Flaps Setting by Aircraft
						imgui.SetColumnWidth(1, 100-5)
						imgui.TextUnformatted("Landing Flaps:")
						imgui.NextColumn()
									
						-- Select Flap Setting
							if imgui.BeginCombo(InIdent, APP_Flaps_actList[APP_Flaps_conf]) then
								for i = 1, #APP_Flaps_actList do
									if imgui.Selectable(APP_Flaps_actList[i], APP_Flaps_conf == i) then
										APP_Flaps_conf = i
									end
								end
								imgui.EndCombo()
							end
								InIdent = InIdent .. " "
							APP_Flaps_str = APP_Flaps_actList[APP_Flaps_conf]
							APP_Flaps = tonumber(APP_Flaps_str)
								
						imgui.NextColumn()
					
					
					-- Vref
						imgui.SetColumnWidth(1, 130)
						imgui.TextUnformatted("Vref Landing ref. Speed:")
						imgui.NextColumn()
						
						local changed, new_APP_Vref = imgui.InputInt(InIdent, APP_Vref, 1)
						if changed then
							APP_Vref = new_APP_Vref
							DREF_APP_Min_Speed = APP_Vref + 5 
						end
							InIdent = InIdent .. " "
						imgui.NextColumn()
				
					-- Vappr
						imgui.SetColumnWidth(1, 130)
						imgui.TextUnformatted("Vat Approach Speed:")
						imgui.NextColumn()
						
						local changed, new_DREF_APP_Min_Speed = imgui.InputInt(InIdent, DREF_APP_Min_Speed, 1)
						if changed then
							DREF_APP_Min_Speed = new_DREF_APP_Min_Speed
						end
							InIdent = InIdent .. " "
						imgui.NextColumn()

			
					-- Autobrake Setting by Aircraft
						imgui.SetColumnWidth(1, 100-5)
						imgui.TextUnformatted("Autobrakes:")
						imgui.NextColumn()
					
						-- Select Flap Setting
							if imgui.BeginCombo(InIdent, APP_AutoBrake_actList[DREF_APP_AutoBrakes]) then
								for i = 1, #APP_AutoBrake_actList do
									if imgui.Selectable(APP_AutoBrake_actList[i], DREF_APP_AutoBrakes == i) then
										DREF_APP_AutoBrakes = i
									end
								end
								imgui.EndCombo()
							end
								InIdent = InIdent .. " "
							APP_AutoBrake_str = APP_AutoBrake_actList[DREF_APP_AutoBrakes]
							APP_AutoBrake_val = APP_AutoBrake_actValList[DREF_APP_AutoBrakes]
							
						imgui.NextColumn()
					
					
					
					-- Approach Procedure
						imgui.SetColumnWidth(1, 150)
						imgui.TextUnformatted("Approach Procedure:")
						imgui.NextColumn()
					
							if imgui.BeginCombo(InIdent, APP_AppType_List[APP_AppType_ID]) then
								for i = 1, #APP_AppType_List do
									if imgui.Selectable(APP_AppType_List[i], APP_AppType_ID == i) then
										APP_AppType_ID = i
									end
								end
								imgui.EndCombo()
							end
								InIdent = InIdent .. " "
							APP_AppType = APP_AppType_List[APP_AppType_ID]
						
						imgui.NextColumn()
					
						-- Depending on Approach Procedure
							if APP_AppType == "ILS" then
								imgui.TextUnformatted("Approach Course (CRS):")
								imgui.NextColumn()
								
								local changed, new_APP_ILS_CRS = imgui.InputInt(InIdent, APP_ILS_CRS, 1)
								if changed then
									APP_ILS_CRS = new_APP_ILS_CRS
								end
									InIdent = InIdent .. " "
								-- Correct Heading	
									if APP_ILS_CRS > 360 then
										APP_ILS_CRS = 1
									elseif APP_ILS_CRS < 1 then
										APP_ILS_CRS = 360
									end
								imgui.NextColumn()
								
								imgui.TextUnformatted("ILS Frequency:")
								imgui.NextColumn()
								
								local changed, new_APP_ILS_Frq = imgui.InputFloat("MHz", APP_ILS_Frq, 0.05, 0, "%.2f", 0.1)
								if changed then
									APP_ILS_Frq = corr_NAV(new_APP_ILS_Frq)
								end
								imgui.NextColumn()
								--[[
								imgui.SetColumnWidth(1, 400)
								imgui.TextUnformatted("")
								imgui.NextColumn()
									if imgui.Button("Set NAV1 Active",130 ,20) then
										APP_ILS_set_act1 = true
									end
									imgui.SameLine()
									if imgui.Button("Set NAV1 Standby",130 ,20) then
										APP_ILS_set_stby1 = true
									end
									if imgui.Button("Set NAV2 Active",130 ,20) then
										APP_ILS_set_act2 = true
									end
									imgui.SameLine()
									if imgui.Button("Set NAV2 Standby",130 ,20) then
										APP_ILS_set_stby2 = true
									end
									
								imgui.NextColumn()	
								]]
							elseif APP_AppType == "VOR" then
								imgui.TextUnformatted("Approach Course (CRS):")
								imgui.NextColumn()
								
								local changed, new_APP_ILS_CRS = imgui.InputInt(InIdent, APP_ILS_CRS, 1)
								if changed then
									APP_ILS_CRS = new_APP_ILS_CRS
								end
									InIdent = InIdent .. " "
								-- Correct Heading	
									if APP_ILS_CRS > 360 then
										APP_ILS_CRS = 1
									elseif APP_ILS_CRS < 1 then
										APP_ILS_CRS = 360
									end
								imgui.NextColumn()
								
								imgui.TextUnformatted("VOR Frequency:")
								imgui.NextColumn()
								
								local changed, new_APP_ILS_Frq = imgui.InputFloat("MHz", APP_ILS_Frq, 0.05, 0, "%.2f", 0.1)
								if changed then
									APP_ILS_Frq = corr_NAV(new_APP_ILS_Frq)
								end
								imgui.NextColumn()
							end
						

					
					-- Minimums
						
						-- ICAO Approach Category
							local APP_ICAO_Cat = ""			
							if DREF_APP_Min_Speed < 91 then
								APP_ICAO_Cat = "A"
							elseif DREF_APP_Min_Speed < 120 then
								APP_ICAO_Cat = "B"
							elseif DREF_APP_Min_Speed < 140 then
								APP_ICAO_Cat = "C"
							else
								APP_ICAO_Cat = "D"
							end
						
						imgui.SetColumnWidth(1, 150)
						imgui.TextUnformatted("Minimums: Category [" .. APP_ICAO_Cat .. "]")
						imgui.NextColumn()
						
						local changed, new_DREF_APP_Minimums = imgui.InputInt(InIdent, DREF_APP_Minimums, 1)
						if changed then
							DREF_APP_Minimums = new_DREF_APP_Minimums
						end
							InIdent = InIdent .. " "
						imgui.NextColumn()
						
						-- RADIO / BARO
						imgui.SetColumnWidth(1, 400)
						imgui.TextUnformatted(" ")
						imgui.NextColumn()
						if imgui.RadioButton("Radio", APP_Min_Radio == true) then
							APP_Min_Radio = true
						end
						imgui.SameLine()
						if imgui.RadioButton("Baro", APP_Min_Radio == false) then
							APP_Min_Radio = false
						end
						imgui.NextColumn()
				
					
				
					
				
				-- Go Arround Config
					imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
					imgui.TextUnformatted("Go Arround Procedure:")
					imgui.PopStyleColor()
					imgui.NextColumn()
					imgui.TextUnformatted("")
					imgui.NextColumn()
				
					-- Initial Heading
						imgui.SetColumnWidth(1, 130)
						imgui.TextUnformatted("Go Arround Heading:")
						imgui.NextColumn()
						
						local changed, new_APP_GA_HDG = imgui.InputInt(InIdent, APP_GA_HDG, 1)
						if changed then
							APP_GA_HDG = new_APP_GA_HDG
						end
							InIdent = InIdent .. " "
						-- Correct Heading	
							if APP_GA_HDG > 360 then
								APP_GA_HDG = 1
							elseif APP_GA_HDG < 1 then
								APP_GA_HDG = 360
							end
						
						imgui.NextColumn()
						
					-- Go Arround Altitude
						imgui.SetColumnWidth(1, 150)
						imgui.TextUnformatted("Go Arround Altitude:")
						imgui.NextColumn()
						
						local changed, new_DREF_GA_Alt = imgui.InputInt(InIdent, DREF_GA_Alt, 1000)
						if changed then
							DREF_GA_Alt = new_DREF_GA_Alt
						end
							InIdent = InIdent .. " "
						imgui.NextColumn()
					
						-- Approach Briefing Confirmation
						
						imgui.Separator()
						imgui.SetColumnWidth(1, 180)
						imgui.TextUnformatted("Briefing Confirmed:")
						imgui.NextColumn()
					
					
						if DREF_APP_Briefing_App_Confirmed == 0 then
							local check2 = false
						else
							local check2 = true
						end
						
						local changed, newcheck2 = imgui.Checkbox(InIdent, check2)
						if changed then
							check2 = newcheck2
						end
							if check2 == true then
								DREF_APP_Briefing_App_Confirmed = 1
							else
								DREF_APP_Briefing_App_Confirmed = 0
							end

							InIdent = InIdent .. " "
						imgui.NextColumn()
					
					
					
					imgui.Separator()
				
				
					imgui.SetColumnWidth(1, 400)
					-- Request V Speeds, Trim and Flaps from Airplane from myLuaCopilot 
						imgui.PushStyleColor(imgui.constant.Col.Text, 0xFF21FF00)
						imgui.TextUnformatted(myLuaCopilot_avail_Acf)
						imgui.PopStyleColor()
						
						imgui.NextColumn()
						if myLuaCopilot_avail_Acf == "Boeing 727 (FJS)" then
							if imgui.Button("Request Data") then
							-- V-Speeds
								APP_Vref = Speed_Vref
								DREF_APP_Min_Speed = APP_Vref + 5
														
							-- Select Flaps Setting from List
								for i = 1, #APP_Flaps_actList do
									if APP_Flaps_actList[i] == tostring(math.floor(Flaps_Approach)) then
										APP_Flaps_conf = i
									end
								end
							end
						end
						
						if myLuaCopilot_avail_Acf == "Boeing 737-600 (LU)" then
							if imgui.Button("Request Data") then
							-- V-Speeds
								APP_Vref = Speed_Vref
								DREF_APP_Min_Speed = APP_Vref + 5
														
							-- Select Flaps Setting from List
								for i = 1, #APP_Flaps_actList do
									if APP_Flaps_actList[i] == tostring(math.floor(Flaps_Approach)) then
										APP_Flaps_conf = i
									end
								end
							end
						end

						if myLuaCopilot_avail_Acf == "Boeing 737-700 (LU)" then
							if imgui.Button("Request Data") then
							-- V-Speeds
								APP_Vref = Speed_Vref
								DREF_APP_Min_Speed = APP_Vref + 5
														
							-- Select Flaps Setting from List
								for i = 1, #APP_Flaps_actList do
									if APP_Flaps_actList[i] == tostring(math.floor(Flaps_Approach)) then
										APP_Flaps_conf = i
									end
								end
							end
						end

						if myLuaCopilot_avail_Acf == "Boeing 737-800 (Zibo/LU)" then
							if imgui.Button("Request Data") then
							-- V-Speeds
								APP_Vref = Speed_Vref
								DREF_APP_Min_Speed = APP_Vref + 5
														
							-- Select Flaps Setting from List
								for i = 1, #APP_Flaps_actList do
									if APP_Flaps_actList[i] == tostring(math.floor(Flaps_Approach)) then
										APP_Flaps_conf = i
									end
								end
							end
						end

						if myLuaCopilot_avail_Acf == "Boeing 737-900 (LU)" then
							if imgui.Button("Request Data") then
							-- V-Speeds
								APP_Vref = Speed_Vref
								DREF_APP_Min_Speed = APP_Vref + 5
														
							-- Select Flaps Setting from List
								for i = 1, #APP_Flaps_actList do
									if APP_Flaps_actList[i] == tostring(math.floor(Flaps_Approach)) then
										APP_Flaps_conf = i
									end
								end
							end
						end
				
						if myLuaCopilot_avail_Acf == "Boeing 767 (FlightFactor)" then
							if imgui.Button("Request Data") then
							-- V-Speeds
								APP_Vref = Speed_Vref
								DREF_APP_Min_Speed = APP_Vref + 5
														
							-- Select Flaps Setting from List
								for i = 1, #APP_Flaps_actList do
									if APP_Flaps_actList[i] == tostring(math.floor(Flaps_Approach)) then
										APP_Flaps_conf = i
									end
								end
							end
						end
			
		-- Radio Stations 
			elseif APP_Navi == "APP_Radio" then
				InIdent = " "	-- Input Box Identifier Label
				imgui.Columns(2,"Appr",false)
				imgui.SetColumnWidth(0, firstColumn_width)
				imgui.SetColumnWidth(1, win_width - firstColumn_width-16)
				
				-- COM Radios
				imgui.PushStyleColor(imgui.constant.Col.Text, STYLE_Headline)
				imgui.TextUnformatted("COM Stations")	
				imgui.PopStyleColor()
				imgui.NextColumn()
				imgui.TextUnformatted("")	
				imgui.NextColumn()
				
				
				-- Approach Station		
					-- Select if Station is Active
					local changed, new_APP_COM1_App_use = imgui.Checkbox("Approach:", APP_COM1_App_use)
					if changed then
						APP_COM1_App_use = new_APP_COM1_App_use
					end
					imgui.NextColumn()
					
					-- Name of the Station
					local changed, new_APP_COM1_App_lbl = imgui.InputText(InIdent, APP_COM1_App_lbl, 30)
					if changed then
						APP_COM1_App_lbl = new_APP_COM1_App_lbl
					end
						InIdent = InIdent .. " "
					-- Frequency of the Station	
					local changed, new_APP_COM1_App_frq = imgui.InputFloat("MHz   ", APP_COM1_App_frq, 0.025, 0, "%.3f", 0.1)
					if changed then
						APP_COM1_App_frq = corr_COM(new_APP_COM1_App_frq)
					end
					imgui.NextColumn()
				--imgui.Separator()
				
				
				-- Director Station		
					-- Select if Station is Active
					local changed, new_APP_COM1_Dir_use = imgui.Checkbox("Director:", APP_COM1_Dir_use)
					if changed then
						APP_COM1_Dir_use = new_APP_COM1_Dir_use
					end
					imgui.NextColumn()
					
					-- Name of the Station
					local changed, new_APP_COM1_Dir_lbl = imgui.InputText(InIdent, APP_COM1_Dir_lbl, 30)
					if changed then
						APP_COM1_Dir_lbl = new_APP_COM1_Dir_lbl
					end
						InIdent = InIdent .. " "
					-- Frequency of the Station	
					local changed, new_APP_COM1_Dir_frq = imgui.InputFloat("MHz  ", APP_COM1_Dir_frq, 0.025, 0, "%.3f", 0.1)
					if changed then
						APP_COM1_Dir_frq = corr_COM(new_APP_COM1_Dir_frq)
					end
					imgui.NextColumn()
				--imgui.Separator()
				
				
				-- Tower Station		
					-- Select if Station is Active
					local changed, new_APP_COM1_Twr_use = imgui.Checkbox("Tower:", APP_COM1_Twr_use)
					if changed then
						APP_COM1_Twr_use = new_APP_COM1_Twr_use
					end
					imgui.NextColumn()
					
					-- Name of the Station
					local changed, new_APP_COM1_Twr_lbl = imgui.InputText(InIdent, APP_COM1_Twr_lbl, 30)
					if changed then
						APP_COM1_Twr_lbl = new_APP_COM1_Twr_lbl
					end
						InIdent = InIdent .. " "
					-- Frequency of the Station	
					local changed, new_APP_COM1_Twr_frq = imgui.InputFloat("MHz ", APP_COM1_Twr_frq, 0.025, 0, "%.3f", 0.1)
					if changed then
						APP_COM1_Twr_frq = corr_COM(new_APP_COM1_Twr_frq)
					end
					imgui.NextColumn()
				--imgui.Separator()
				
				-- Ground Station		
					-- Select if Station is Active
					local changed, new_APP_COM1_Gnd_use = imgui.Checkbox("Ground:", APP_COM1_Gnd_use)
					if changed then
						APP_COM1_Gnd_use = new_APP_COM1_Gnd_use
					end
					imgui.NextColumn()
					
					-- Name of the Station
					local changed, new_APP_COM1_Gnd_lbl = imgui.InputText(InIdent, APP_COM1_Gnd_lbl, 30)
					if changed then
						APP_COM1_Gnd_lbl = new_APP_COM1_Gnd_lbl
					end
						InIdent = InIdent .. " "
					-- Frequency of the Station	
					local changed, new_APP_COM1_Gnd_frq = imgui.InputFloat("MHz", APP_COM1_Gnd_frq, 0.025, 0, "%.3f", 0.1)
					if changed then
						APP_COM1_Gnd_frq = corr_COM(new_APP_COM1_Gnd_frq)
					end
					imgui.NextColumn()
				--imgui.Separator()
			
			end
	
	--imgui.SetWindowSize(win_width, win_height_floating)
		
end
function WIN_AppBriefing_close(WIN_AppBriefing)
	WIN_AppBriefing_show = false
	WIN_AppBriefing_active = false
	open_myBriefingMenu()
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Window Creation
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Briefing Windows will be created here
function func_create_windows()

	-- General Flight Information
	if WIN_FlightInfo_show == true and WIN_FlightInfo_active == false then
		WIN_FlightInfo_show = false
		WIN_FlightInfo_active = true

		WIN_FlightInfo = float_wnd_create(400, 255, 1, true)		-- create window
		float_wnd_set_title(WIN_FlightInfo, "Flight Information") -- window name
		float_wnd_set_position(WIN_FlightInfo, 10 , 150 )	-- window init position
		float_wnd_set_imgui_builder(WIN_FlightInfo, "WIN_FlightInfo_draw")
		float_wnd_set_onclose(WIN_FlightInfo, "WIN_FlightInfo_close")
	end
	
	-- ATIS / AWOS
	if WIN_ATIS_show == true and WIN_ATIS_active == false then
		WIN_ATIS_show = false
		WIN_ATIS_active = true

		WIN_ATIS = float_wnd_create(400, 195, 1, true)		-- create window
		float_wnd_set_title(WIN_ATIS, "ATIS/AWOS") -- window name
		float_wnd_set_position(WIN_ATIS, 10 , 150 )	-- window init position
		float_wnd_set_imgui_builder(WIN_ATIS, "WIN_ATIS_draw")
		float_wnd_set_onclose(WIN_ATIS, "WIN_ATIS_close")
	end
	
	-- Departure Briefing
	if WIN_DepBriefing_show == true and WIN_DepBriefing_active == false then
		WIN_DepBriefing_show = false
		WIN_DepBriefing_active = true

		WIN_DepBriefing = float_wnd_create(500, 520, 1, true)		-- create window
		float_wnd_set_title(WIN_DepBriefing, "Departure Briefing") -- window name
		float_wnd_set_position(WIN_DepBriefing, 10 , 150 )	-- window init position
		float_wnd_set_imgui_builder(WIN_DepBriefing, "WIN_DepBriefing_draw")
		float_wnd_set_onclose(WIN_DepBriefing, "WIN_DepBriefing_close")
	end

	-- Approach Briefing
	if WIN_AppBriefing_show == true and WIN_AppBriefing_active == false then
		WIN_AppBriefing_show = false
		WIN_AppBriefing_active = true

		WIN_AppBriefing = float_wnd_create(500, 420, 1, true)		-- create window
		float_wnd_set_title(WIN_AppBriefing, "Approach Briefing") -- window name
		float_wnd_set_position(WIN_AppBriefing, 10 , 150 )	-- window init position
		float_wnd_set_imgui_builder(WIN_AppBriefing, "WIN_AppBriefing_draw")
		float_wnd_set_onclose(WIN_AppBriefing, "WIN_AppBriefing_close")
	end

end

-- Briefing Menu
function WIN_BriefingMenu_draw(WIN_BriefingMenu, x, y)

	-- Gui position parameter
	local win_width = imgui.GetWindowWidth()
    local win_height = imgui.GetWindowHeight()
	
	
	imgui.SetWindowFontScale(1)
	-- Flight Information
	if imgui.Button("Flight Info",WIN_BriefingMenu_width - 16 ,32) then
		float_wnd_destroy(WIN_BriefingMenu)
		WIN_FlightInfo_show = true
		WIN_BriefingMenu_show = false
	end
	
	-- ATIS / AWOS
	if imgui.Button("ATIS / AWOS",WIN_BriefingMenu_width - 16 ,32) then
		float_wnd_destroy(WIN_BriefingMenu)
		WIN_ATIS_show = true
		WIN_BriefingMenu_show = false
	end
	
	
	-- Departure Briefing
	if imgui.Button("Departure",WIN_BriefingMenu_width - 16 ,32) then
		float_wnd_destroy(WIN_BriefingMenu)
		WIN_DepBriefing_show = true
		WIN_BriefingMenu_show = false
	end
	
	-- Approach Briefing
	if imgui.Button("Approach",WIN_BriefingMenu_width - 16 ,32) then
		float_wnd_destroy(WIN_BriefingMenu)
		WIN_AppBriefing_show = true
		WIN_BriefingMenu_show = false
	end
	imgui.Separator()
	
	-- Procedure Selection Box
	if PROC_List ~= nil and PROC_next ~= 0 then
		imgui.TextUnformatted("First Officer")
		imgui.NextColumn()
		if imgui.Button("Start Procedure",WIN_BriefingMenu_width - 16 ,32) then
			command_once("DanielLOWG/Copilot/Proc/start_next_procedure")
			float_wnd_destroy(WIN_BriefingMenu)
		end
		imgui.NextColumn()
		imgui.PushItemWidth(WIN_BriefingMenu_width - 16)
		if imgui.BeginCombo(" ", PROC_List[PROC_next]) then
			for i = 1, #PROC_List do
                if imgui.Selectable(PROC_List[i], PROC_next == i) then
                    XFO_next_Procedure = i			
                end
            end
            imgui.EndCombo()
        end
		
	end
end

-- Open Briefing Menu
function open_myBriefingMenu()
	
	WIN_BriefingMenu_show = not(WIN_BriefingMenu_show)
	
	if WIN_BriefingMenu_show == true then
		WIN_BriefingMenu = float_wnd_create(WIN_BriefingMenu_width, 240, 1, true)		-- create window
		float_wnd_set_title(WIN_BriefingMenu, "Briefing Menu") -- window name
		float_wnd_set_position(WIN_BriefingMenu, 10 , 150 )	-- window init position
		float_wnd_set_imgui_builder(WIN_BriefingMenu, "WIN_BriefingMenu_draw")
	else
		float_wnd_destroy(WIN_BriefingMenu)
	end


end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Some Special Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Copilot will turning Knobs
function CoPilot_Knobs()
	
	local COM1_MHz_Standby_dev = 0
	local COM1_kHz_Standby_dev = 0
		local MHz = 0
		local kHz = 0

	-- Set COM1 Standby
		-- Split MHz and kHz
		MHz = math.floor(Radio_COM_Station_act_Frq)
		kHz = round((Radio_COM_Station_act_Frq - MHz) * 1000)
		
		-- Set MHz
		if set_COM1_MHz_Standby == true then
			COM1_MHz_Standby_dev = DREF_COM1_MHz - MHz
			if COM1_MHz_Standby_dev == 0 then
				set_COM1_MHz_Standby = false
				set_COM1_kHz_Standby = true -- when MHz tuning is finished --> start with kHz tuning
			else
				command_once("sim/radios/stby_com1_coarse_up")
			end
		end
	
		-- Set kHz
		if set_COM1_kHz_Standby == true then
			COM1_kHz_Standby_dev = DREF_COM1_kHz - kHz
			if COM1_kHz_Standby_dev == 0 then
				set_COM1_kHz_Standby = false
				XPLMSpeakString(Radio_COM_Station_act_Name .. " Set Standby 1")
			elseif COM1_kHz_Standby_dev <= -500 then
				command_once("sim/radios/stby_com1_fine_down")
			elseif COM1_kHz_Standby_dev > -500 and COM1_kHz_Standby_dev < 0 then
				command_once("sim/radios/stby_com1_fine_up")
			elseif COM1_kHz_Standby_dev > 0 and COM1_kHz_Standby_dev <= 500 then
				command_once("sim/radios/stby_com1_fine_down")
			elseif COM1_kHz_Standby_dev > 500 then
				command_once("sim/radios/stby_com1_fine_up")
			end
		end


	
	-- Radio Stations Selection also possible with Joystick Buttons 
		local Radio_Station_showTimer = 1000
		
		-- Next Station
		if DM_cmd_COM_next == true then
			-- Increment to List Size Maximum
			if Radio_COM_Station_ID < #Radio_COM_Station_List_Name then
				Radio_COM_Station_ID = Radio_COM_Station_ID + 1
			end
			Radio_COM_Station_act_Name = Radio_COM_Station_List_Name[Radio_COM_Station_ID]
			Radio_COM_Station_act_Frq = Radio_COM_Station_List_Frq[Radio_COM_Station_ID]
			--XPLMSpeakString("Select " .. Radio_COM_Station_act_Name )
			Radio_COM_Station_show_Timer = Radio_Station_showTimer
			DM_cmd_COM_next = false
		end
		-- Last Station
		if DM_cmd_COM_last == true then
			-- Decrement to 1 Minimum
			if Radio_COM_Station_ID > 1 then
				Radio_COM_Station_ID = Radio_COM_Station_ID - 1
			end
			Radio_COM_Station_act_Name = Radio_COM_Station_List_Name[Radio_COM_Station_ID]
			Radio_COM_Station_act_Frq = Radio_COM_Station_List_Frq[Radio_COM_Station_ID]
			--XPLMSpeakString("Select " .. Radio_COM_Station_act_Name )
			Radio_COM_Station_show_Timer = Radio_Station_showTimer
			DM_cmd_COM_last = false
		end
		-- Tune Station to COM1
		if DM_cmd_COM1_set == true then
			set_COM1_MHz_Standby = true
			DM_cmd_COM1_set = false
		end
	
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- List of COM Radio Stations will be writen by Briefing Data if they are checked ON
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
function write_COM_RadioList()

	local i = 1
	
	Radio_COM_Station_List_Name = {"Unicom"}
	Radio_COM_Station_List_Frq = {122.8}
	
	-- Departure Ground
	if DEP_COM1_Gnd_use == true then
		Radio_COM_Station_List_Name[i] = DEP_COM1_Gnd_lbl
		Radio_COM_Station_List_Frq[i] = round(DEP_COM1_Gnd_frq * 10^3) * 10^-3
		i = i + 1
	end	
	-- Departure Tower
	if DEP_COM1_Twr_use == true then
		Radio_COM_Station_List_Name[i] = DEP_COM1_Twr_lbl
		Radio_COM_Station_List_Frq[i] = round(DEP_COM1_Twr_frq * 10^3) * 10^-3
		i = i + 1
	end	
	-- Departure 
	if DEP_COM1_Dep_use == true then
		Radio_COM_Station_List_Name[i] = DEP_COM1_Dep_lbl
		Radio_COM_Station_List_Frq[i] = round(DEP_COM1_Dep_frq * 10^3) * 10^-3
		i = i + 1
	end	
	-- Center 
	if DEP_COM1_Ctr_use == true then
		Radio_COM_Station_List_Name[i] = DEP_COM1_Ctr_lbl
		Radio_COM_Station_List_Frq[i] = round(DEP_COM1_Ctr_frq * 10^3) * 10^-3
		i = i + 1
	end	
	-- Approach 
	if APP_COM1_App_use == true then
		Radio_COM_Station_List_Name[i] = APP_COM1_App_lbl
		Radio_COM_Station_List_Frq[i] = round(APP_COM1_App_frq * 10^3) * 10^-3
		i = i + 1
	end	
	-- Director
	if APP_COM1_Dir_use == true then
		Radio_COM_Station_List_Name[i] = APP_COM1_Dir_lbl
		Radio_COM_Station_List_Frq[i] = round(APP_COM1_Dir_frq * 10^3) * 10^-3
		i = i + 1
	end	
	-- Approach Tower
	if APP_COM1_Twr_use == true then
		Radio_COM_Station_List_Name[i] = APP_COM1_Twr_lbl
		Radio_COM_Station_List_Frq[i] = round(APP_COM1_Twr_frq * 10^3) * 10^-3
		i = i + 1
	end
	-- Approach Ground
	if APP_COM1_Gnd_use == true then
		Radio_COM_Station_List_Name[i] = APP_COM1_Gnd_lbl
		Radio_COM_Station_List_Frq[i] = round(APP_COM1_Gnd_frq * 10^3) * 10^-3
		i = i + 1
	end

	if Radio_COM_Station_ID > #Radio_COM_Station_List_Name then
		Radio_COM_Station_ID = 1
	end

	Radio_COM_Station_act_Name = Radio_COM_Station_List_Name[Radio_COM_Station_ID]
	Radio_COM_Station_act_Frq = Radio_COM_Station_List_Frq[Radio_COM_Station_ID]
	
	
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Correction of COM and NAV Frequencies and Squawk Code
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function corr_COM(frq)
		
	local MHz = math.floor(frq)
	local kHz = math.floor((frq-MHz)*1000)
	
	-- MHz Range
	if MHz < 118 then 
		MHz = 136.000
	elseif MHz > 136 then
		MHz = 118.000
	end
	
	-- KHz Range 25kHz
	if kHz > 975 then
		kHz = 0
	else
		kHz = DM_round(kHz/25) * 25
	end
	
	local val = MHz + kHz/1000
	
	return val
end

function corr_NAV(frq)
	
	if frq < 108.00 then 
		val = 117.95
	elseif frq > 117.99 then
		val = 108.00
	else
		val = frq
	end
	
	return val
end

function corr_squawk(code_txt)

	local str = "1200"

	if tonumber(code_txt) ~= nil then
		local code = tonumber(code_txt)

		if code == 7500 then
			code = 1200
		end

		local code_1
		local code_10
		local code_100
		local code_1000
		
		code_1000 = math.floor( code / 1000 )
		code_100 = math.floor( (code - code_1000*1000) / 100 )
		code_10 = math.floor( (code - code_1000*1000 - code_100*100) / 10 )
		code_1 = code - code_1000*1000 - code_100*100 - code_10*10
		
		if code_1000 > 7 then
			code_1000 = 1
		end
		if code_100 > 7 then
			code_100 = 1
		end
		if code_10 > 7 then
			code_10 = 0
		end
		if code_1 > 7 then
			code_1 = 0
		end
		
		return tostring(code_1000) .. tostring(code_100) .. tostring(code_10) .. tostring(code_1)
		
	end
	
	return str
end



local function glatterTeiler(n,Teiler)
	return (n5Teiler == 0)
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Keystrokes
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function func_myBriefing_keystroke()

	-- open Briefing Menu
	if DM_cmd_briefing_menu == true then
		open_myBriefingMenu()
	end
end



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Airplane Select Parameters from Lists (Flaps settings, Autobrake settings) by selected Aircraft
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function Airplane_Select()
	
	-- Call Sign Build from Flight Number and Aircraft Category (Heavy and Super)
		if GENERAL_FlightNumber ~= "" then
			GENERAL_Callsign = GENERAL_FlightNumber .. " " .. GENERAL_Acf_Category
		else
			GENERAL_Callsign = ""
		end
	
	
	-- myLuaCopilot Availability Check
		if myLuaCopilot_B727_FJS == nil then
			myLuaCopilot_B727_FJS = false
		end
		if DanielLOWG_ACF_LU_B736 == nil then
			DanielLOWG_ACF_LU_B736 = false
		end
		if DanielLOWG_ACF_LU_B737 == nil then
			DanielLOWG_ACF_LU_B737 = false
		end
		if DanielLOWG_ACF_zibo_B738 == nil then -- includes LU B738
			DanielLOWG_ACF_zibo_B738 = false
		end
		if DanielLOWG_ACF_LU_B739 == nil then
			DanielLOWG_ACF_LU_B739 = false
		end
		if DanielLOWG_ACF_FF_B767 == nil then
			DanielLOWG_ACF_FF_B767 = false
		end
		if DanielLOWG_ACF_Concorde == nil then
			DanielLOWG_ACF_Concorde = false
		end
	
		GENERAL_Acf = GENERAL_Acf_List[GENERAL_Acf_ID]
		GENERAL_Acf_Name = GENERAL_Acf:getName()
		GENERAL_Acf_Category = GENERAL_Acf:getCategory()
		DEP_Flaps_actList = GENERAL_Acf:getDEP_Flaps()
		APP_Flaps_actList = GENERAL_Acf:getAPP_Flaps()
		APP_AutoBrake_actList = GENERAL_Acf:getAutobrake()
		APP_AutoBrake_actValList = GENERAL_Acf:getAutobrake_val()
	
	
	
	-- Check myLuaCopilot is available and active for actual Aircraft --> this makes it possible to receive Data for Preferences given by FMC
		--[[
		if GENERAL_Acf == "Boeing 727" and myLuaCopilot_B727_FJS == true then
			myLuaCopilot_avail_Acf = "Boeing 727 (FJS)"
		end
		]]--
	if GENERAL_Acf_Name == "Boeing 737" and DanielLOWG_ACF_LU_B736 == true then
		myLuaCopilot_avail_Acf = "Boeing 737-600 (LU)"
	end
	if GENERAL_Acf_Name == "Boeing 737" and DanielLOWG_ACF_LU_B737 == true then
		myLuaCopilot_avail_Acf = "Boeing 737-700 (LU)"
	end
	if GENERAL_Acf_Name == "Boeing 737" and DanielLOWG_ACF_zibo_B738 == true then
		myLuaCopilot_avail_Acf = "Boeing 737-800 (Zibo/LU)"
	end
	if GENERAL_Acf_Name == "Boeing 737" and DanielLOWG_ACF_LU_B739 == true then
		myLuaCopilot_avail_Acf = "Boeing 737-900 (LU)"
	end
	if GENERAL_Acf_Name == "Boeing 767" and DanielLOWG_ACF_FF_B767 == true then
		myLuaCopilot_avail_Acf = "Boeing 767 (FlightFactor)"
	end
	

end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Draw anything on the Screen
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DrawSomeInfo()
	local top = 40
	if GENERAL_Callsign_show == true then
		draw_string(10, top, GENERAL_Callsign, "green")
	end
	
	if Radio_COM_Station_show_Timer > 0 then
		draw_string(10, top - 15, "next Station: " .. Radio_COM_Station_act_Name .. " - " .. tostring(Radio_COM_Station_act_Frq), "green")
		Radio_COM_Station_show_Timer = Radio_COM_Station_show_Timer - 1
	end


end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Write DataRef's for XFirstOfficer Communication
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function func_write_DREF()

	
	DREF_ATIS_QNH_inHG = ATIS_QNH_inHg
	DREF_ATIS_Temperature = tonumber(ATIS_Temp)
	DREF_DEP_Flaps = DEP_Flaps_conf
	
	DREF_DEP_v1 = DEP_V1
	DREF_DEP_vr = DEP_VR
	DREF_DEP_v2 = DEP_V2
	
	if QNH_is_HPa == true then
		DREF_ATIS_QNH_is_HPa = 1
	else	
		DREF_ATIS_QNH_is_HPa = 0
	end
		
		
	if DEP_ICE_Wing == true then
		DREF_DEP_AntiIce_Wing = 1
	else
		DREF_DEP_AntiIce_Wing = 0
	end
		
	if DEP_ICE_Eng == true then
		DREF_DEP_AntiIce_Engine = 1
	else
		DREF_DEP_AntiIce_Engine = 0
	end
	
	if APP_Min_Radio == true then
		DREF_APP_Min_is_Baro = 0
	else
		DREF_APP_Min_is_Baro = 1
	end
	
	if DEP_Init_HDG == 360 then
		DREF_DEP_Init_HDG = 0
	else
		DREF_DEP_Init_HDG = DEP_Init_HDG
	end
	
	if APP_GA_HDG == 360 then
		DREF_GA_HDG = 0
	else
		DREF_GA_HDG = APP_GA_HDG
	end
	
	-- Actualize next Procedures
	if XFO_next_Procedure ~= nil then
		PROC_next = XFO_next_Procedure
	else
		PROC_next = 0
	end
	--[[
	if PROC_List == nil then
		PROC_List = {"No Action"}
	end
	]]--
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
-- Initialisation
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if INIT == false then
	newFlight()	-- Init Variable --> also called with "New Flight" Button in Flight Informations Window
	newATIS()	-- Init ATIS Variables --> also called with "New ATIS/AWOS" Button in ATIS/AWOS Window
	Airplane_Select() 
	

		do_every_frame("CoPilot_Knobs()")	-- Copilot do Manipulations with Knob commands till the actual value equals with the setpoint
	
	do_often("write_COM_RadioList()")	-- Building the list of available Radio Stations

	
	do_every_frame("func_create_windows()")	-- Creates all Briefing Windows excepting the Menu
	do_on_keystroke("func_myBriefing_keystroke()")	-- All Keybindings	
	do_often("func_write_DREF()") -- Write DataRef's
	do_every_draw("DrawSomeInfo()")	-- All what is drawn on the screen
	
	-- Flag to remember this initialisation is done
	INIT = true
end


