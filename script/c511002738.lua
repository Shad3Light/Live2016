--ギミック・パペット－ギア・チェンジャー
function c511002738.initial_effect(c)
	--lvchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(56427559,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511002738.lvtg)
	e1:SetOperation(c511002738.lvop)
	c:RegisterEffect(e1)
end
function c511002738.lvfilter(c,lv)
	local clv=c:GetLevel()
	return c:IsFaceup() and c:IsSetCard(0x83) and clv>0 and clv~=lv
end
function c511002738.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c511002738.lvfilter(chkc,e:GetHandler():GetLevel()) end
	if chk==0 then return Duel.IsExistingTarget(c511002738.lvfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e:GetHandler():GetLevel()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c511002738.lvfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e:GetHandler():GetLevel())
end
function c511002738.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end