-- ***********************************************************************************************************************************************************************************
-- My Lua Assistance - Core Functions 
-- ***********************************************************************************************************************************************************************************
-- Author: 		Daniel Mandlez (DanielLOWG former DanielMan @ x-plane.at and x-plane.org)
-- Verion:		1.1	
-- License:		Public Domain

-- Comments:	This are the core functions used for all MyLua Assistance Scripts!!!!! 
--				I use My Lua Assistance in combination with VoiceAttack (VoiceAttack is provided on Steam).
--				Feel free to modify the following code for your use.
--				!!!!! Please keep in mind, that I'm not a software specialist --> doubtless some or even most of the code is weird to specialists ;-)
--				!!!!! There will be no support for the provided code, nor for changes done by your self !!!!!!	
-- ***********************************************************************************************************************************************************************************


-- Acknowledgements
-- ***********************************************************************************************************************************************************************************
-- Great thanks to Carsten Lynker for providing FlywithLua
-- ***********************************************************************************************************************************************************************************
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
-- Classes do not change! --> You can add Aircrafts below the Class definitions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								
Class_ACF = {}
function Class_ACF:Create()

	local this = 
	{
		ICAO = "", 
		Name = "", 
		Models = "",
		Category = "",
		DEP_Flaps = {}, 
		APP_Flaps = {}, 
		AutoBrake = {},
		AutoBrake_val = {}
	}
	
	function this:setICAO(val)
		self.ICAO = val
	end
	
	function this:setName(val)
		self.Name = val
	end
	
	function this:setModels(val)
		self.Models = val
	end
	
	function this:setCategory(val)
		self.Category = val
	end
	
	function this:setDEP_Flaps(list)
		self.DEP_Flaps = list
	end
	
	function this:setAPP_Flaps(list)
		self.APP_Flaps = list
	end
	
	function this:setAutoBrake(list)
		self.AutoBrake = list
	end
	
	function this:setAutoBrake_val(list)
		self.AutoBrake_val = list
	end
	
	
	function this:getICAO()
		return self.ICAO
	end
	
	function this:getName()
		return self.Name
	end
	
	function this:getModels()
		return self.Models
	end
	
	function this:getCategory()
		return self.Category
	end
	
	function this:getDEP_Flaps()
		return self.DEP_Flaps
	end
	
	function this:getAPP_Flaps()
		return self.APP_Flaps
	end
	
	function this:getAutobrake()
		return self.AutoBrake
	end
	
	function this:getAutobrake_val()
		return self.AutoBrake_val
	end
	
	return this
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
-- Here you can add new Aircrafts and add them to the List in DanielLOWG - 03 - myBriefing
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								


-- General Aviation
DA62 = Class_ACF:Create()
DA62:setICAO("DA62")
DA62:setName("Diamond DA62")
DA62:setModels({" "})
DA62:setCategory("")
DA62:setDEP_Flaps({"0","TO"})
DA62:setAPP_Flaps({"0","TO","LDG"})
DA62:setAutoBrake({"NA"})
DA62:setAutoBrake_val({0})


-- Airbus
A320 = Class_ACF:Create()
A320:setICAO("A320")
A320:setName("Airbus A320")
A320:setModels({"200"})
A320:setCategory("")
A320:setDEP_Flaps({"0","1","2","3","FULL"})
A320:setAPP_Flaps({"0","1","2","3","FULL"})
A320:setAutoBrake({"OFF","LO","MED","MAX"})
A320:setAutoBrake_val({0,1,2,3})


-- Boeing 
B737 = Class_ACF:Create()
B737:setICAO("B737")
B737:setName("Boeing 737")
B737:setModels({"100","200","300","400","500","600","700","800","900"})
B737:setCategory("")
B737:setDEP_Flaps({"0","1","5","10","15"})
B737:setAPP_Flaps({"15","30","40"})
B737:setAutoBrake({"OFF","1","2","3","MAX"})
B737:setAutoBrake_val({1,2,3,4,5})


B767 = Class_ACF:Create()
B767:setICAO("B767")
B767:setName("Boeing 767")
B767:setModels({"200ER","300ER","300F"})
B767:setCategory("Heavy")
B767:setDEP_Flaps({"0","1","5","15","20"})
B767:setAPP_Flaps({"25","30"})
B767:setAutoBrake({"OFF","1","2","3","4","MAX"})
B767:setAutoBrake_val({0,2,3,4,5,6})

B777 = Class_ACF:Create()
B777:setICAO("B777")
B777:setName("Boeing 777")
B777:setModels({"200ER","200LR","300ER","F"})
B777:setCategory("Heavy")
B777:setDEP_Flaps({"0","1","5","15","20"})
B777:setAPP_Flaps({"25","30"})
B777:setAutoBrake({"OFF","1","2","3","4","MAX"})
B777:setAutoBrake_val({0,2,3,4,5,6})




-- Concorde
CONC = Class_ACF:Create()
CONC:setICAO("CONC")
CONC:setName("Concorde")
CONC:setModels({" "})
CONC:setCategory("Concorde")
CONC:setDEP_Flaps({"ON","OFF"}) -- Used for Reheaters ON/OFF for Take OFF
CONC:setAPP_Flaps({"NA"})
CONC:setAutoBrake({"NA"})
CONC:setAutoBrake_val({0})



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------									
-- Do not change code below, if you do not understand what you are going to change !!! ;-)
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------								


	

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Create custom commands
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

create_command( "DanielLOWG/TEST_dev", "Test (Development only) ", "DM_cmd_DEV_TEST = true", "", "DM_cmd_DEV_TEST = false" )					-- For Testing only!!!


-- Call Procedures
	create_command( "DanielLOWG/Copilot/Proc/power_up", "Power Up Procedure", "DM_cmd_power_up = true", "", "" )								-- Power UP DM_procedure
	create_command( "DanielLOWG/Copilot/Proc/before_start_items", "Before Start Items", "DM_cmd_before_start_items = true", "", "" )			-- Before Start Items
	create_command( "DanielLOWG/Copilot/Proc/before_start_checklist", "Before Start Checklist", "DM_cmd_before_start_checklist = true", "", "" )-- Before Start Checklist
	create_command( "DanielLOWG/Copilot/Proc/engine_start1", "Starting Engine 1", "DM_cmd_engine1 = true", "", "" )							-- Start Engine 1
	create_command( "DanielLOWG/Copilot/Proc/engine_start2", "Starting Engine 2", "DM_cmd_engine2 = true", "", "" )							-- Start Engine 2
	--create_command( "DanielLOWG/Copilot/Proc/engine_start3", "Starting Engine 3", "DM_cmd_engine3 = true", "", "" )	
	--create_command( "DanielLOWG/Copilot/Proc/engine_start4", "Starting Engine 4", "DM_cmd_engine4 = true", "", "" )	
	create_command( "DanielLOWG/Copilot/Proc/after_start_items", "After Start Items", "DM_cmd_after_start_items = true", "", "" )				-- After Start Items
	create_command( "DanielLOWG/Copilot/Proc/before_taxi_checklist", "Before Taxi Checklist", "DM_cmd_before_taxi_checklist = true", "", "" )	-- Before Taxi Checklist
	create_command( "DanielLOWG/Copilot/Proc/taxi_items", "Taxi Items", "DM_cmd_taxi_items = true", "", "" )									-- Taxi Items
	create_command( "DanielLOWG/Copilot/Proc/after_TO_items", "After Take Off Items", "DM_cmd_after_TO_items = true", "", "" )					-- After Take Off Items
	create_command( "DanielLOWG/Copilot/Proc/descent_items", "Descent Items", "DM_cmd_descent_items = true", "", "" )							-- Descent Items
	create_command( "DanielLOWG/Copilot/Proc/approach_checklist", "Approach Checklist", "DM_cmd_approach_checklist = true", "", "" )			-- Approach Checklist
	create_command( "DanielLOWG/Copilot/Proc/landing_checklist", "Landing Checklist", "DM_cmd_landing = true", "", "" )							-- Landing Checklist
	create_command( "DanielLOWG/Copilot/Proc/afer_landing_items", "After Landing Items", "DM_cmd_after_landing = true", "", "" )				-- After Landing Items
	create_command( "DanielLOWG/Copilot/Proc/parking_items", "Parking Items", "DM_cmd_parking = true", "", "" )									-- Parking Items

	create_command( "DanielLOWG/Copilot/Proc/apu_start", "Start APU", "DM_cmd_apu_start = true", "", "" )										-- APU Start DM_procedure

	create_command( "DanielLOWG/Copilot/Proc/GoArround", "Go Arround", "DM_cmd_go_arround = true", "", "" )										-- Go Arround Procedure

	create_command( "DanielLOWG/Copilot/Proc/checklist_continue", "Continue Checklist", "DM_cmd_checklist_continue = true", "", "" )			-- Continue Checklist 
		-- for Voice Attack different Cpt Call Out's possible for this action like: Checked, Set, Received, Tested, ...

	create_command( "DanielLOWG/Copilot/Proc/start_next_procedure", "Start next Procedure", "DM_cmd_next_procedure = true", "", "" )			-- Continue Checklist 

-- Gear and Flaps Commands (prepared for different Planes)
	create_command( "DanielLOWG/Copilot/Gear/Gear_Up", "Gear Up", "DM_cmd_Gear_up = true", "", "" )												-- Command Gear Up
	create_command( "DanielLOWG/Copilot/Gear/Gear_Down", "Gear Down", "DM_cmd_Gear_down = true", "", "" )										-- Command Gear Down

	create_command( "DanielLOWG/Copilot/Flaps/Flaps_Up", "Flaps Up", "DM_cmd_Flaps_0 = true", "", "" )											-- Command Flaps Up
	create_command( "DanielLOWG/Copilot/Flaps/Flaps_1", "Flaps 1", "DM_cmd_Flaps_1 = true", "", "" )											-- Command Flaps 1	
	create_command( "DanielLOWG/Copilot/Flaps/Flaps_2", "Flaps 2", "DM_cmd_Flaps_2 = true", "", "" )											-- Command Flaps 2
	create_command( "DanielLOWG/Copilot/Flaps/Flaps_5", "Flaps 5", "DM_cmd_Flaps_5 = true", "", "" )											-- Command Flaps 5
	create_command( "DanielLOWG/Copilot/Flaps/Flaps_10", "Flaps 10", "DM_cmd_Flaps_10 = true", "", "" )											-- Command Flaps 10
	create_command( "DanielLOWG/Copilot/Flaps/Flaps_15", "Flaps 15", "DM_cmd_Flaps_15 = true", "", "" )											-- Command Flaps 15 
	create_command( "DanielLOWG/Copilot/Flaps/Flaps_20", "Flaps 20 B767", "DM_cmd_Flaps_20 = true", "", "" ) 									-- Command Flaps 20 Boeing 767 and Boeing 727
	create_command( "DanielLOWG/Copilot/Flaps/Flaps_25", "Flaps 25", "DM_cmd_Flaps_25 = true", "", "" )											-- Command Flaps 25
	create_command( "DanielLOWG/Copilot/Flaps/Flaps_30", "Flaps 30", "DM_cmd_Flaps_30 = true", "", "" )											-- Command Flaps 30
	create_command( "DanielLOWG/Copilot/Flaps/Flaps_40", "Flaps Full", "DM_cmd_Flaps_40 = true", "", "" )										-- Command Flaps 40


-- Key Bundles
	-- for example zibo's B738 uses 2 keys for TOGA and AT_OFF --> this key's can be used to combine them to one key
	create_command( "DanielLOWG/Key_Bundles/TOGA", "TO/GA Button Combine", "DM_cmd_TOGA = true", "", "DM_cmd_TOGA = false" )					-- Key Bundle for TO/GA (Buttons on Thrustlevers)
	create_command( "DanielLOWG/Key_Bundles/AT_OFF", "A/T OFF Button Combine", "DM_cmd_AT_OFF = true", "", "DM_cmd_AT_OFF = false" )			-- Key Bundle for A/T OFF (Buttons on Thrustlevers)





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Common Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Squawk Code  --> Call out String splitted in single digits
function DM_Squawk2String(val)

	local dig1000 = math.floor(val /1000)
	local dig100 = math.floor((val - dig1000*1000) /100)
	local dig10 = math.floor((val - dig1000*1000 - dig100*100) /10)
	local dig1 = math.floor(val - dig1000*1000 - dig100*100 - dig10*10)
	
	local str = tostring(dig1000) .. " " .. tostring(dig100) .. " " .. tostring(dig10) .. " " .. tostring(dig1) 
	
	return str
end



-- Altimeter QNH depending on Setting inHg/hPA --> Call out String
function DM_QNH2String(QNH, isHPA)

	local val = 0

	local dig1000 = 0
	local dig100 = 0
	local dig10 = 0
	local dig1 = 0
	
	local str = tostring(dig1000) .. " " .. tostring(dig100) .. " " .. tostring(dig10) .. " " .. tostring(dig1)


	if isHPA == 1 or isHPA == true then
		val = math.floor(QNH * 33.8637526 + 0.5)
		
		dig1000 = math.floor(val /1000)
		dig100 = math.floor((val - dig1000*1000) /100)
		dig10 = math.floor((val - dig1000*1000 - dig100*100) /10)
		dig1 = math.floor(val - dig1000*1000 - dig100*100 - dig10*10)
	
		if dig1000 == 0 then
			str = tostring(dig100) .. " " .. tostring(dig10) .. " " .. tostring(dig1)
		else
			str = tostring(dig1000) .. " " .. tostring(dig100) .. " " .. tostring(dig10) .. " " .. tostring(dig1)
		end

	else
		val = math.floor(QNH * 100)
		
		dig1000 = math.floor(val /1000)
		dig100 = math.floor((val - dig1000*1000) /100)
		dig10 = math.floor((val - dig1000*1000 - dig100*100) /10)
		dig1 = math.floor(val - dig1000*1000 - dig100*100 - dig10*10)
	
		str = tostring(dig1000) .. " " .. tostring(dig100) .. " decimal " .. tostring(dig10) .. " " .. tostring(dig1)
	end

	return str
end


-- Heading --> Call out String splitted in single digits	-----> also usable for CRS 
function DM_HDG2String(val)
	
	if val == 0 then
		val = 360
	end
	
	-- spliting number into single digits
	local dig100 = math.floor(val /100)
	local dig10 = math.floor((val - dig100*100) /10)
	local dig1 = math.floor(val - dig100*100 - dig10*10)
	
	local str = tostring(dig100) .. " " .. tostring(dig10) .. " " .. tostring(dig1) 
	
	return str
end

-- Lineare Interpolation
function LinInterpol(x,x0,y0,x1,y1)

	return y0 + (x - x0) * (y1 - y0) / (x1 - x0)

end

-- Round like a comercialist
function DM_round(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end
















	