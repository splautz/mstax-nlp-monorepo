.PHONY: init up down 

up:
	git submodule update --init --recursive
	tilt up --port 10060

down:
	tilt disable