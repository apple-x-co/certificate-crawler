BIN := 'certificate-crawler'

VERSION := '0.0.1'
REVISION := '$(shell git rev-parse --short HEAD)'

BUILD_TAGS_PRODUCTION := 'production'
BUILD_TAGS_DEVELOPMENT := 'development unittest'

MAIN := apple-x-co/certificate-crawler/cmd/certificate-crawler

all: clean darwin-dev linux

.PHONY: version
version:
	echo $(VERSION).$(REVISION)

.PHONY: base
base:
	go build -o $(BIN_NAME) -tags '$(BUILD_TAGS) netgo' -installsuffix netgo -ldflags '-s -w -X main.version=$(VERSION) -X main.revision=$(REVISION) -extldflags "-static"' $(MAIN)

.PHONY: darwin-dev
darwin-dev:
	go mod tidy
	go fmt
	if [ ! -d bin/darwin ]; then mkdir -p bin/darwin; fi
	$(MAKE) base BUILD_TAGS=$(BUILD_TAGS_DEVELOPMENT) GOOS=darwin GOARCH=amd64 BIN_NAME=bin/darwin/$(BIN)

.PHONY: linux
linux:
	if [ ! -d bin/linux ]; then mkdir -p bin/linux; fi
	$(MAKE) base BUILD_TAGS=$(BUILD_TAGS_PRODUCTION) CGO_ENABLED=0 GOOS=linux GOARCH=amd64 BIN_NAME=bin/linux/$(BIN)

.PHONY: clean
clean:
	rm -rf bin/*/$(BIN)
	go clean $(MAIN)