extends CollectibleItem

export(int) var VALUE = 1


func collect():
	var data = .collect()
	data["value"] = VALUE
	return data
