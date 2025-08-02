# Bài 03: Ứng dụng Web Hiển Thị Transcript Đồng Bộ Với Âm Thanh

Ứng dụng này cho phép người dùng **nghe audio và xem transcript được đồng bộ theo thời gian thực**, với khả năng **click vào từng từ để phát lại audio tại thời điểm tương ứng**.

## 📁 Cấu trúc thư mục

DTH03/
├── main.go # File backend chính viết bằng Go (Iris framework)
├── index.html # Giao diện web hiển thị audio + transcript
├── uploads/ # Chứa file .wav và .json transcript

## 🚀 Cách chạy ứng dụng

### 1. Cài đặt Go và Iris

Đảm bảo bạn đã cài [Go](https://go.dev/dl/) (phiên bản >= 1.16)

```bash
go install github.com/kataras/iris/v12@latest

2. Chạy chương trình
Mở terminal tại thư mục DTH03 và chạy:

bash
Copy
Edit
go run main.go
Mặc định server sẽ chạy tại: http://localhost:8080

3. Truy cập giao diện
Mở trình duyệt tại http://localhost:8080

Audio sẽ được phát từ file uploads/jamesflora.wav

Transcript sẽ được load từ file uploads/jamesflora.json

Khi audio phát:

Các từ đang được nói sẽ highlight màu vàng

Bạn có thể click vào bất kỳ từ nào để phát lại từ đoạn đó
```
