FROM golang:1.14-alpine as build

WORKDIR /build
COPY go.mod go.sum ./
RUN go mod download
COPY main.go .
RUN go build -o /build/pluginDownloader main.go

FROM alpine:3.11
WORKDIR /app
RUN apk --no-cache add ca-certificates
COPY --from=build /build/pluginDownloader /app/

ENTRYPOINT ["/app/pluginDownloader"]
