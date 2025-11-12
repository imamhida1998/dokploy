# Stage 1 - Build
FROM golang:1.22-alpine AS builder
WORKDIR /app

# Copy dependency file (handle optional go.sum)
COPY go.mod ./
COPY go.sum* ./

# Download dependencies (akan membuat go.sum kalau belum ada)
RUN go mod tidy

# Copy seluruh kode sumber
COPY . .

# Jalankan test opsional (boleh dihapus kalau belum ada test)
RUN go test ./... -v || true

# Build binary
RUN go build -o main .

# Stage 2 - Runtime
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["./main"]