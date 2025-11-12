# Stage 1 - Build
FROM golang:1.21-alpine AS builder
WORKDIR /app

# Copy dependency files (tidak error kalau go.sum belum ada)
COPY go.mod ./
COPY go.sum* ./
RUN go mod tidy

# Copy source code
COPY . .

# Build binary
RUN go build -o main .

# Stage 2 - Runtime
FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["./main"]