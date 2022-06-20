automaty = {}
ESX = nil
ESX = exports["es_extended"]:getSharedObject()

--[[
  FUNCTIONS
--]]

local function getJson()
  local data = LoadResourceFile(GetCurrentResourceName(), "vendingmachines.json")
  return json.decode(data)
end

local function saveJson(main,name,table)
  main[name] = table
  SaveResourceFile(GetCurrentResourceName(),"vendingmachines.json",json.encode(main, {indent = true}),-1)
end

--[[
  EVENTS
--]]

RegisterNetEvent("vending:open",function(which)
    local xPlayer = ESX.GetPlayerFromId(source)
		local VendJson = getJson()
    if VendJson[which] == nil then -- This vending machine is free to buy 
      TriggerClientEvent("vending:menu",source, "buy", which)
    elseif VendJson[which]["identifier"] == xPlayer.identifier then
      TriggerClientEvent("vending:menu",source, "manage", VendJson[which])
    end
end)

RegisterNetEvent("vending:buymachine",function(which)
  local xPlayer = ESX.GetPlayerFromId(source)
  if xPlayer.getMoney() >= Config.Price then
    local VendJson = getJson()
    local temporaryTable = {}
    temporaryTable["identifier"] = xPlayer.identifier
    temporaryTable["name"] = which
    temporaryTable["items"] = {}
    temporaryTable["money"] = 0
    saveJson(VendJson,which,temporaryTable)
    xPlayer.removeMoney(Config.Price)
    TriggerClientEvent("vending:notify",source,Translation[Config.Translation].BoughtMachine)
  else
    TriggerClientEvent("vending:notify",source,Translation[Config.Translation].YouDontHaveMoney)
  end
end)

RegisterNetEvent("vending:withdraw",function(name)
  local xPlayer = ESX.GetPlayerFromId(source)
  local VendJson = getJson()
  local HisVend = VendJson[name]
  local money = HisVend["money"]
  if money > 0 then
    xPlayer.addMoney(money)
    HisVend["money"] = 0
    saveJson(VendJson,name,HisVend)
    TriggerClientEvent("vending:notify",source, Translation[Config.Translation].YouWithdrawed .. money)
  else
    TriggerClientEvent("vending:notify",source, Translation[Config.Translation].NoMoneyInVending)
  end
end)

RegisterNetEvent("vending:withdraw",function(name)
  local xPlayer = ESX.GetPlayerFromId(source)
  local VendJson = getJson()
  local HisVend = VendJson[name]
  local money = HisVend["money"]
  if money > 0 then
    xPlayer.addMoney(money)
    HisVend["money"] = 0
    saveJson(VendJson,name,HisVend)
    TriggerClientEvent("vending:notify",source, Translation[Config.Translation].YouWithdrawed .. money)
  else
    TriggerClientEvent("vending:notify",source, Translation[Config.Translation].NoMoneyInVending)
  end
end)

RegisterNetEvent("vending:sellitem",function(item,count,price,tab_name)
  local xPlayer = ESX.GetPlayerFromId(source)
  local VendJson = getJson()
  local checkCount = xPlayer.getInventoryItem(item).count
  if checkCount >= count then
    local HisVend = VendJson[tab_name]
    local temporaryTable = {}
    temporaryTable["itemname"] = item
    temporaryTable["itemcount"] = count
    temporaryTable["itemprice"] = price
    temporaryTable["itemlabel"] = ESX.GetItemLabel(item)
    HisVend["items"][item] = temporaryTable
    saveJson(VendJson,tab_name,HisVend)
    xPlayer.removeInventoryItem(item,count)
    TriggerClientEvent("vending:notify",source, Translation[Config.Translation].YouPutItemsInStock)
  else
    TriggerClientEvent("vending:notify",source, Translation[Config.Translation].YouDontHaveThatMuchItems)
  end
end)

RegisterNetEvent("vending:delete",function(item,tab_name)
  local xPlayer = ESX.GetPlayerFromId(source)
  local VendJson = getJson()
  local HisVend = VendJson[tab_name]
  local countItem = HisVend["items"][item]["itemcount"]
  local temporaryTable = {}
  temporaryTable["itemname"] = item
  temporaryTable["itemcount"] = 0
  temporaryTable["itemprice"] = 0
  temporaryTable["itemlabel"] = ESX.GetItemLabel(item)
  HisVend["items"][item] = temporaryTable
  saveJson(VendJson,tab_name,HisVend)
  xPlayer.addInventoryItem(item,countItem)
  TriggerClientEvent("vending:notify",source, Translation[Config.Translation].YouTakeItemFromShop)
end)

RegisterNetEvent("vending:changeprice",function(item,price,tab_name)
  local VendJson = getJson()
  local HisVend = VendJson[tab_name]
  local countItem = HisVend["items"][item]["itemcount"]
  local temporaryTable = {}
  temporaryTable["itemname"] = item
  temporaryTable["itemcount"] = countItem
  temporaryTable["itemprice"] = price
  temporaryTable["itemlabel"] = ESX.GetItemLabel(item)
  HisVend["items"][item] = temporaryTable
  saveJson(VendJson,tab_name,HisVend)
  TriggerClientEvent("vending:notify",source, Translation[Config.Translation].YouChangedPrice)
end)

RegisterNetEvent("vending:buyitem",function(item,count,tab_name)
  local xPlayer = ESX.GetPlayerFromId(source)
  local VendJson = getJson()
  local HisVend = VendJson[tab_name]
  local itemsTable = HisVend["items"][item]

  local price = tonumber(itemsTable["itemprice"] * count)
  if itemsTable["itemcount"] <= count then
    if xPlayer.getMoney() >= price then
      itemsTable["itemcount"] = tonumber(itemsTable["itemcount"]-count)
      HisVend["items"][item] = itemsTable
      xPlayer.removeMoney(price)
      xPlayer.addInventoryItem(item,count)
      saveJson(VendJson,tab_name,HisVend)
      TriggerClientEvent("vending:notify",source, Translation[Config.Translation].YouBoughtItem.. "x"..count.." "..ESX.GetItemLabel(item))
    else
      TriggerClientEvent("vending:notify",source, Translation[Config.Translation].YouDontHaveMoney)
    end
  else
    TriggerClientEvent("vending:notify",source, Translation[Config.Translation].SmthWrong)
  end
end)