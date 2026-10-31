vim.lsp.config("clangd", {
	cmd = { "clangd", "--compile-commands-dir=" .. vim.fn.getcwd() },
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})
vim.lsp.enable("clangd")
--
-- For NixOS

-- vim.lsp.config.lua_ls({
-- 	cmd = { "lua-language-server" },
-- 	settings = {
-- 		Lua = {
-- 			runtime = { version = "LuaJIT" },
-- 			diagnostics = { globals = { "vim" } },
-- 		},
-- 	},
-- })
--
-- vim.lsp.config.jdtls({
-- 	cmd = { "jdtls" },
-- })

--
-- vim.lsp.config.nil_ls({
--   settings = {
--     ['nil'] = {
--       formatting = {
--         command = { "nixpkgs-fmt" }
--       }
--     }
--   }
-- })
--
