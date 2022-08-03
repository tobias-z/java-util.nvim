test:
	nvim --headless \
	-u scripts/minimal.vim \
	-c "PlenaryBustedDirectory lua/tests/java_util/automated { minimal_init = './scripts/minimal.vim' }"

format:
	stylua lua/

lint:
	luacheck lua

gendoc:
	nvim --headless --noplugin -u scripts/minimal_doc.vim -c "luafile ./scripts/generate_doc.lua" -c 'qa'
