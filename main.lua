local mod = CreateFrame('frame', '!leader', UIParent)
mod:SetScript('OnEvent', function(self, event, ...) return self[ event ](self, ...) end)
mod:RegisterEvent('ADDON_LOADED')

local friends = { }

function mod:ADDON_LOADED(addon)
  if addon == '!leader' then
    self:UnregisterEvent('ADDON_LOADED')

    self:RegisterEvent('PARTY_LEADER_CHANGED')
    self:RegisterEvent('FRIENDLIST_UPDATE')

    self:PARTY_LEADER_CHANGED()
    self:FRIENDLIST_UPDATE()

    self.ADDON_LOADED = nil
    return true
  end
end

function mod:PARTY_LEADER_CHANGED()
  if UnitIsPartyLeader('player') then
    self:RegisterEvent('CHAT_MSG_PARTY')
    return true
  else
    self:UnregisterEvent('CHAT_MSG_PARTY')
  end
end

function mod:CHAT_MSG_PARTY(msg, author)
  if msg == '!leader' and friends[ author ] then
    PromoteToLeader(author, true)
    return true
  end
end

function mod:FRIENDLIST_UPDATE()
  wipe(friends)

  for index = 1, GetNumFriends() do
    local name, _, _, _, online = GetFriendInfo(index)
    friends[ name ] = online
  end

  return true
end
