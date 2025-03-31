extends PanelContainer
var old_text:String 
@onready var numberInput:LineEdit = $MarginContainer/VBoxContainer/TextEdit

var ricePrice:int = 20
var riceBought:int

var lineEditLenght:int

func _ready() -> void: 
	print(InventoryManager.riceCount)
	
func _process(delta: float) -> void:
	numberInput.caret_column = lineEditLenght
	var maxItemCanBuy:int = InventoryManager.money / ricePrice
	if int(numberInput.text) > maxItemCanBuy:
		if riceBought == maxItemCanBuy:
			print("Return to dust")
			return
		numberInput.text = str(maxItemCanBuy)
		riceBought = int(numberInput.text)

func _on_text_edit_text_changed(new_text: String) -> void:
	if new_text.is_empty() or new_text.is_valid_int():  # Allow empty or valid integers
		old_text = new_text
	else:
		numberInput.text = old_text  # Revert to the last valid input
	riceBought = int(old_text)
	lineEditLenght = new_text.length()

func _on_confirm_pressed() -> void:
	var cropProduct = riceBought * ricePrice
	print("Crop product: " + str(cropProduct))
	if cropProduct <= InventoryManager.money:
		print("Crop bought")
		InventoryManager.money -= cropProduct
		InventoryManager.riceCount += riceBought
		print(InventoryManager.riceCount)
		queue_free()
	print("Test button confirm")
	pass # Replace with function body.

func _on_cancel_pressed() -> void:
	queue_free()
