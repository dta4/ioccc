all:
	@cd src/ && make

release:
ifdef v
	@cd src/ && make build v=$(v)
	@hub release create -a "src/ioccc-src-${v}.tgz#ioccc $(v) source" -a "src/ioccc-linux-x64-${v}.tgz#ioccc $(v) for Linux 64-bit" -m "ioccc $(v)" -m "Publish the relevant CHANGELOG, here..." $(v)
else
	@echo Missing release version
	@exit 2
endif

clean:
	@cd src/ && make dist_clean
