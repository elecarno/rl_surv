extends Node

# can be used to calculate temperature at altitude
# TO-DO: 
# temp day sea: 13-15
# temp night sea: 10-12
# temp day 785m: 9-10
# temp night 785m: 5-6
var temp_sea: float = 14.0 # between 8C and 15C
var TEMP_SEA_DEFAULT: float = 15.0
var temp_alt: float = 15.0 # temp at player's altitude

var player_alt: float = 0

# clear, rain_light, rain_heavy, rain_torrential, fog, hail, lightning
var weather_current: String = "clear"

var wind_speed: float = 0.0 # m/s
var wind_dir: int = 180 # compass bearing


var TIME_SCALE = 2 # 2 seconds per in-game minute, resulting in a 12 minute day
var tick = 0
var time = 0
var daynight_tick = 0

# updating references for time values
var minute_ref: int
var hour_ref: int
var day_ref: int

func _process(delta: float) -> void:
	# TIME -----------------------------------------------------------------------------------------
	# updates global references for time values
	minute_ref = int(tick) % 60
	hour_ref = int(tick/60) % 24
	day_ref = int(tick/60/24)
	
	time += delta * TIME_SCALE
	tick = floor(time) + 1440 + 720 # 1 day = 1440 minutes, + 720 to start at midday
	
	# night to day = 08:00 to 11:00
	# day to night = 17:00 to 21:00
	var current_hour = int(tick/60) % 24
	if current_hour > 7 and current_hour < 12:
		if daynight_tick < 1.0:
			daynight_tick += (delta * TIME_SCALE)/180
			#canvas_modulate.color = NIGHT_COLOUR.lerp(DAY_COLOUR, daynight_tick)
			#ui_modulate.color = NIGHT_COLOUR_UI.lerp(DAY_COLOUR_UI, daynight_tick)
	elif current_hour > 16 and current_hour < 22:
		if daynight_tick < 1.0:
			daynight_tick += (delta * TIME_SCALE)/240
			#canvas_modulate.color = NIGHT_COLOUR.lerp(DAY_COLOUR, 1.0 - daynight_tick)
			#ui_modulate.color = NIGHT_COLOUR_UI.lerp(DAY_COLOUR_UI, 1.0 - daynight_tick)
	else:
		daynight_tick = 0
		
	# dev tools - time warp
	if Input.is_action_just_pressed("debug_time"):
		if TIME_SCALE == 2:
			TIME_SCALE = 500
		else:
			TIME_SCALE = 2
			
	# TEMPERATURE ----------------------------------------------------------------------------------
	var temp_time_modifier = abs((5 * sin(tick * PI/1440))) - 5 # cyclical drop by 5C every midnight
	temp_alt = temp_sea - (0.005 * player_alt) # -5C drop per 1km alt
	temp_alt += temp_time_modifier
	
func format_time():
	#return "Day %01d, %02d:%02d\ngametick: %02d\ngametime:%5.1f\ndaynight:%5.5f" % [days, hours, minutes, tick, time, daynight_tick]
	return "Day %01d, %02d:%02d" % [day_ref, hour_ref, minute_ref]
