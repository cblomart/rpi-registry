DOCKER_IMAGE_VERSION=0.0.1
DOCKER_IMAGE_NAME=cblomart/rpi-registry
DOCKER_IMAGE_TAGNAME=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)
BUILD_FLAGS=-ldflags '-s -w' -a 

default: build

bin:
	mkdir bin

$(GOPATH)/bin/linux_arm/registry:
	GOOS=linux GOARCH=arm  GOARM=5 go get $(BUILD_FLAGS) github.com/docker/distribution/cmd/registry
    

build: $(GOPATH)/bin/linux_arm/registry bin
	cp $(GOPATH)/bin/linux_arm/registry ./bin/
	upx -qq --best ./bin/registry

docker:
	docker build -t $(DOCKER_IMAGE_NAME) .
	docker tag -f $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_NAME):latest
	docker tag -f $(DOCKER_IMAGE_NAME) $(DOCKER_IMAGE_TAGNAME)

clean:
	rm -rf ./bin
	rm -rf $(GOPATH)/bin/linux_arm/registry

push:
	docker push $(DOCKER_IMAGE_NAME)

test:
	docker run --rm $(DOCKER_IMAGE_NAME) --version
