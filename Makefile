test:
	nvim --headless \
	--noplugin \
	-u scripts/minimal.vim \
	-c "PlenaryBustedDirectory lua/tests/java_util/automated { minimal_init = './scripts/minimal.vim' }"

format:
	stylua lua/

lint:
	luacheck lua

gendoc:
	nvim --headless --noplugin -u scripts/minimal_doc.vim -c "luafile ./scripts/generate_doc.lua" -c 'qa'

snapshots:
	sh ./scripts/build-snapshot.sh RenameLombokField rename_lombok_field
	sh ./scripts/build-snapshot.sh CreateTestNoClassSnippets create_test_no_class_snippets
	sh ./scripts/build-snapshot.sh CreateTestStringClassSnippets create_test_string_class_snippets
	sh ./scripts/build-snapshot.sh CreateTestLuasnipClassSnippets create_test_luasnip_class_snippets
	sh ./scripts/build-snapshot.sh CreateTestAfterSnippetRun create_test_after_snippet_run
