CONTCLI=podman

clean:
	$(CONTCLI) rmi ezkernel

clean-all: clean
	$(CONTCLI) rmi kernel-builder

build:
	$(CONTCLI) build -f Dockerfile.builder -t kernel-builder
	$(CONTCLI) build -f Dockerfile.build -t ezkernel
	$(CONTCLI) run --name ezkernel --rm -d ezkernel
	$(CONTCLI) cp ezkernel:/bzImage ./bzImage
	$(CONTCLI) kill ezkernel