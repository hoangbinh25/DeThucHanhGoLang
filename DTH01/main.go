package main

import (
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/websocket"
)

type Game struct {
	Board    [15][15]int       // Bàn cờ: 0=trống, 1=X, 2=O
	Turn     int               // Lượt hiện tại: 1=X, 2=O
	Players  []*websocket.Conn // Danh sách 2 người chơi
	Winner   int               // 0=chưa thắng, 1=X thắng, 2=O thắng
	GameOver bool              // Game kết thúc chưa
}

type Message struct {
	Type string      `json:"type"`
	Data interface{} `json:"data"`
}

var game = &Game{
	Turn:    1,
	Players: make([]*websocket.Conn, 0, 2),
}

var upgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool { return true },
}

// handle websocket
func handleWebSocket(w http.ResponseWriter, r *http.Request) {
	// Upgrade HTTP thành WebSocket
	conn, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("Upgrade failed:", err)
		return
	}
	defer conn.Close()

	// Thêm người chơi
	if len(game.Players) < 2 {
		game.Players = append(game.Players, conn)
		playerID := len(game.Players)

		// Gửi ID cho người chơi mới
		sendMessage(conn, "your_id", playerID)

		// Thông báo cho tất cả
		broadcastMessage("player_count", len(game.Players))
		broadcastMessage("game_state", game)

		fmt.Printf("Người chơi %d đã tham gia\n", playerID)
	} else {
		sendMessage(conn, "error", "Phòng đã đầy!")
		return
	}

	// Lắng nghe tin nhắn từ client
	for {
		var msg Message
		err := conn.ReadJSON(&msg)
		if err != nil {
			// Người chơi disconnect
			removePlayer(conn)
			break
		}

		// Xử lý tin nhắn
		switch msg.Type {
		case "move":
			handleMove(conn, msg.Data)
		case "reset":
			resetGame()
		}
	}
}

// handle move
func handleMove(conn *websocket.Conn, data interface{}) {
	// Tìm người chơi nào đang đánh
	playerID := findPlayerID(conn)
	if playerID == 0 {
		return
	}

	// Kiểm tra lượt
	if game.Turn != playerID || game.GameOver {
		sendMessage(conn, "error", "Không phải lượt của bạn!")
		return
	}

	// Parse tọa độ
	moveData := data.(map[string]interface{})
	row := int(moveData["row"].(float64))
	col := int(moveData["col"].(float64))

	// Kiểm tra ô trống
	if game.Board[row][col] != 0 {
		sendMessage(conn, "error", "Ô này đã có quân!")
		return
	}

	// Đánh quân
	game.Board[row][col] = playerID
	fmt.Printf("Người chơi %d đánh ô (%d,%d)\n", playerID, row, col)

	// Kiểm tra thắng
	if checkWin(row, col, playerID) {
		game.Winner = playerID
		game.GameOver = true
		fmt.Printf("Người chơi %d thắng!\n", playerID)
	} else {
		// Chuyển lượt
		if game.Turn == 1 {
			game.Turn = 2
		} else {
			game.Turn = 1
		}
	}

	// Gửi trạng thái mới cho tất cả
	broadcastMessage("game_state", game)
}

// check win
func checkWin(row, col, player int) bool {
	// 4 hướng kiểm tra: ngang, dọc, chéo chính, chéo phụ
	directions := [][2]int{{0, 1}, {1, 0}, {1, 1}, {1, -1}}

	for _, dir := range directions {
		count := 1 // Đếm quân hiện tại

		// Đếm về 1 phía
		for i := 1; i < 5; i++ {
			newRow := row + i*dir[0]
			newCol := col + i*dir[1]
			if newRow < 0 || newRow >= 15 || newCol < 0 || newCol >= 15 {
				break
			}
			if game.Board[newRow][newCol] == player {
				count++
			} else {
				break
			}
		}

		// Đếm về phía ngược lại
		for i := 1; i < 5; i++ {
			newRow := row - i*dir[0]
			newCol := col - i*dir[1]
			if newRow < 0 || newRow >= 15 || newCol < 0 || newCol >= 15 {
				break
			}
			if game.Board[newRow][newCol] == player {
				count++
			} else {
				break
			}
		}

		// Nếu đủ 5 quân liên tiếp
		if count >= 5 {
			return true
		}
	}
	return false
}

func sendMessage(conn *websocket.Conn, msgType string, data interface{}) {
	msg := Message{Type: msgType, Data: data}
	conn.WriteJSON(msg)
}

func broadcastMessage(msgType string, data interface{}) {
	msg := Message{Type: msgType, Data: data}
	for _, conn := range game.Players {
		if conn != nil {
			conn.WriteJSON(msg)
		}
	}
}

func findPlayerID(conn *websocket.Conn) int {
	for i, player := range game.Players {
		if player == conn {
			return i + 1
		}
	}
	return 0
}

func removePlayer(conn *websocket.Conn) {
	for i, player := range game.Players {
		if player == conn {
			game.Players = append(game.Players[:i], game.Players[i+1:]...)
			fmt.Printf("Người chơi %d đã rời khỏi game\n", i+1)
			broadcastMessage("player_count", len(game.Players))
			break
		}
	}
}

func resetGame() {
	for i := 0; i < 15; i++ {
		for j := 0; j < 15; j++ {
			game.Board[i][j] = 0
		}
	}
	game.Turn = 1
	game.Winner = 0
	game.GameOver = false

	broadcastMessage("game_state", game)
	fmt.Println("Game đã được reset")
}

// serve file
func serveHTML(w http.ResponseWriter, r *http.Request) {
	http.ServeFile(w, r, "index.html")
}

func main() {
	fmt.Println("Starting Caro Game Server...")

	// routes
	http.HandleFunc("/", serveHTML)
	http.HandleFunc("/ws", handleWebSocket)

	fmt.Println("Server running on http://localhost:8080")
	fmt.Println("Open 2 browser tabs to play!")

	// listen server
	log.Fatal(http.ListenAndServe(":8080", nil))
}
