addEvent("s_finish",true)
addEvent("s_vote",true)
addEvent("s_startEngine",true)
addEvent("s_checkpos",true)
r_markerposX=2463
r_markerposY=-1658
r_markerposZ=14
r_pos={[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0}
r_join={}
r_join2={}
r_player=0
r_finished=0
r_vehplate="RACE CAR"
r_startM=createMarker(r_markerposX,r_markerposY,r_markerposZ,"checkpoint",4,0,255,0,255,getRootElement())
r_startB=createBlipAttachedTo(r_startM,33)
r_voted=0
r_vote={}
r_started=0
r_play=0

function f_checkpos(check)
	r_pos[check]=r_pos[check]+1
	triggerClientEvent(client,"g_posShow",client,r_pos[check])
end
addEventHandler("s_checkpos",getRootElement(),f_checkpos)

function f_reset()
	local join2={}
	local newplayer=0
	for key=1,r_player,1 do
		if(r_join2[key]~=nil)then
			newplayer=newplayer+1
			join2[newplayer]=r_join2[key]
		end
	end
	r_join2=nil
	r_join2=join2
	r_player=newplayer
end

function s_votestart()
	if(r_vote[client]==1)then
		r_vote[client]=0
		r_voted=r_voted+1
		if(r_voted==r_player)then
			triggerClientEvent(r_join2,"c_raceStart",r_startM,r_player)
			triggerClientEvent(r_join2,"g_reset",r_startM)
			destroyElement(r_startM)
			destroyElement(r_startB)
			r_started=1
			r_vote=nil
			r_vote={}
			r_join=nil
			r_join={}
			r_join2=nil
			r_join2={}
			r_voted=0
			r_player=0
		end
	end
end
addEventHandler("s_vote",getRootElement(),s_votestart)

function f_start(mark,dim)
	if(mark==r_startM)and(getVehicleType(getPedOccupiedVehicle(source))=="Automobile")and(r_player<5)then
		outputChatBox("Type /join to join the race",source)
	end
end
addEventHandler("onPlayerMarkerHit",getRootElement(),f_start)

function s_starter()
	setVehicleEngineState(getPedOccupiedVehicle(client),true)
end
addEventHandler("s_startEngine",getRootElement(),s_starter)

function f_finish(who,num,id)
	r_finished=r_finished-1
	if(num>0)then
		givePlayerMoney(who,5000*(r_pos[11]-r_pos[12]+1))
		outputChatBox("Congratulations!",who,0,255,0)
	elseif(num==0)then
		setVehicleEngineState(getPedOccupiedVehicle(who),true)
		r_vote[who]=nil
		r_join2[r_join[who]]=nil
		r_join[who]=nil
		setVehiclePlateText(getPedOccupiedVehicle(who),"IMALOSER")
		triggerClientEvent(getRootElement(),"g_exit",who,id)
		f_reset()
	end
	if(r_finished==0)and(r_started==1)then
		r_started=0
		r_startM=createMarker(r_markerposX,r_markerposY,r_markerposZ,"checkpoint",4,0,255,0,255,getRootElement())
		r_startB=createBlipAttachedTo(r_startM,33)
		r_pos=nil
		r_pos={[1]=0,[2]=0,[3]=0,[4]=0,[5]=0,[6]=0,[7]=0,[8]=0,[9]=0,[10]=0,[11]=0,[12]=0}
	end
	toggleControl(who,"enter_exit",true)
	setVehicleDamageProof(getPedOccupiedVehicle(who),false)
--	destroyElement(r_car)
end
addEventHandler("s_finish",getRootElement(),f_finish)

function f_join(thePlayer)
	if(isElementWithinMarker(thePlayer,r_startM))then
		if(r_join[thePlayer]~=1)then
			if(isPedInVehicle(thePlayer))then
				r_veh=getPedOccupiedVehicle(thePlayer)
				if(getVehicleType(r_veh)=="Automobile")and(r_player<5)then
					r_player=r_player+1
					r_finished=r_player
					r_join[thePlayer]=1
					r_vote[thePlayer]=1
					r_join2[r_player]=thePlayer
					removePedFromVehicle(thePlayer)
					setElementPosition(r_veh,r_markerposX,(r_markerposY-15)+(6*r_player),r_markerposZ)
					setElementRotation(r_veh,0,0,90)
					setElementVelocity(r_veh,0,0,0)
					warpPedIntoVehicle(thePlayer,r_veh)
--					r_car=createVehicle(r_vehtype,r_markerposX,r_markerposY,r_markerposZ,0,0,90)
					setVehicleDamageProof(r_veh,true)
					setVehiclePlateText(r_veh,r_vehplate)
					setVehicleEngineState(r_veh,false)
					toggleControl(thePlayer,"enter_exit",false)
					triggerClientEvent(getRootElement(),"g_start",thePlayer,thePlayer)
					triggerClientEvent(thePlayer,"g_show",thePlayer)
				end
			end
		end
	else
		outputChatBox("You must enter the race marker first!",thePlayer)
	end
end
addCommandHandler("join",f_join)