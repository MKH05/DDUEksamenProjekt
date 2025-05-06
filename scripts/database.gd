extends Node

const SAVEFILE = "user://player_id.save"

var database: SQLite
var player_id: int = 1

func _ready() -> void:
	load_player_id_from_file()
	
	database = SQLite.new()
	database.path = "res://data.db"
	database.open_db()

	create_players_table()
	
	if not load_player_data():
		insert_new_player()
	
	while true:
		save_player()
		await get_tree().create_timer(5.0).timeout

func create_players_table() -> void:
	var sql := """
	CREATE TABLE IF NOT EXISTS players (
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		timeplayed INTEGER,
		resued INTEGER,
		money INTEGER,
		firsttimeplayed INTEGER NOT NULL
	);
	"""
	database.query(sql)

func load_player_data() -> bool:
	var sql := "SELECT id, money, resued, timeplayed FROM players WHERE id = %d;" % player_id
	if not database.query(sql):
		push_error("SQL load failed")
		return false

	var rows: Array = database.query_result
	if rows.size() == 0:
		print("No player with ID", player_id)
		return false

	var row: Dictionary = rows[0]
	player_id = row["id"]
	Globals.money = row["money"]
	Globals.reused = row["resued"]
	Globals.timeplayed = row["timeplayed"]
	print("Loaded player:", player_id)
	return true

func insert_new_player() -> void:
	var sql := """
	INSERT INTO players (timeplayed, resued, money, firsttimeplayed)
	VALUES (0, 999999999, 0, 0);
	"""
	database.query(sql)
	player_id = database.last_insert_rowid
	save_player()
	print("Inserted new player with ID:", player_id)

func save_player() -> void:
	var file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	if file:
		file.store_32(player_id)
		file.close()
		print("Saved player ID:", player_id)
	else:
		push_error("Failed to save player ID to file.")

	var sql := """
	UPDATE players
	SET money = %d,
		resued = %d,
		timeplayed = %d
	WHERE id = %d;
	""" % [Globals.money, Globals.reused, Globals.timeplayed, player_id]

	if not database.query(sql):
		push_error("Failed to save player data to database.")
	else:
		print("Saved player data to database for ID:", player_id)

func load_player_id_from_file() -> void:
	if FileAccess.file_exists(SAVEFILE):
		var file = FileAccess.open(SAVEFILE, FileAccess.READ)
		if file:
			player_id = file.get_32()
			file.close()
			print("Loaded player ID from file:", player_id)
	else:
		print("No saved player ID found. Will create new player.")
	
