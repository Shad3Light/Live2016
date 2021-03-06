--幻煌龍の浸禍
--Deep Whirlpool of the Mythic Radiance Dragon
--Script by dest
function c100912073.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100912073.condition)
	e1:SetTarget(c100912073.target)
	e1:SetOperation(c100912073.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c100912073.handcon)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100912073,0))
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c100912073.eqcost)
	e3:SetTarget(c100912073.eqtg)
	e3:SetOperation(c100912073.eqop)
	c:RegisterEffect(e3)
end
function c100912073.cfilter(c)
	return c:IsFacedown() or not c:IsType(TYPE_NORMAL)
end
function c100912073.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c100912073.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c100912073.mfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c100912073.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c100912073.mfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100912073.mfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c100912073.mfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c100912073.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-1000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_DISABLE_EFFECT)
		e4:SetValue(RESET_TURN_SET)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
	end
end
function c100912073.filter(c)
	return c:IsFaceup() and c:IsCode(22702055)
end
function c100912073.handcon(e)
	return Duel.IsExistingMatchingCard(c100912073.filter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		or Duel.IsEnvironment(22702055)
end
function c100912073.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c100912073.efilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsCanBeEffectTarget(e)
end
function c100912073.eqfilter(c,g)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x1fc) and g:IsExists(c100912073.eqcheck,1,nil,c)
end
function c100912073.eqcheck(c,ec)
	return ec:CheckEquipTarget(c)
end
function c100912073.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c100912073.efilter,tp,LOCATION_MZONE,0,nil,e)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c100912073.efilter(chkc,e) end
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c100912073.eqfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c100912073.efilter,tp,LOCATION_MZONE,0,1,1,nil,e)
end
function c100912073.eqop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c100912073.eqfilter,tp,LOCATION_HAND,0,1,1,nil,tg)
	local eq=g:GetFirst()
	if eq then
		Duel.Equip(tp,eq,tc,true)
	end
end