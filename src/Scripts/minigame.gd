extends Control

@onready var plate: TextureRect = $Gameplay/VBoxContainer/HBoxContainer2/Plate
@onready var score_label = $HighScore/Label
@onready var http_request = $HTTPRequest

# We will randomly pick from these genres for the 10 food items
#TODO add rest of gen
var available_genres = ["Action", "RPG", "Strategy", "Indie", "Simulation", "Racing", "Sports", "Adventure", "Casual", "Massively Multiplayer"]
var current_plate_ingredients = []

func _ready():
	http_request.request_completed.connect(_on_request_completed)
	setup_foods()
	setup_plate()

func setup_foods():
	# Automatically find all 10 Food buttons and make them draggable
	var all_foods = $Gameplay/VBoxContainer/HBoxContainer.get_children() + $Gameplay/VBoxContainer/HBoxContainer2.get_children() + $Gameplay/VBoxContainer/HBoxContainer2/VBoxContainer2.get_children()
	
	for i in range(all_foods.size()):
		var food_node = all_foods[i]
		if food_node is TextureButton:
			var assigned_genre = available_genres[i % available_genres.size()]
			food_node.set_meta("genre", assigned_genre)
			
			# Dynamically override the node's get_drag_data function
			food_node.set_drag_forwarding(Callable(), self._custom_get_drag_data.bind(food_node), Callable())

func setup_plate():
	# Allow the plate to accept drops
	plate.set_drag_forwarding(Callable(), self._custom_drop_data.bind(plate), self._custom_can_drop_data.bind(plate))

# --- DRAG AND DROP LOGIC ---

func _custom_get_drag_data(at_position: Vector2, food_node: TextureButton):
	var preview = TextureRect.new()
	preview.texture = food_node.texture_normal
	set_drag_preview(preview)
	return {"genre": food_node.get_meta("genre")}

func _custom_can_drop_data(at_position: Vector2, data: Variant, plate_node: TextureRect) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("genre")

func _custom_drop_data(at_position: Vector2, data: Variant, plate_node: TextureRect):
	current_plate_ingredients.append(data["genre"])
	
	# Change color slightly to show food was added
	plate_node.modulate = Color(randf(), randf(), randf()) 
	score_label.text = "Added: " + data["genre"]
	
	if current_plate_ingredients.size() >= 2:
		cook_game()

# --- SQL API CALL ---

func cook_game():
	score_label.text = "Cooking algorithm..."
	var ing1 = current_plate_ingredients[0].uri_encode()
	var ing2 = current_plate_ingredients[1].uri_encode()
	
	var url = "http://127.0.0.1:8000/minigame/cook?ingred_1=" + ing1 + "&ingred_2=" + ing2 + "&price=999"
	http_request.request(url)
	
	current_plate_ingredients.clear() # Reset plate for next attempt

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		
		if response.status == "success" and response.data != null:
			var score = response.data["score"]
			var high_score = response.data["high_score"]
			score_label.text = "HIGHSCORE: " + str(high_score) + "\nLast Dish: " + str(score)
