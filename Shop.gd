extends Control

onready var button1 = $PocketDagger
onready var button2 = $EnchFeather
onready var button3 = $AncientRune
onready var item1 = get_node("PocketDagger/item1")
onready var item2 = get_node("EnchFeather/item2")
onready var item3 = get_node("AncientRune/item3")
onready var soldout1 = $SoldOut1
onready var soldout2 = $SoldOut2
onready var soldout3 = $SoldOut3
var sellOut = load("res://Assets/Shop/SellOut.png")
onready var price1 = get_node("PocketDagger/item1/VBoxContainer/HBoxContainer/price")
onready var price2 = get_node("EnchFeather/item2/VBoxContainer/HBoxContainer/price")
onready var price3 = get_node("AncientRune/item3/VBoxContainer/HBoxContainer/price")
func _ready():
	price1.text = "$ 25"
	price2.text = "$ 50"
	price3.text = "$ 75"
	if GlobalVar.pocketDagger == "Inv2":
		button1.visible = false
		soldout1.visible = true
	if GlobalVar.enchFeather == "Inv3":
		button2.visible = false
		soldout2.visible = true
	if GlobalVar.regenStone == "Inv5":
		button3.visible = false
		soldout3.visible = true
	pass

func _on_PocketDagger_pressed():
	GlobalVar.firstmemberlife = 50
	print(str(GlobalVar.firstmemberlife))
	if not item1.is_visible():
		item1.show()
		item2.hide()
		item3.hide()
	else:
		item1.hide()
	

func _on_EnchFeather_pressed():
	if not item2.is_visible():
		item1.hide()
		item2.show()
		item3.hide()
	else:
		item2.hide()


func _on_AncientRune_pressed():
	if not item3.is_visible():
		item1.hide()
		item2.hide()
		item3.show()
	else:
		item3.hide()


func _on_exit_pressed():
	get_tree().change_scene("res://Gui.tscn")


func _on_Button_pressed():
	if GlobalVar.gold >= 25:
		GlobalVar.gold -= 25
		GlobalVar.pocketDagger = "Inv2"
		InventoryData.item_data["Inv2"] = TrinketsData.item_data["Inv2"]
		trinket("attacco base","Inv2")
		$PocketDagger.texture_normal = sellOut
		$PocketDagger.disabled = true
		$PocketDagger/item1/VBoxContainer/HBoxContainer/Button.disabled = true
		item1.hide()
		soldout1.visible = true

func _on_Button2_pressed():
	if GlobalVar.gold >= 50:
		GlobalVar.gold -= 50
		GlobalVar.enchFeather = "Inv3"
		InventoryData.item_data["Inv3"] = TrinketsData.item_data["Inv3"]
		trinket("velocità","Inv3")
		$EnchFeather.texture_normal = sellOut
		$EnchFeather.disabled = true
		$EnchFeather/item2/VBoxContainer/HBoxContainer/Button2.disabled = true
		item2.hide()
		soldout2.visible = true

func _on_Button3_pressed():
	if GlobalVar.gold >= 75:
		GlobalVar.gold -= 75
		GlobalVar.regenStone = "Inv5"
		InventoryData.item_data["Inv5"] = TrinketsData.item_data["Inv5"]
		trinket("vita","Inv5")
		$AncientRune.texture_normal = sellOut
		$AncientRune.disabled = true
		$AncientRune/item3/VBoxContainer/HBoxContainer/Button3.disabled = true
		item3.hide()
		soldout3.visible = true

func trinket(stats : String, trink : String):
	if trink in TrinketsData.item_data and "Multiplier" in TrinketsData.item_data[trink]:
		var multiplier: float = float(TrinketsData.item_data[trink]["Multiplier"])
		CharactersData.ch_data[GlobalVar.firstmember][stats] = str(float(CharactersData.ch_data[GlobalVar.firstmember][stats]) * multiplier)
		if GlobalVar.secondmember != "none":
			CharactersData.ch_data[GlobalVar.secondmember][stats] = str(float(CharactersData.ch_data[GlobalVar.secondmember][stats]) * multiplier)
		if GlobalVar.thirdmember != "none":
			CharactersData.ch_data[GlobalVar.thirdmember][stats] = str(float(CharactersData.ch_data[GlobalVar.thirdmember][stats]) * multiplier)
	print(str(GlobalVar.firstmemberlife))
