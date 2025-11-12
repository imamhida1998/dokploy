FROM golang:1.25-alpine AS builder
WORKDIR /app

COPY go.mod ./
COPY go.sum* ./
RUN go mod tidy

COPY . .
RUN go build -o main .

FROM alpine:latest
WORKDIR /root/
COPY --from=builder /app/main .
CMD ["./main"]