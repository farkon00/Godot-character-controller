extends Node2D

var translates: Array = []

class Translate:
	var node: Node
	var final: Vector2
	var speed: Vector2

	func _init(_node: Node, _final: Vector2, _time: float = -1, _speed: Vector2 = Vector2(0, 0)):
		self.node = _node
		self.final = _final
		self.speed = _speed

		if _time != -1:
			self.speed = (self.final - self.node.position) / _time
		elif not self.speed:
			push_error("Translate: speed or time is not set")

	func update(delta: float):
		self.node.position += self.speed * delta
		if self.node.position.x > self.final.x and self.node.position.y > self.final.y and self.speed.x >= 0 and self.speed.y >= 0:
			self.node.position = self.final
			return true
		if self.node.position.x > self.final.x and self.node.position.y < self.final.y and self.speed.x >= 0 and self.speed.y <= 0:
			self.node.position = self.final
			return true
		if self.node.position.x < self.final.x and self.node.position.y > self.final.y and self.speed.x <= 0 and self.speed.y >= 0:
			self.node.position = self.final
			return true
		if self.node.position.x < self.final.x and self.node.position.y < self.final.y and self.speed.x <= 0 and self.speed.y <= 0:
			self.node.position = self.final
			return true

func _process(delta):
	for translate in translates:
		if translate.update(delta):
			translates.erase(translate)

func add_translate(_node: Node = null, _final = null, _time: float = -1, _speed: Vector2 = Vector2(0, 0), translate: Translate = null):
	if translate:
		translates.append(translate)
	else:
		if not (_node and _final):
			push_error("Translate: node and final is not set")
		translates.append(Translate.new(_node, _final, _time, _speed))
