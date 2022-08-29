Translation = {}
Config = {}

-- [COORDS OF VENDINGS] --
Config.VendingMachines = {
  ["AutomatLS1"] = vector3(1193, 2702, 38),
  ["AutomatLS2"] = vector3(549,2674,42),
}

-- [PRICE FOR BUYING] --
Config.Price = 50000

-- [AVAILABLE LANGUAGES] --
-- PL, EN
Config.Translation = "PL"

Translation["PL"] = {
	PressToOpen = "Naciśnij ~INPUT_CONTEXT~ aby otworzyć menu",
  BindDescription = "Otwórz menu automatu",
  VendingMachine = "Automat",
  BuyVendingMachine = "Zakup automat",
  YouDontHaveMoney = "Nie masz wystarczająco pieniędzy",
  BoughtMachine = "Zakupiłeś automat",
  Withdraw = "Wypłać",
  NoMoneyInVending = "Nie masz czego wypłacić",
  YouWithdrawed = "Wypłaciłeś $",
  SellItem = "Sprzedaj przedmiot",
  ItemCountToSell = "Ile chcesz sprzedać?",
  PriceForItem = "Jaka jest cena za jeden przedmiot?",
  YouDontHaveThatMuchItems = "Nie masz wystarczająco przedmiotów",
  YouPutItemsInStock = "Wsadziłeś przedmiot/y do automatu",
  ItemManagment = "Zarządzaj przedmiotami",
  DeleteItemFromVendingMachine = "Usun ze sprzedaży",
  ChangeItemPrice = "Zmień cenę przedmiotu",
  NewPriceForEach = "Nowa cena za przedmiot",
  YouTakeItemFromShop = "Wyciągnąłeś przedmiot z automatu",
  YouChangedPrice = "Zmieniłeś cene przedmiotu",
  YouBoughtItem = "Zakupiłeś ",
  SmthWrong = "Coś poszło nie tak, spróbuj ponownie",
  ItemBuyCount = "Ile chcesz kupić?",
  NoItemsInStock = "Nie ma tyle przedmiotów w automacie",
}

Translation["EN"] = {
	PressToOpen = "Press ~INPUT_CONTEXT~ to open menu",
  BindDescription = "Open vending machine menu",
  VendingMachine = "Vending Machine",
  BuyVendingMachine = "Buy Vending Machine",
  YouDontHaveMoney = "You don't have money to buy it",
  BoughtMachine = "You bought vending machine",
  Withdraw = "Withdraw",
  NoMoneyInVending = "There is no money to withdraw",
  YouWithdrawed = "You withdrawed $",
  SellItem = "Sell item",
  ItemCountToSell = "How much you want to sell?",
  PriceForItem = "What is the price for each item?",
  YouDontHaveThatMuchItems = "You don't have that much items",
  YouPutItemsInStock = "You put items in a stock",
  ItemManagment = "Item managment",
  DeleteItemFromVendingMachine = "Delete item from vending machine",
  ChangeItemPrice = "Change item price",
  NewPriceForEach = "New price for item",
  YouTakeItemFromShop = "You delete item from vending machine",
  YouChangedPrice = "You set new price for item",
  YouBoughtItem = "You bought ",
  SmthWrong = "Something gone wrong, try again",
  ItemBuyCount = "How much you want to buy?",
  NoItemsInStock = "There is no that much items in vending machine",
}
