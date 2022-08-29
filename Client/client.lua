ESX = nil
PlayerData = nil
ESX = exports["es_extended"]:getSharedObject()
inMarker = false
--[[
  FUNCTIONS
--]]

local function BuyMenu(which)
	local elements = {{label = (Translation[Config.Translation].BuyVendingMachine..' [$'..Config.Price.."]"), value = 'buy'},}
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'buymachine', 
	{title    = (Translation[Config.Translation].VendingMachine..' ['..which..']'),align    = 'center',elements = elements}, function(data, menu)
    if data.current.value == "buy" then
      TriggerServerEvent("vending:buymachine",which)
      menu.close()
    end
	end, function(data, menu)
		menu.close()
	end)
end

local function ManageMenu(TableV)
	local elements = {
    {label = (Translation[Config.Translation].Withdraw..' [$'..TableV["money"].."]"), value = 'withdraw'},
    {label = (Translation[Config.Translation].SellItem), value = 'sellitem'},
    {label = (Translation[Config.Translation].ItemManagment), value = 'managment'},
  }
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'management', 
	{title    = (Translation[Config.Translation].VendingMachine..' ['..TableV["name"]..']'),align    = 'center',elements = elements}, function(data, menu)
    if data.current.value == "withdraw" then
      TriggerServerEvent("vending:withdraw",TableV["name"])
      menu.close()
    elseif data.current.value == "sellitem" then
      SellItemMenu(TableV)
    elseif data.current.value == "managment" then
      ItemManagmentMenu(TableV)
    end
	end, function(data, menu)
		menu.close()
	end)
end

function SellItemMenu(TableV)
	local elements = {}

	for k,v in ipairs(PlayerData.inventory) do
		if v.count > 0 then
      table.insert(elements, {
        label = v.label.." [x"..v.count.."]",
        value = v.name,
      })
		end
	end

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'sellitem', 
	{title    = (Translation[Config.Translation].VendingMachine..' ['..TableV["name"]..']'),align    = 'center',elements = elements}, function(data, menu)
      item = data.current.value
        ESX.UI.Menu.Open("dialog",GetCurrentResourceName(),"howmuch",{title = Translation[Config.Translation].ItemCountToSell},function(data2, menu2)
          count = data2.value
              ESX.UI.Menu.Open("dialog",GetCurrentResourceName(),"price",{title = Translation[Config.Translation].PriceForItem},function(data3, menu3)
                price = data3.value
                TriggerServerEvent("vending:sellitem",item,count,price, TableV["name"])
                menu3.close()
              end,
                function(_, menu3)
                menu3.close()
              end)

        menu2.close()
      end,
        function(_, menu2)
        menu2.close()
      end)

	  end, function(data, menu)
	  	menu.close()
	  end)
end

function ItemManagmentMenu(TableV)
  elements = {}
	for k,v in ipairs(TableV["items"]) do
		if v["itemcount"] > 0 then
      table.insert(elements,{label = v["itemlabel"].." [x"..v["itemcount"].."]",value = v["itemname"],})
		end
  end

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'managmentitem', 
    {title    = (Translation[Config.Translation].VendingMachine..' ['..TableV["name"]..']'),align    = 'center',elements = elements}, function(data, menu)
      item = data.current.value
      local elements2 = {
        {label = (Translation[Config.Translation].DeleteItemFromVendingMachine), value = 'delete'},
        {label = (Translation[Config.Translation].ChangeItemPrice), value = 'changeprice'},
      }
      ESX.UI.Menu.CloseAll()
      ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'itemmodification', 
      {title    = (Translation[Config.Translation].VendingMachine..' ['..TableV["name"]..']'),align    = 'center',elements = elements2}, function(data2, menu2)
        if data2.current.value == "delete" then
          TriggerServerEvent("vending:deleteItem",item,TableV["name"])
          menu2.close()
        elseif data2.current.value == "changeprice" then
          ESX.UI.Menu.Open("dialog",GetCurrentResourceName(),"newprice",{title = Translation[Config.Translation].NewPriceForEach},function(data3, menu3)
            TriggerServerEvent("vending:changeprice",item,data3.current.value,TableV["name"])
            menu3.close()
          end,
            function(_, menu3)
            menu3.close()
          end)
        end
      end, function(data2, menu2)
        menu2.close()
      end)

    end, function(data, menu)
      menu.close()
    end)
end

function ClientMenu(TableV)
  elements = {}
	for k,v in ipairs(TableV["items"]) do
		if v["itemcount"] > 0 then
      table.insert(elements,{label = v["itemlabel"].." [x"..v["itemcount"].."]",value = v["itemname"],})
		end
  end

  ESX.UI.Menu.CloseAll()
  ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'managmentitem', 
  {title    = (Translation[Config.Translation].VendingMachine..' ['..TableV["name"]..']'),align    = 'center',elements = elements}, function(data, menu)
    item = data.current.value
    ESX.UI.Menu.Open("dialog",GetCurrentResourceName(),"buycount",{title = Translation[Config.Translation].ItemBuyCount},function(data2, menu2)
        TriggerServerEvent("vending:buyitem",item,data2.current.value,TableV["name"])
      menu2.close()
    end,
      function(_, menu2)
      menu2.close()
    end)

  end, function(data, menu)
    menu.close()
  end)  

end

local function notify(text)
  ESX.ShowNotification(text)
end

--[[
  THREADS
--]]

CreateThread(function()
  while true do
    Wait(2000)
    PlayerData = ESX.GetPlayerData()
  end
end)

CreateThread(function()
  Found = {}
  while true do
    for a,b in pairs(Config.VendingMachines) do
      local entity = GetClosestObjectOfType(b, 1.0, 1114264700, false, false, false)
      if entity ~= nil then -- DoesEntityExist(entity)
        local EntityCoords = GetEntityCoords(entity)
        Found[a] = EntityCoords
      end
    end
    Wait(2000)
  end
end)

CreateThread(function()
  while true do
    pid = PlayerPedId()
    PlayerCoords = GetEntityCoords(pid)
    Wait(2000)
  end
end)

CreateThread(function()
  while true do
    Wait(5)
    for a,b in pairs(Found) do
      Wait(40)
      if #(PlayerCoords-b) < 2.0 then
        inMarker = a
        ESX.ShowHelpNotification(Translation[Config.Translation].PressToOpen)
        break
      else
        inMarker = false
      end
    end
  end
end)

--[[
  EVENTS
--]]

RegisterNetEvent("vending:menu",function(menutype,which)
  if menutype == "buy" then
    BuyMenu(which)
  elseif menutype == "manage" then
    ManageMenu(which)
  elseif menutype == "client" then
    ClientMenu(which)
  end
end)

RegisterNetEvent("vending:notify",function(text)
  notify(text)
end)

RegisterNetEvent("vending:updateBlip",function(Table)
  for a in pairs(Table) do
    AddTextEntry(a, Translation[Config.Translation].VendingMachine.." "..tostring(a))
    local BlipCoords = Config.VendingMachines[a]
    local blipHandler = AddBlipForCoord(BlipCoords)
    BeginTextCommandSetBlipName(a)
    AddTextComponentSubstringPlayerName('me')
    EndTextCommandSetBlipName(blipHandler)
  end
end)

--[[
  COMMANDS
--]]

RegisterCommand("+openvendingmenu",function()
		if inMarker then
			TriggerServerEvent("vending:open",inMarker)
		end
end,false)

RegisterKeyMapping("+openvendingmenu",Translation[Config.Translation].BindDescription,"KEYBOARD","E")
