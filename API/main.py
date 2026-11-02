from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import mysql.connector

app = FastAPI()

# Allow Godot to communicate with this API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Replace with your actual MySQL Workbench password
db_config = {
    "host": "localhost",
    "user": "root",
    "password": "password", 
    "database": "SteamDB"
}

def execute_procedure(proc_name, args=()):
    """Helper function to run MySQL procedures and fetch results cleanly"""
    try:
        conn = mysql.connector.connect(**db_config)
        cursor = conn.cursor(dictionary=True)
        cursor.callproc(proc_name, args)
        conn.commit()
        
        result = []
        for output in cursor.stored_results():
            result = output.fetchall()
            
        cursor.close()
        conn.close()
        return result
    except mysql.connector.Error as err:
        raise HTTPException(status_code=500, detail=str(err))

# 1. Insert Game
@app.post("/games/add")
def insert_game(appid: int, name: str, price: int, is_free: str):
    data = execute_procedure('InsertGame', (appid, name, price, is_free))
    return {"status": "success", "data": data}

# 2. Delete Game
@app.delete("/games/delete/{appid}")
def delete_game(appid: int):
    data = execute_procedure('DeleteGame', (appid,))
    return {"status": "success", "data": data}

# 3. Search and Sort (Updated for full UI integration)
@app.get("/games/search")
def search_games(query: str = "", genre: str = "", os: str = "", sort: str = "Popularity"):
    data = execute_procedure('SearchGames', (query, genre, os, sort))
    return {"status": "success", "data": data}

# 4. Toggle Favorite (Add/Remove from Library)
@app.post("/library/toggle/{appid}")
def toggle_favorite(appid: int):
    data = execute_procedure('ToggleFavorite', (appid,))
    return {"status": "success", "data": data}

# 5. View Favorites Library
@app.get("/library")
def get_library():
    data = execute_procedure('GetLibrary')
    return {"status": "success", "data": data}

# 6. Minigame: Cook Indie Game
@app.get("/minigame/cook")
def cook_game(ingred_1: str, ingred_2: str, price: int):
    data = execute_procedure('CookIndieGame', (ingred_1, ingred_2, price))
    return {"status": "success", "data": data[0] if data else None}

if __name__ == "__main__":
    import uvicorn
    # Runs the server on port 8000
    uvicorn.run(app, host="127.0.0.1", port=8000)