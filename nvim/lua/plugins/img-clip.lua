vim.pack.add({
	{ src = "https://github.com/hakonharnes/img-clip.nvim" },
})

require("img-clip").setup({
	default = {
		dir_path = "assets",
		file_name = "%Y-%m-%d-%H-%M-%S",
		use_absolute_path = false,
	},
	filetypes = {
		markdown = {
			template = "![]($FILE_PATH)",
		},
		tex = {
			template = "\\includegraphics{$FILE_PATH}",
		},
		typst = {
			template = 'image("$FILE_PATH")',
		},
	},
	drag_and_drop = {
		enabled = true,
	},
	clipboard = {
		enabled = true,
	},
})
