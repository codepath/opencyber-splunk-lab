# Image names
IMAGE_NAME=opencyber-splunk-lab

# Default target: build the lab image
all: student

# Build the lab image
student:
	docker build -t $(IMAGE_NAME):local -f docker/Dockerfile .

# Run a container from the local build
run:
	docker run --rm -it -p 8000:8000 -v splunk-lab-data:/opt/splunk/var $(IMAGE_NAME):local

# Clean up dangling images (optional)
clean:
	docker image prune -f

# Run the image from GitHub Container Registry
ghcr:
	docker run --rm -it -p 8000:8000 -v splunk-lab-data:/opt/splunk/var ghcr.io/codepath/$(IMAGE_NAME):latest

# Build and push to GitHub Container Registry (requires docker login ghcr.io)
push:
	docker buildx build --platform linux/amd64 -t ghcr.io/codepath/$(IMAGE_NAME):latest -f docker/Dockerfile --push .
