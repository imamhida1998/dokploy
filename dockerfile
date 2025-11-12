# Stage 1 - Build
FROM golang:1.25-alpine AS builder
WORKDIR /app

COPY go.mod ./
COPY go.sum* ./
RUN go mod tidy

COPY . .
RUN go build -o main .

# Stage 2 - Runtime
FROM alpine:latest
WORKDIR /root/

# Copy hasil build
COPY --from=builder /app/main .

# Tentukan default port, bisa dioverride dari Dokploy
ENV PORT=8080

# Gunakan ARG agar EXPOSE mengikuti ENV (lihat bagian bawah)
ARG PORT
EXPOSE ${PORT}

CMD ["./main"]