--Dinomist Brachion
function c13790633.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13790633,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c13790633.negcon)
	e2:SetTarget(c13790633.negtg)
	e2:SetOperation(c13790633.negop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c13790633.spcon)
	c:RegisterEffect(e3)
end

function c13790633.tfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1e71) and c:IsControler(tp) and c:GetLocation()==LOCATION_ONFIELD
end
function c13790633.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	if not e:GetHandler():GetFlagEffect(13790633)==0 then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c13790633.tfilter,1,nil)and g:GetFirst()~=e:GetHandler() and Duel.IsChainDisablable(ev)
end
function c13790633.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c13790633.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(13790633,1)) then
		e:GetHandler():RegisterFlagEffect(13790633,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		Duel.NegateEffect(ev)
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	else end
end


function c13790633.cfilter(c)
	return c:IsFaceup() and c:GetCode()==13790633
end
function c13790633.mafilter(c)
	local atk=c:GetAttack()
	return c:IsFaceup() and not Duel.IsExistingMatchingCard(c13790633.cmafilter,tp,LOCATION_MZONE,0,1,nil,atk)
end
function c13790633.cmafilter(c,atk)
	return c:IsFaceup() and c:GetAttack()>=atk
end
function c13790633.spcon(e,tp)
	return Duel.IsExistingMatchingCard(c13790633.mafilter,tp,0,LOCATION_MZONE,1,nil)
		and not Duel.IsExistingMatchingCard(c13790633.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
