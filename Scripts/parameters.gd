extends Node


var nul = {"moonwalk_bool": false, "sounds_bool": true, "music_bool": true, "car_active": false,
			"number_anim_type": 0, "money": 0, "magazin_count": 0, "magazins_capacity": 2,
			"buckets_count": 0, "buckets_capacity": 2, "litrs_count": 10, "litrs_capacity": 60,
			"buckets_in_car": 0, "beekeeper_speed": 100, "bagaj_capacity": 2, "car_speed": 500,
			"torg_time": 0.1, "work_time": 0.2, "print_time": 0.05, "number_of_uley": 1,
			"full_fill_time": 36, "uley1": 100, "uley2": 5, "uley3": 5, "uley4": 5, "uley5": 5,
			"uley6": 5, "uley7": 5,	"uley8": 5, "uley9": 5, "uley10": 5, "uley11": 5,	"uley12": 5,
			"uley13": 5, "uley14": 5, "uley15": 5, "uley16": 5, "time": 0}
			
var stuff
var over
func _ready():
	var time = OS.get_unix_time()
	var loadFile = File.new()
	var temp
	loadFile.open("user://save.json", File.READ)
	if loadFile.file_exists("user://save.json"):
		temp = parse_json(loadFile.get_as_text())
		stuff = temp
		loadFile.close()
	else:
		stuff = nul
		stuff["time"] = time
	if int(time-$"/root/Parameters".stuff["time"]) >= 432000:
		over = 1
		stuff = nul
	else:
		over = 0 
		
