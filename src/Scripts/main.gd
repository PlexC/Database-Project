extends Control

@onready var mini_game: Control = $MiniGame
@onready var library: Control = $Library
@onready var settings: Control = $Settings
@onready var menu_manager: MenuManager = $MenuManager
@onready var settings_b: TextureButton = $VBoxContainer/Menus/MarginContainer/VBoxContainer/HBoxContainer/SettingsB

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	close(mini_game)
	close(library)
	close(settings)
	# Set up the Tree to look like a spreadsheet
	setup_spreadsheet()
	http_request.request_completed.connect(_on_request_completed)
	#fetch data at startup
	fetch_database_data()
	


#region //NavBar for Options

func _on_settings_b_pressed() -> void:
	menu_manager.open_menu(settings,settings_b)
	

func _on_close_set_b_pressed() -> void:
	menu_manager.close_menu()

func _on_save_b_pressed() -> void:
	SaveManager.create_new_save()
	pass

func _on_load_b_pressed() -> void:
	
	pass

#endregion

#region //open close logic
func open(node) -> void:
	node.visible = true

func close(node) -> void:
	node.visible = false

func toggle(node) -> void:
	if node.visible == true:
		close(node)
	else:
		open(node)
#endregion

#region //menu tree logic
# Connect these to your actual nodes based on your Scene Tree
@onready var tree = $VBoxContainer/Menus/MarginContainer/VBoxContainer/HBoxContainer2/DataSpreadsheet
@onready var search_input = $VBoxContainer/Menus/MarginContainer/VBoxContainer/HBoxContainer2/SortBox/SearchInput
@onready var sort_filter = $VBoxContainer/Menus/MarginContainer/VBoxContainer/HBoxContainer2/SortBox/SortFilter
@onready var http_request = $HTTPRequest

var current_genre = ""
var current_os = ""

	

func setup_spreadsheet():
	tree.columns = 5
	tree.set_column_title(0, "Title")
	tree.set_column_title(1, "Price")
	tree.set_column_title(2, "Score")
	tree.set_column_title(3, "Reviews")
	tree.set_column_title(4, "Release")
	tree.set_column_expand_ratio(0, 3) 
	tree.hide_root = true
	tree.column_titles_visible = true

# Call this from your SearchInput's 'text_submitted' signal, or a Search Button
func fetch_database_data():
	var query = search_input.text.uri_encode()
	
	var sort_mode = "Popularity" #defualt
	var sort_id = sort_filter.get_selected_id()
	
	if sort_id != -1:
		sort_mode = sort_filter.get_item_text(sort_id).uri_encode()
	
	var url = "http://127.0.0.1:8000/games/search?query=" + query + "&genre=" + current_genre + "&os=" + current_os + "&sort=" + sort_mode
	http_request.request(url)

# Call these functions from your GridContainer UI Button 'pressed' signals
func _on_action_button_pressed(): set_genre_and_search("Action")
func _on_rpg_button_pressed(): set_genre_and_search("RPG")
func _on_windows_button_pressed(): set_os_and_search("windows")
# ... repeat for your other buttons

func set_genre_and_search(genre: String):
	current_genre = genre
	fetch_database_data()

func set_os_and_search(os_name: String):
	current_os = os_name
	fetch_database_data()

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		
		if response.status == "success" and response.data != null:
			tree.clear()
			var root = tree.create_item()
			for game in response.data:
				var row = tree.create_item(root)
				
				# Null-safe price check
				var price = "Free"
				if game["mat_initial_price"] != null and game["mat_initial_price"] > 0:
					price = "$" + str(game["mat_initial_price"] / 100.0)
				
				# Null-safe strings for the other columns
				var game_name = str(game["name"]) if game["name"] != null else "Unknown"
				var score = str(game["metacritic_score"]) if game["metacritic_score"] != null else "N/A"
				var reviews = str(game["recommendations_total"]) if game["recommendations_total"] != null else "0"
				var release = str(game["release_date"]) if game["release_date"] != null else "TBD"
				
				row.set_text(0, game_name)
				row.set_text(1, price)
				row.set_text(2, score)
				row.set_text(3, reviews)
				row.set_text(4, release)
#endregion

#region //

#endregion
