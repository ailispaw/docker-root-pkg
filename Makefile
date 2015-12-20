BUILDER := ailispaw/docker-root-pkg:1.2.5

SOURCES := Dockerfile .dockerignore empty.config package/Config.in

build: $(SOURCES)
	$(eval SRC_UPDATED=$$(shell stat -f "%m" $^ | sort -gr | head -n1))
	$(eval STR_CREATED=$$(shell docker inspect -f '{{.Created}}' $(BUILDER) 2>/dev/null))
	$(eval IMG_CREATED=`date -j -u -f "%FT%T" "$$(STR_CREATED)" +"%s" 2>/dev/null || echo 0`)
	@if [ "$(SRC_UPDATED)" -gt "$(IMG_CREATED)" ]; then \
		set -e; \
		docker build -t $(BUILDER) .; \
	fi

clean:
	-docker rmi $(BUILDER)

.PHONY: build clean
