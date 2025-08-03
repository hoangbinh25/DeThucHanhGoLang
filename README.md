# Bài 01 : Ứng dụng chơi cờ caro với máy tính hoặc 2 người chơi A và B với nhau

Ứng dụng game cờ caro chơi trực tuyến 2 người với giao diện web đẹp mắt và kết nối WebSocket real-time.

Mọi người có thể vào link youtobe dưới đây để xem hướng dẫn: https://www.youtube.com/watch?v=zBoqDUxK9Hs

## 📁 Cấu trúc thư mục

```bash
    DTH01/
    ├── main.go # File backend chính viết bằng Go (Iris framework)
    ├── index.html # Giao diện web hiển thị audio + transcript
    ├── go.mod  # Quản lý các go module dependencies
    ├── go.sum  # Check sum file cho dependencies

```

🎮 Tính năng chính

✅ Real-time multiplayer: Hai người chơi cùng lúc qua WebSocket

✅ Auto-reconnect: Tự động kết nối lại khi mất kết nối

✅ Game logic hoàn chỉnh: Kiểm tra thắng thua, chuyển lượt, reset game

## 🚀 Cách chạy ứng dụng
### Clone project từ github về máy của bạn
    
Bước 1: Mở terminal (cmd, powershell, git Bash, ...)

Bước 2: Dán câu lệnh dưới vào terminal
```bash
git clone https://github.com/hoangbinh25/DeThucHanhGoLang.git
```

<img width="777" height="413" alt="image" src="https://github.com/user-attachments/assets/57390813-22d6-4bfa-957d-3c66bf4b0b84"/>
<br>

Bước 3: Gõ: 
```bash
cd DeThucHanhGoLang/
```
sau đó Gõ tiếp 
```bash
code . 
```
để mở nhanh IDE hoặc Code Editor(VS Code) mà bạn sử dụng hoặc mở IDE để open folder vừa clone về.

### 1. Cài đặt Go và gorilla/websocket

Đảm bảo bạn đã cài [Go](https://go.dev/dl/) (phiên bản >= 1.16)
```bash
# Cài đặt Gorilla WebSocket
go get github.com/gorilla/websocket
```
### 2. Chạy chương trình

Mở terminal tại thư mục DTH01 và chạy:
```bash
go run main.go
```
Mặc định server sẽ chạy tại: http://localhost:8080

### 3. Bắt đầu chơi

Mở 2 tab browser tại: http://localhost:8080

Tab 1 sẽ là Người chơi X (đi trước)

Tab 2 sẽ là Người chơi O (đi sau)

Click vào ô trống để đánh quân

Người thắng: Tạo được 5 quân liên tiếp (ngang/dọc/chéo)

🎯 Luật chơi

Bàn cờ: 15x15 ô vuông

Mục tiêu: Tạo ra 5 quân liên tiếp theo hàng ngang, dọc hoặc chéo

Lượt chơi: X đi trước, O đi sau, luân phiên

Thắng: Người đầu tiên có 5 quân liên tiếp

Reset: Click nút "🔄 Chơi lại" để bắt đầu ván mới

# Bài 03: Ứng dụng Web Hiển Thị Transcript Đồng Bộ Với Âm Thanh

Ứng dụng này cho phép người dùng **nghe audio và xem transcript được đồng bộ theo thời gian thực**, với khả năng **click vào từng từ để phát lại audio tại thời điểm tương ứng**.

## 📁 Cấu trúc thư mục

```bash
    DTH03/
    ├── main.go # File backend chính viết bằng Go (Iris framework)
    ├── index.html # Giao diện web hiển thị audio + transcript
    ├── uploads/ # Chứa file .wav và .json transcript
    ├── go.mod  # Quản lý các go module dependencies
    ├── go.sum  # Check sum file cho dependencies
```

## 🚀 Cách chạy ứng dụng

### 1. Cài đặt Go và Iris

Đảm bảo bạn đã cài [Go](https://go.dev/dl/) (phiên bản >= 1.16)

```bash
go install github.com/kataras/iris/v12@latest
```

### 2. Chạy chương trình

Mở terminal tại thư mục DTH03 và chạy:
go run main.go
Mặc định server sẽ chạy tại: http://localhost:8080

### 3. Truy cập giao diện

Mở trình duyệt tại http://localhost:8080

Audio sẽ được phát từ file uploads/jamesflora.wav

Transcript sẽ được load từ file uploads/jamesflora.json

Khi audio phát:

Các từ đang được nói sẽ highlight màu vàng

Bạn có thể click vào bất kỳ từ nào để phát lại từ đoạn đó
