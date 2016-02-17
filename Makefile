BUILDER := ailispaw/docker-root-pkg
VERSION := 1.2.12

SOURCES := .dockerignore empty.config

EXTRA := extra/Config.in extra/external.mk \
	extra/package/criu/Config.in extra/package/criu/criu.mk \
	extra/package/ipvsadm/Config.in extra/package/ipvsadm/ipvsadm.mk

base: Dockerfile.base $(SOURCES)
	$(eval SRC_UPDATED=$$(shell stat -f "%m" $^ | sort -gr | head -n1))
	$(eval STR_CREATED=$$(shell docker inspect -f '{{.Created}}' $(BUILDER):$@ 2>/dev/null))
	$(eval IMG_CREATED=`date -j -u -f "%FT%T" "$$(STR_CREATED)" +"%s" 2>/dev/null || echo 0`)
	@if [ "$(SRC_UPDATED)" -gt "$(IMG_CREATED)" ]; then \
		set -e; \
		docker build -f $< -t $(BUILDER):$@ .; \
	fi

extra: Dockerfile.extra $(EXTRA) | base
	$(eval SRC_UPDATED=$$(shell stat -f "%m" $^ | sort -gr | head -n1))
	$(eval STR_CREATED=$$(shell docker inspect -f '{{.Created}}' $(BUILDER):$(VERSION) 2>/dev/null))
	$(eval IMG_CREATED=`date -j -u -f "%FT%T" "$$(STR_CREATED)" +"%s" 2>/dev/null || echo 0`)
	@if [ "$(SRC_UPDATED)" -gt "$(IMG_CREATED)" ]; then \
		set -e; \
		docker build -f $< -t $(BUILDER):$(VERSION) .; \
	fi

release: Dockerfile $(SOURCES) $(EXTRA)
	docker build -t $(BUILDER):$(VERSION) .

clean:
	-docker rmi $(BUILDER):$(VERSION)

.PHONY: base extra release clean
