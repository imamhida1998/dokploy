# Stage 1 - Build
FROM golang:1.22-alpine AS builder
WORKDIR /app

# Copy dependency dulu agar caching efisien
COPY go.mod go.sum ./
RUN go mod download

# Copy seluruh kode sumber
COPY . .

# (Opsional) Jalankan test otomatis
RUN go test ./... -v

# Build binary Go
RUN go build -o main .

# Stage 2 - Runtime
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["./main"]