FROM golang
COPY hello.go .
RUN go build hello.go
FROM scratch
COPY --from=0 /go/hello .
CMD ["./hello"]
