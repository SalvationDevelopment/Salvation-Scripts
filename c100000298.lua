--最強の盾
function c100000298.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c100000298.target)
	e1:SetOperation(c100000298.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c100000298.conatk)
	e2:SetValue(c100000298.atk)
	c:RegisterEffect(e2)
	--Def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetCondition(c100000298.condef)
	e3:SetValue(c100000298.def)
	c:RegisterEffect(e3)
	--Equip limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EQUIP_LIMIT)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetValue(c100000298.equiplimit)
	c:RegisterEffect(e4)
end
function c100000298.equiplimit(e,c)
	return c:IsRace(RACE_WARRIOR)
end
function c100000298.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function c100000298.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and c100000298.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100000298.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c100000298.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c100000298.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c100000298.conatk(e)
	return e:GetHandler():GetEquipTarget():IsAttackPos()
end
function c100000298.atk(e,c)
	return e:GetHandler():GetEquipTarget():GetTextDefence()
end
function c100000298.condef(e)
	return e:GetHandler():GetEquipTarget():IsDefencePos()
end
function c100000298.def(e,c)
	return e:GetHandler():GetEquipTarget():GetAttack()
end
