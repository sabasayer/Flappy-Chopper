extends Node

var store :Dictionary[String,Variant] = {}

func log_on_change_value(key:String,value):
	var prev_value = store.get(key)
	if(!key || prev_value != value):
		print(key+" : "+ str(value))
		store.set(key,value)
