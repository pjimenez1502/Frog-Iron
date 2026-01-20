extends CharacterInventory
class_name PlayerInventory

var coin: int = 0

func _ready() -> void:
	SignalBus.AddPlayerCoin.connect(add_coin)
	SignalBus.PlayerCoinUpdate.emit(coin)
	
	SignalBus.AddPlayerItem.connect(add_item)
	SignalBus.ItemUsed.connect(use_item)
	#SignalBus.PlayerInventoryDrop.connect(drop_from_inventory)
	
	equip_starting_equipment.call_deferred()

func setup(_character: Character) -> void:
	character = _character
	init_inventory(6)



## ITEM
func add_item(item_data: ItemResource) -> bool:
	var success: bool = super.add_item(item_data)
	update_inventory_call()
	return success

func consume_item(item_slot: int) -> bool:
	var success: bool = super.consume_item(item_slot)
	update_inventory_call()
	return success

## EQUIPMENT
func equip_item(item_slot: int) -> void:
	super.equip_item(item_slot)
	update_inventory_call()



func update_inventory_call() -> void:
	SignalBus.PlayerInventoryUpdate.emit(inventory)
	SignalBus.PlayerEquipmentUpdate.emit(equipment)

## COIN
func add_coin(value: int) -> void:
	coin += value
	SignalBus.PlayerCoinUpdate.emit(coin)

func pay_with_coin(value: int) -> bool:
	if coin >= value:
		add_coin(-value)
		return true
	return false

## AMMO
func get_remaining_ammo(ammo_type: GunResource.AMMO_TYPES) -> int:
	var ammo_count: int
	for pouch: AmmoPouch in get_pouches_of_type(ammo_type):
		ammo_count += pouch.content
	return ammo_count

func update_ammo_call() -> void:
	SignalBus.PlayerAmmoUpdate.emit(ammo_inventory)



@export var starting_equipment: Array[ItemResource]
@export var starting_inventory: Array[ItemResource]
## DEBUG STARTING ITEMS
func equip_starting_equipment() -> void:
	#for item: EquipableResource in starting_equipment:
		#equip_item(item)
	for item: ItemResource in starting_inventory:
		add_item(item)
	update_inventory_call()
	update_ammo_call()
