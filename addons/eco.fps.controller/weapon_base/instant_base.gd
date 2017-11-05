
extends "abstract_base.gd"

var sfx_class=preload("res://addons/eco.fps.controller/explosions/SpacialSoundEffect.tscn")

const SPLIT_STEP=PI/64

onready var ray=get_node("direction/RayCast")
onready var direction=get_node("direction")
var subrays=[]
onready var sfx=get_node("sfx")

onready var explosion_class=null

var power=1
var velocity=Vector3()

var muere = false

func set_owner(value):
	.set_owner(value)
	power=5
	cartridge_capacity=data.bullet_pool_capacity
	ray.add_exception_rid(owner)

func shoot():
	if cartridge_capacity>0 and remaining_bullets<=0:
		return false
	
	var special=false
	if explosion_class != null and randi()%data.get_modifier("attack.elemental_chance") ==0 :
		special=true
	
	sfx.play(bullet_factory.get_shoot_sound(1,data.bullet_type,data.bullet_shape))
	
	_shoot_ray(ray,special)
	for r in subrays:
		_shoot_ray(r,special)
	
	if cartridge_capacity>0:
		remaining_bullets-=1
		data.notify_attribute_change("nb_bullets",remaining_bullets)
		data.notify_ammo_used()
	
	return true

func _shoot_ray(r,special):
	if r.is_colliding():
		var object=r.get_collider()
		#var grupo = object.get_group()
		var p=r.get_collision_point()
		
		print("impacto")
		

		#print(Object.get_groups())
		print(object.get_name())
		if (object.get_name() == "colimalo"):
			print(object)
#			print(p.x - object.get_translation().x)
#			print(p - object.get_translation())
#			print ("este",object.get_global_transform())
			var distancia
			distancia = p - object.get_translation()
			var modulo = sqrt(distancia.x*distancia.x+distancia.y*distancia.y+distancia.z*distancia.z)
			
			var distancia_player = Vector3()
			#distancia_player = p - GDsingleton.dista
			distancia_player = p - GDsingleton.posicionPayo
			GDsingleton.distanciaPayo = sqrt(distancia_player.x*distancia_player.x+distancia_player.y*distancia_player.y+distancia_player.z*distancia_player.z)
			print("ver" + str(distancia_player))
			#GDsingleton.puntos += GDsingleton.distanciaPayo*3 +(1/(GDsingleton.distaCentro+1))*50
			print("distancia objeto",distancia.x)
#			print("distancia objeto",distancia)
			print("modulo a objeto",modulo)
			GDsingleton.distaCentro = modulo
			print("sigle distaciaDC", str(GDsingleton.distaCentro))
			#GDsingleton.puntos += 10
			print("ver el nombre impacto:")
			print(object.get_name())
			print("ver el nombre impacto el padre:")
			print(object.get_parent())
			muere = true
			
			
			
		
		if object.has_method("hit"):
			object.hit(self,special)
		print("pasa por aqui")
		if muere == true:
			GDsingleton.puntos += 10
			muere = false
			object.get_parent().free()
		var instance=bullet_factory.get_impact(data.bullet_type,data.bullet_shape)  
		instance.set_translation(p)
		owner.get_parent_spatial().add_child(instance)
		if special :
			var explosion=explosion_class.instance()
			explosion.owner=owner
			var t=Transform()
			t.origin=p
			explosion.set_transform(t)
			explosion.rescale(0.2*data.get_modifier("attack.size"))
			owner.get_parent_spatial().add_child(explosion)
			
			var sound_name=bullet_factory.get_impact_sound(1,data.bullet_type,data.bullet_shape,data.get_modifier("attack.elemental_impact"),true)
			if sound_name!=null:
				var sfx=sfx_class.instance()
				owner.get_parent_spatial().add_child(sfx)
				sfx.set_global_transform(t)
				sfx.set_sample_library(self.sfx.get_sample_library())
				sfx.play_sound(sound_name)


func reset():
	.reset()
	explosion_class=bullet_factory.get_impact_explosion_class(data.get_modifier("attack.elemental_impact"))
	var i=subrays.size()

	var is_right=true
	var delta_angle=-i/2*SPLIT_STEP

	while i<data.get_modifier("attack.split_factor"):
		if is_right:
			delta_angle=-delta_angle+SPLIT_STEP
		else:
			delta_angle=-delta_angle
		is_right=!is_right
		
		var r=RayCast.new()
		subrays.append(r)
		i+=1
		r.set_cast_to(Vector3(0,0,-1000))
		r.set_enabled(true)
		r.set_layer_mask(ray.get_layer_mask())
		r.add_exception_rid(owner)
		direction.add_child(r)
		r.rotate_y(delta_angle)

	if data.get_modifier("attack.autoaim") or data.get_modifier("projectile.homing"):
		set_process(true)
	else:
		set_process(false)
		direction.set_transform(Transform())

func _process(delta):
	if owner.current_target!=null:
		var t=direction.get_global_transform()
		direction.set_global_transform(t.looking_at(owner.current_target.get_global_transform().origin,Vector3(0,1,0)))
	else:
		direction.set_transform(Transform())

func set_sample_library(lib):
	sfx.set_sample_library(lib)
