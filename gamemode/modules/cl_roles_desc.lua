BREACH = BREACH || {}
BREACH.Descriptions = BREACH.Descriptions || {}
BREACH.Descriptions.russian = BREACH.Descriptions.russian || {}
BREACH.Descriptions.english = BREACH.Descriptions.english || {}

function BREACH.GetDescription(rolename)

	local mylang = langtouse

	if !mylang then mylang = "english" end

	local langtable = BREACH.Descriptions[mylang]
	if !langtable then
		if mylang == "ukraine" then
			langtable = BREACH.Descriptions.russian
		else
			langtable = BREACH.Descriptions.english
		end
	end

	if !langtable[rolename] and rolename:find("SCP") then
		if mylang == "russian" or mylang == "ukraine" then
			return "Вы - Аномальный SCP-Объект\n\nСкооперируйтесь с другими SCP, убейте всех людей кроме Длани Змей и сбегите!"
		elseif mylang == "chinese" then
			return "你是一个异常的SCP对象\n\n与其他Scp合作，杀死除蛇之手以外的所有人类并逃跑！"
		else
			return "You are an Anomalous SCP Object\n\nCooperate with other SCPs, kill all humans except the Hand of the Serpents and escape!"
		end
	elseif !langtable[rolename] then
		if mylang == "russian" or mylang == "ukraine" then
			return "Вы - "..GetLangRole(rolename).."\n\nВыполняйте свою нынешнюю задачу."
		elseif mylang == "chinese" then
			return "你是 -"..GetLangRole(rolename).."\n\n完成当前任务"
		else
			return "You - "..GetLangRole(rolename).."\n\nComplete your current task."
		end
	else
		return langtable[rolename]
	end

end