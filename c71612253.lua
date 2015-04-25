--DDD Tell the Sniper Overlord
function c71612253.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,5,2,c71612253.ovfilter,aux.Stringid(71612253,0))
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c71612253.cost)
	e1:SetCondition(c71612253.condition)
	e1:SetTarget(c71612253.target)
	e1:SetOperation(c71612253.operation)
	c:RegisterEffect(e1)	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c71612253.thcon)
	e2:SetTarget(c71612253.thtg)
	e2:SetOperation(c71612253.thop)
	c:RegisterEffect(e2)
if not c71612253.global_check then
		c71612253.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetCondition(c71612253.damcon)
		ge1:SetOperation(c71612253.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c71612253.ovfilter(c)
	return c:IsFaceup() and c:GetCode()==3758046
end

function c71612253.damcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c71612253.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(ep,51370136,RESET_PHASE+PHASE_END,0,1)
end
function c71612253.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,51370136)~=0
end
function c71612253.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c71612253.filter(c)
	return c:IsFaceup()
end
function c71612253.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c71612253.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71612253.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71612253.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c71612253.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
		e2:SetValue(-1000)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end

function c71612253.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c71612253.thfilter(c)
	return c:IsSetCard(0xae) or c:IsSetCard(0xaf) and c:IsAbleToGrave()
end
function c71612253.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71612253.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71612253.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71612253.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
