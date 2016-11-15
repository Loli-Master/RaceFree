addEvent("explode",true)
bombveh={}
setted=0
specveh=createVehicle(429,2478,-1658,13.2,0,0,90)
exploded="off"

function getoff()
	destroyElement(source)
end

function cleaner()
	if(source==specveh)then
		destroyElement(source)
		specveh=createVehicle(429,2478,-1658,13.2,0,0,90)
	else
		for key,val in pairs(getVehicleOccupants(source))do
			if(getElementType(val)~="player")then
				destroyElement(val)
			end
		end
		setTimer(function(lol)destroyElement(lol)end,500,1,source)
	end
end
addEventHandler("onVehicleExplode",getRootElement(),cleaner)

function explodeit(xX,xY,xZ,target,who,what,how,many)
	if(target==specveh)then
		destroyElement(target)
		specveh=createVehicle(429,2478,-1658,13.2,0,0,90)
		setWeaponAmmo(who,what,how+100,many+1)
	elseif(exploded=="on")then
		if(what==22)or(what==23)or(what==24)or(what==25)or(what==26)or(what==27)or(what==33)or(what==34)then
			createExplosion ( xX, xY, xZ, 2, who)
		elseif(what==28)or(what==29)or(what==32)or(what==30)or(what==31)then
			createExplosion ( xX, xY, xZ, 4, who)
		elseif(what==38)then
			createExplosion ( xX, xY, xZ, 12, who)
		end
	end
end
addEventHandler("explode",getRootElement(),explodeit)

function tada(target,seat,jacked)
	local set=0
	for key,val in pairs(bombveh)do
		if(val==target)then
			set=1
			break
		end
	end
	if(set==1)then
		blowVehicle(target)
		setted=setted-1
	end
end
addEventHandler("onPlayerVehicleEnter",getRootElement(),tada)

function addbomb(setter,command)
	local vehbomb = getPedOccupiedVehicle(setter)
	if(vehbomb)then
		setted=setted+1
		bombveh[setted]=vehbomb
		outputChatBox ( "Bomb Setted", setter, 255, 0, 0, true )
	end
end
addCommandHandler("bomb",addbomb)

function isexplode(setter,command,dec)
	if(dec=="on")or(dec=="off")then
		exploded=dec
		outputChatBox ( "Exploding Ammo setted to "..dec, getRootElement(), 255, 255, 0, true )
	end
end
addCommandHandler("explode",isexplode)

function createAnalogControlTest (who,what)
    local t_Pos = {getElementPosition(who)} 
    local veh = createVehicle (522, unpack(t_Pos))
    local ped = createPed (0, unpack(t_Pos))
	addEventHandler("onPedWasted",ped,getoff)
    warpPedIntoVehicle (ped, veh)
	triggerClientEvent(who,"startAI",who,ped)
end
addCommandHandler ("analog", createAnalogControlTest)