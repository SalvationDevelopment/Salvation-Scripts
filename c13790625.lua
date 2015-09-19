--Dragon's Bind
function c13790625.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c13790625.target)
	e1:SetOperation(c13790625.operation)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c13790625.checkop)
	c:RegisterEffect(e2)
	--Destroy2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c13790625.descon2)
	e3:SetOperation(c13790625.desop2)
	c:RegisterEffect(e3)
end
function c13790625.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c13790625.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c13790625.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c13790625.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPATTACK)
	Duel.SelectTarget(tp,c13790625.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c13790625.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_OWNER_RELATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c13790625.rcon)
		e1:SetValue(1)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e2:SetValue(c13790625.efilter)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(80485722,0))
		e3:SetCategory(CATEGORY_DESTROY)
		e3:SetType(EFFECT_TYPE_QUICK_O)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		e3:SetHintTiming(TIMING_DAMAGE_STEP)
		e3:SetRange(LOCATION_SZONE)
		e3:SetCondition(c13790625.atkcon)
		e3:SetOperation(c13790625.adesop)
		c:RegisterEffect(e3)
	end
end
function c13790625.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c13790625.acon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler()) and e:GetHandlerPlayer()==e:GetLabel()
end
function c13790625.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c13790625.tgval(e,re,rp)
	return rp~=e:GetOwnerPlayer() and aux.tgval(e,re,rp)
end
function c13790625.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c13790625.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c13790625.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(), REASON_EFFECT)
end
function c13790625.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local bc=tc:GetBattleTarget()
	return ph==PHASE_DAMAGE and not c:IsStatus(STATUS_CHAINING)
	and a:IsLocation(LOCATION_MZONE) and d:IsLocation(LOCATION_MZONE) 
	and (tc==a or tc==d) and bc:IsLevelAbove(5) and not Duel.IsDamageCalculated()
	and e:GetHandler():GetFlagEffect(13790625)==0
end
function c13790625.adesop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	local bc=tc:GetBattleTarget()
	local atk=bc:GetBaseAttack()
	if bc:IsRelateToBattle() then 
		Duel.Destroy(bc,REASON_EFFECT) 
		if bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+RESET_END)
			tc:RegisterEffect(e1)
		end
	end
	e:GetHandler():RegisterFlagEffect(13790625,RESET_PHASE+RESET_DAMAGE_CAL,0,1)
end