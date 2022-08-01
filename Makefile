test:
	nvim --headless \
	-u scripts/minimal.vim \
	-c "PlenaryBustedDirectory lua/tests/automated { minimal_init = './scripts/minimal.vim' }"

format:
	stylua lua/

lint:
	luacheck lua
