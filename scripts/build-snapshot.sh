#!/bin/bash

java_builder=$1
lua_builder=$2

echo "Building snapshot for: '$java_builder' using builder: '$lua_builder'"

nvim lua/tests/testproject/src/main/java/io/github/tobiasz/testproject/builders/$java_builder.java \
    --noplugin \
    -u scripts/minimal.vim \
    -c "set noswapfile" \
    -c "luafile lua/tests/java_util/util/setup_jdtls.lua" \
    -c "set filetype=java" \
    -c "lua require('tests.java_util.util.helpers').wait_for_ready_lsp()" \
    -c "luafile lua/tests/java_util/builders/$lua_builder.lua" \
    -c "lua vim.wait(4000)" \
    -c "wq! lua/tests/java_util/snapshots/$java_builder.snapshot"
