extends Node

var subs: Dictionary = {}

func subscribe(msg: String, receiver: Callable) -> void:
	if !subs.has(msg):
		subs[msg] = [] as Array[Callable]
	var rx_list: Array[Callable] = subs[msg]
	rx_list.append(receiver)

func dispatch(msg: String, params: Array = []) -> void:
	if !subs.has(msg):
		subs[msg] = [] as Array[Callable]
	var rx_list: Array[Callable] = subs[msg]
	for rx in rx_list:
		rx.call(params)

func dispatch_deferred(msg: String, params: Array = []) -> void:
	if !subs.has(msg):
		subs[msg] = [] as Array[Callable]
	var rx_list: Array[Callable] = subs[msg]
	for rx in rx_list:
		rx.call_deferred(params)
