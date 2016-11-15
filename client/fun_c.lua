mode="off"
addEvent("startAI",true)

function targetingActivated ( weapon,ammo,ammoInClip,hitX,hitY,hitZ,target )
	triggerServerEvent("explode",source,hitX,hitY,hitZ,target,source,weapon,ammo,ammoInClip)
end
addEventHandler ( "onClientPlayerWeaponFire", getLocalPlayer(), targetingActivated )

function god()
	if(mode=="on")then
		cancelEvent()
	end
end
addEventHandler("onClientPlayerDamage",getLocalPlayer(),god)

function setgodmode(cmd,sd)
	if(sd=="on")or(sd=="off")then
		mode=sd
		outputChatBox("Godmode is "..mode.." now")
	end
end
addCommandHandler("godmode",setgodmode)

function ai(ped)
    setPedAnalogControlState (ped, "accelerate", 0.05)
    setPedAnalogControlState (ped, "vehicle_left", 1)
end
addEventHandler("startAI",getLocalPlayer(),ai)