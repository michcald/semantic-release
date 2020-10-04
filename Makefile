default: build push

build:
	docker build --rm --no-cache -t michcald/semantic-release:latest .

push:
	docker push michcald/semantic-release:latest
