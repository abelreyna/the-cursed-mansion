extends PointLight2D
signal light_state_changed(is_on)

# Propiedad exportada que controla si la luz está visible o no. Inicialmente está encendida (true).
@export var _is_visible: bool = true:
	# Setter que se llama cuando se asigna un nuevo valor a _is_visible.
	set(value):
		_is_visible = value  # Asigna el nuevo valor a la variable interna.
		visible = value  # Cambia la visibilidad del PointLight2D (encendido/apagado).
		emit_signal("light_state_changed", _is_visible)  # Emite la señal indicando el nuevo estado de la luz.

	# Getter que se llama cuando se accede al valor de _is_visible.
	get:
		return _is_visible  # Devuelve el valor actual de _is_visible.

# Método para alternar la visibilidad de la luz.
func toggle_visibility() -> void:
	self._is_visible = not _is_visible  # Cambia el estado de _is_visible al opuesto (encendido/apagado).
	# Al asignar un nuevo valor, se llamará automáticamente al setter, lo que cambiará la visibilidad y emitirá la señal.
