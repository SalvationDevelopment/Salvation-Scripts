--輝望道
function c62829077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c62829077.cost)
	e1:SetTarget(c62829077.target)
	e1:SetOperation(c62829077.activate)
	c:RegisterEffect(e1)
end
function c62829077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c62829077.splimit)
	e1:SetLabelObject(e)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c62829077.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject() and Duel.GetFlagEffect(sump,62829077)==0
end
function c62829077.filter(c,e,tp)
	return c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62829077.xyzfilter(c,mg)
	return c:IsSetCard(0x7f) and c:IsXyzSummonable(mg)
end
function c62829077.mfilter1(c,exg)
	return exg:IsExists(c62829077.mfilter2,1,nil,c)
end
function c62829077.mfilter2(c,mc)
	return c.xyz_filter(mc)
end
function c62829077.mfilter3(c,mc,mg,exg)
	return mg:IsExists(c62829077.mfilter4,1,c,c,mc,exg)
end
function c62829077.mfilter4(c,mc1,mc2,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc1,mc2))
end
function c62829077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c62829077.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and mg:GetCount()>2
		and Duel.IsExistingMatchingCard(c62829077.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.RegisterFlagEffect(tp,62829077,0,0,1)
	local exg=Duel.GetMatchingGroup(c62829077.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if exg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg1=mg:FilterSelect(tp,c62829077.mfilter1,1,1,nil,exg)
	local tc1=sg1:GetFirst()
	mg:RemoveCard(tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg2=mg:FilterSelect(tp,c62829077.mfilter3,1,1,nil,tc1,mg,exg)
	local tc2=sg2:GetFirst()
	mg:RemoveCard(tc2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg3=mg:FilterSelect(tp,c62829077.mfilter4,1,1,nil,tc1,tc2,exg)
	sg1:Merge(sg2)
	sg1:Merge(sg3)
	Duel.SetTargetCard(sg1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,3,0,0)
	Duel.ResetFlagEffect(tp,62829077)
end
function c62829077.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c62829077.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c62829077.filter2,nil,e,tp)
	if g:GetCount()<3 then return end
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	Duel.RegisterFlagEffect(tp,62829077,0,0,1)
	local xyzg=Duel.GetMatchingGroup(c62829077.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,g)
	end
	Duel.ResetFlagEffect(tp,62829077)
end
