extends Node
# precargo
var escenaprePrePaEscribir = preload("res://Menu/EscenaPaEscribir.xml")

#Jugador
var escenaprePrePlayer = preload("res://GamePlay/Sniper.scn")
var juego
#Menu-Manager
var escenapreMenu = preload("res://Menu/EscenaMenu.xml")
var menuActivo = false
var escenaMenu

#panel control
var info1
#relog
var imprimirRelog
var tiempoIniciado = false
var infoEstadoTiempo
var minutosPantalla
var segundosPantalla
var segundos 
var tiempoInicio = 0
var imprimirPuntos
#cuenta a tras
var minutosPantallaCA = 0
var segundosIniciales = 10
var segundosPantallaCA = segundosIniciales
var imprimirCA
var imprimirVida

var imprimeDiana
var imprimeDis


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)
	set_fixed_process(true)
	pass
	
	
func _fixed_process(delta):
	#segundospantalla = segundos -(minutos*60)
	if menuActivo == false:
		print("activo Menu")
		print(OS.get_ticks_msec())
		# meto el nodo de escribir pa poner informacion y comentarios
		escenaMenu = escenapreMenu.instance()
		get_parent().add_child(escenaMenu)
		print("empieza a contar el tiempo")
		menuActivo = true

		
#		info1.set_pos(Vector2(20,20))
#		info1.set_text("Prueba de tiempos")
		
		
	
	if tiempoInicio > 0:
		#relog
		segundos = (((OS.get_ticks_msec()-tiempoInicio)/1000))
		minutosPantalla = segundos / 60
		segundosPantalla = segundos - minutosPantalla*60
		imprimirRelog.set_text("Timer:" + str(minutosPantalla)+ ":" + str(segundosPantalla))
		
		#Cuenta atras
		imprimirCA.set_text("Cuenta a tras:" + str(segundosPantallaCA - segundosPantalla))
		
		imprimeDiana.set_text("distanCentro:" +str(GDsingleton.distaCentro))
		imprimeDis.set_text("distanPayo:" +str(GDsingleton.distanciaPayo))
		imprimirPuntos.set_text("puntokosguenos:" +str(GDsingleton.puntos))
		imprimirVida.set_text("Vidika:" + str(GDsingleton.vida))
		if ((minutosPantallaCA - minutosPantalla) == 0 and segundosPantallaCA - segundosPantalla == 0) or GDsingleton.vida == 0:
			imprimirRelog.free()
			imprimirCA.free()
			juego.free()
			tiempoInicio = -1
			imprimeDiana.free()
			imprimeDis.free()
			imprimirPuntos.free()
			imprimirVida.free()
			info1.set_text("Game Over: " + str(GDsingleton.puntos))
			info1.set_pos(Vector2(200,300))
			info1.set_scale(Vector2(4,4))
			# meto menu
			escenaMenu = escenapreMenu.instance()
			get_parent().add_child(escenaMenu)
			
			
			
			
	
func _input(event):
	
	if event.type == InputEvent.KEY and event.pressed and tiempoInicio == -1:
		minutosPantalla = 0
		segundosPantalla = 0
		segundos = 0
		minutosPantallaCA = 0
		segundosPantalla = 0
		tiempoIniciado = false
		GDsingleton.puntos = 0
		GDsingleton.vida = 10
		info1.free()

	#esto es pa la aumentar la cuenta a atras
#	if event.type == InputEvent.KEY and event.pressed and tiempoIniciado:
#		segundosPantallaCA = segundosPantallaCA + 12
#		print("achoooo")
		
	if event.type == InputEvent.KEY and event.pressed:
		if tiempoIniciado == false:
			print("empieza a contar el tiempo")
			tiempoIniciado = true
			# empiezo a contar tiempo: cojo el teimpo del sistema
			tiempoInicio = OS.get_ticks_msec()
			
			# meto el nodo de escribir pa poner informacion y comentarios
			info1 = escenaprePrePaEscribir.instance()
			get_parent().add_child(info1)
			info1.set_pos(Vector2(20,20))
			info1.set_text("Sniper Panel Control")
			
			# meto el nodo de escribir pa poner relog
			imprimirRelog = escenaprePrePaEscribir.instance()
			get_parent().add_child(imprimirRelog)
			imprimirRelog.set_pos(Vector2(20,40))
			imprimirRelog.set_text("Timer:" + str(minutosPantalla)+ ":" + str(segundosPantalla))
			
			# meto el nodo de escribir cuenta a a tras
			imprimirCA = escenaprePrePaEscribir.instance()
			get_parent().add_child(imprimirCA)
			imprimirCA.set_pos(Vector2(20,60))
			
			
			# meto el nodo de escribir distancia a centro
			imprimeDiana = escenaprePrePaEscribir.instance()
			get_parent().add_child(imprimeDiana)
			imprimeDiana.set_pos(Vector2(20,80))
			imprimeDiana.set_text(str(GDsingleton.distaCentro))
			
			# meto el nodo de escribir distancia al payo
			imprimeDis = escenaprePrePaEscribir.instance()
			get_parent().add_child(imprimeDis)
			imprimeDis.set_pos(Vector2(20,100))
			imprimeDis.set_text(str(GDsingleton.distanciaPayo))
			
			# meto el nodo de escribir imprimirPuntos
			imprimirPuntos = escenaprePrePaEscribir.instance()
			get_parent().add_child(imprimirPuntos)
			imprimirPuntos.set_pos(Vector2(20,120))
			imprimirPuntos.set_text(str(GDsingleton.puntos))
			
			# meto el nodo de escribir la vida
			imprimirVida = escenaprePrePaEscribir.instance()
			get_parent().add_child(imprimirVida)
			imprimirVida.set_pos(Vector2(20,140))
			
			imprimirVida.set_text(str(GDsingleton.vida))
			# meto el gameplay
			juego = escenaprePrePlayer.instance()
			get_parent().add_child(juego)
			#imprimirCA.set_pos(Vector2(20,60))
			
			escenaMenu.free()
			imprimirCA.set_text("Sniper Panel Control")
			
			segundosPantallaCA = segundosIniciales
			print("pongo el nodo pa escribir")
		
		print("toque teclado")

#		relog.set_text("Timer:" + str(minutos)+ ":" + str(segundos))