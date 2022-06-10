.PHONY: tests tests-bats

SHELL := $(shell command -v bash)
DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
basename := $(shell basename $(DIR))

tests: tests-bats

tests-bats:
	@bats
