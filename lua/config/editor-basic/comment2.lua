local ft = Safe_Require("Comment.ft")
ft({ "go", "rust", "jsonc" }, { "//%s", "/*%s*/" })
require("Comment").setup()
