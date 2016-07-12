--サモン・ゲート
--Summon Gate
--Script by mercury233
--Not fully implemented, pendulum summon don't limit the count
function c29724053.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--summon count limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetTarget(c29724053.sumlimit)
	c:RegisterEffect(e2)
	--counter
	if c29724053.counter==nil then
		c29724053.counter=true
		c29724053[0]=0
		c29724053[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c29724053.resetcount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetOperation(c29724053.addcount)
		Duel.RegisterEffect(ge2,0)
	end
end
function c29724053.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA) and c29724053[sump]>=3
end
function c29724053.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c29724053[0]=0
	c29724053[1]=0
end
function c29724053.addcount(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetPreviousLocation()==LOCATION_EXTRA then
			local p=tc:GetReasonPlayer()
			c29724053[p]=c29724053[p]+1
		end
		tc=eg:GetNext()
	end
end
