extends CanvasLayer


@onready var timer_label: Label = $Timer


func set_timer_label(time_left: float):
	timer_label.text = "%s" % snapped(time_left, 0.01)
