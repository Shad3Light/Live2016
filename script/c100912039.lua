--覇王龍ズァーク
--Supreme King Dragon Zarc
--Scripted by Eerie Code
function c100912039.initial_effect(c)
	c:EnableReviveLimit()
	--aux.AddFusionProcFunMulti(c,true,c100912039.filters)
	aux.EnablePendulumAttribute(c,false)
	--fusion procedure
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c100912039.fuscon)
	e0:SetOperation(c100912039.fusop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c100912039.limval)
	c:RegisterEffect(e2)
	--destroy drawn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100912039,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c100912039.ddcon)
	e3:SetTarget(c100912039.ddtg)
	e3:SetOperation(c100912039.ddop)
	c:RegisterEffect(e3)
	--destroy all
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(100912039,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c100912039.destg)
	e4:SetOperation(c100912039.desop)
	c:RegisterEffect(e4)
	--Immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetValue(c100912039.tgvalue)
	c:RegisterEffect(e6)
	--special summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(100912039,2))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetCondition(aux.bdocon)
	e7:SetTarget(c100912039.sptg)
	e7:SetOperation(c100912039.spop)
	c:RegisterEffect(e7)
	--pendulum
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(100912039,3))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	e8:SetCondition(c100912039.pencon)
	e8:SetTarget(c100912039.pentg)
	e8:SetOperation(c100912039.penop)
	c:RegisterEffect(e8)
end
c100912039.miracle_synchro_fusion=true
function c100912039.fusfilter1(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_FUSION)
end
function c100912039.fusfilter2(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
end
function c100912039.fusfilter3(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ)
end
function c100912039.fusfilter4(c)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_PENDULUM)
end
c100912039.filters={c100912039.fusfilter1,c100912039.fusfilter2,c100912039.fusfilter3,c100912039.fusfilter4}
-- TO BE REMOVED ONCE THE UTILITIES ARE UPDATED
function c100912039.FConditionFilterMultiOr(c,funs,n)
	for i=1,n do
		if funs[i](c) then return true end
	end
	return false
end
function c100912039.FConditionFilterMulti(c,mg,funs,n,tbt)
	for i=1,n do
		local tp=2^(i-1)
		if bit.band(tbt,tp)~=0 and funs[i](c) then
			local t2=tbt-tp
			if t2==0 then return true end
			local mg2=mg:Clone()
			mg2:RemoveCard(c)
			if mg2:IsExists(c100912039.FConditionFilterMulti,1,nil,mg2,funs,n,t2) then return true end
		end
	end
	return false
end
function c100912039.CloneTable(g)
	return {table.unpack(g)}
end
function c100912039.FConditionFilterMulti2(c,gr)
	local gr2=c100912039.CloneTable(gr)
	for i=1,#gr2 do
		gr2[i]:RemoveCard(c)
	end
	table.remove(gr2,1)
	if #gr2==1 then
		return gr2[1]:IsExists(aux.TRUE,1,nil)
	else
		return gr2[1]:IsExists(c100912039.FConditionFilterMulti2,1,nil,gr2)
	end
end
function c100912039.FConditionFilterMultiSelect(c,funs,n,mg,sg)
	local valid=c100912039.FConditionFilterMultiValid(sg,funs,n)
	if not valid then valid={0} end 
	local all = (2^n)-1
	for k,v in pairs(valid) do
		v=bit.bxor(all,v)
		if c100912039.FConditionFilterMulti(c,mg,funs,n,v) then return true end
	end
	return false
end
function c100912039.FConditionFilterMultiValid(g,funs,n)
	local tp={}
	local tc=g:GetFirst()
	while tc do
		local tp1={}
		for i=1,n do
			if funs[i](tc) then table.insert(tp1,2^(i-1)) end
		end
		table.insert(tp,tp1)
		tc=g:GetNext()
	end
	return c100912039.FConditionMultiGenerateValids(tp,n)
end
function c100912039.FConditionMultiGenerateValids(vs,n)
	local c=2
	while #vs > 1 do
		local v1=vs[1]
		table.remove(vs,1)
		local v2=vs[1]
		table.remove(vs,1)
		table.insert(vs,1,c100912039.FConditionMultiCombine(v1,v2,n,c))
		c=c+1
	end
	return vs[1]
end
function c100912039.FConditionMultiCombine(t1,t2,n,c)
	local res={}
	for k1,v1 in pairs(t1) do
		for k2,v2 in pairs(t2) do
			table.insert(res,bit.bor(v1,v2))
		end
	end 
	res=c100912039.FConditionMultiCheckCount(res,n)
	return c100912039.FConditionFilterMultiClean(res)
end
function c100912039.FConditionMultiCheckCount(vals,n)
	local res={} local flags={}
	for k,v in pairs(vals) do
		local c=0
		for i=1,n do
			if bit.band(v,2^(i-1))~=0 then c=c+1 end
		end
		if not flags[c] then
			res[c] = {v}
			flags[c] = true
		else
			table.insert(res[c],v)
		end
	end
	local mk=0
	for k,v in pairs(flags) do
		if k>mk then mk=k end
	end
	return res[mk]
end
function c100912039.FConditionFilterMultiClean(vals)
	local res={} local flags={}
	for k,v in pairs(vals) do
		if not flags[v] then
			table.insert(res,v)
			flags[v] = true
		end
	end
	return res
end
function c100912039.fuscon(e,g,gc,chkfnf)
	local c=e:GetHandler()
	if g==nil then return true end
	if not c:IsFacedown() then return false end
	local chkf=bit.band(chkfnf,0xff)
	local funs=c100912039.filters
	local n=4
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,c):Filter(c100912039.FConditionFilterMultiOr,nil,funs,n)
	if gc then
		if not gc:IsCanBeFusionMaterial(c) then return false end
		local check_tot=(2^n)-1
		local mg2=mg:Clone()
		mg2:RemoveCard(gc)
		for i=1,n do
			if funs[i](gc) then
				local tbt=check_tot-2^(i-1)
				if mg2:IsExists(c100912039.FConditionFilterMulti,1,nil,mg2,funs,n,tbt) then return true end
			end
		end
		return false
	end
	local fs=false
	local groups={}
	for i=1,n do
		table.insert(groups,Group.CreateGroup())
	end
	local tc=mg:GetFirst()
	while tc do
		for i=1,n do
			if funs[i](tc) then
				groups[i]:AddCard(tc)
				if Auxiliary.FConditionCheckF(tc,chkf) then fs=true end
			end
		end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		if not fs then return false end
		local gr2=c100912039.CloneTable(groups)
		return gr2[1]:IsExists(c100912039.FConditionFilterMulti2,1,nil,gr2)
	end
end
function c100912039.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local c=e:GetHandler()
	local chkf=bit.band(chkfnf,0xff)
	local funs=c100912039.filters
	local n=4
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,c):Filter(c100912039.FConditionFilterMultiOr,nil,funs,n)
	if gc then
		local sg=Group.FromCards(gc)
		local mg=g:Clone()
		mg:RemoveCard(gc)
		for i=1,n-1 do
			local mg2=mg:Filter(c100912039.FConditionFilterMultiSelect,nil,funs,n,mg,sg)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local sg2=mg2:Select(tp,1,1,nil)
			sg:AddCard(sg2:GetFirst())
			mg:RemoveCard(sg2:GetFirst())
		end
		Duel.SetFusionMaterial(sg)
		return
	end
	local sg=Group.CreateGroup()
	local mg=g:Clone()
	for i=1,n do
		local mg2=mg:Filter(c100912039.FConditionFilterMultiSelect,nil,funs,n,mg,sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=nil
		if i==1 and chkf~=PLAYER_NONE then
			sg2=mg2:FilterSelect(tp,Auxiliary.FConditionCheckF,1,1,nil,chkf)
		else
			sg2=mg2:Select(tp,1,1,nil)
		end
		sg:AddCard(sg2:GetFirst())
		mg:RemoveCard(sg2:GetFirst())
	end
	Duel.SetFusionMaterial(sg)
end
-- END SECTION TO BE REMOVED
function c100912039.check_fusion_material_48144509(g,chkf)
	local fs=false
	local mg=g:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
	local funs=c100912039.filters
	local groups={}
	for i=1,4 do
		table.insert(groups,Group.CreateGroup())
	end
	local tc=mg:GetFirst()
	while tc do
		for i=1,4 do
		if funs[i](tc) then
			groups[i]:AddCard(tc)
			if Auxiliary.FConditionCheckF(tc,chkf) then fs=true end
		end
	end
	tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then
		if not fs then return false end
		local gr2=c100912039.CloneTable(groups)
		return gr2[1]:IsExists(c100912039.FConditionFilterMulti2,1,nil,gr2)
	end 
end
function c100912039.select_fusion_material_48144509(tp,g,chkf)
	local mg=g:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_MZONE)
	local sg=Group.CreateGroup()
	local funs=c100912039.filters
	for i=1,4 do
		local mg2=mg:Filter(c100912039.FConditionFilterMultiSelect,nil,funs,4,mg,sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg2=nil
		if i==1 and chkf~=PLAYER_NONE then
			sg2=mg2:FilterSelect(tp,Auxiliary.FConditionCheckF,1,1,nil,chkf)
		else
			sg2=mg2:Select(tp,1,1,nil)
		end
		sg:AddCard(sg2:GetFirst())
		mg:RemoveCard(sg2:GetFirst())
	end
	Duel.SetFusionMaterial(sg)
	return sg
end
function c100912039.limval(e,re,rp)
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and not rc:IsImmuneToEffect(e)
end
function c100912039.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c100912039.ddfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c100912039.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=nil
	if eg then g=eg:Filter(c100912039.ddfilter,nil,tp) end
	if chk==0 then return g and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c100912039.ddop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c100912039.ddfilter,nil,tp)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c100912039.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c100912039.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c100912039.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c100912039.spfilter(c,e,tp)
	return c:IsSetCard(0x21fb) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100912039.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c100912039.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100912039.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100912039.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100912039.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c100912039.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c100912039.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end