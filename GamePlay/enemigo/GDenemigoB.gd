extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	if is_colliding():
		print("cuando colisionadddddddddddddddddddd")
	
	print("cuando colisiona")