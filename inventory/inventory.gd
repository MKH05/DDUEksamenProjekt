extends Resource

class_name inv

signal update

@export var slots: Array[InvSlot]

func insert(item: InvItem) -> bool:
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if !itemslots.is_empty():
		itemslots[0].amount += 1
		update.emit()
		return true
	else:
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			emptyslots[0].amount = 1
			update.emit()
			return true
		else:
			return false

func remove(item: InvItem) -> bool:
	for slot in slots:
		if slot.item == item and slot.amount > 0:
			slot.amount -= 1
			if slot.amount <= 0:
				slot.item = null
				slot.amount = 0
			update.emit()
			return true
	return false
