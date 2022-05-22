# See https://just.systems/man/

RUST_CHANNEL := "stable"

default:
  @just --list --unsorted --color=always | rg -v "    default"

# Build container locally
build:
	docker build --build-arg CHANNEL="{{RUST_CHANNEL}}" -t clux/muslrust:temp .
# Shell into the built container
run:
	docker run -v $PWD/test:/volume  -w /volume -it clux/muslrust:temp /bin/bash

# Test an individual crate against built containr
_t crate:
    ./test.sh {{crate}}

# Test all crates against built container
test: (_t "plain") (_t "ssl") (_t "rustls") (_t "pq") (_t "serde") (_t "curl") (_t "zlib") (_t "hyper") (_t "dieselpg") (_t "dieselsqlite")

# Cleanup everything
clean: clean-docker clean-tests

# Cleanup docker images with clux/muslrus_t name
clean-docker:
  docker images clux/muslrust -q | xargs -r docker rmi -f
# Cleanup test artifacts
clean-tests:
  sudo find . -iname Cargo.lock -exec rm {} \;
  sudo find . -mindepth 3 -maxdepth 3 -name target -exec rm -rf {} \;
  sudo rm -f test/dieselsqlitecrate/main.db

# mode: makefile
# End:
# vim: set ft=make :
