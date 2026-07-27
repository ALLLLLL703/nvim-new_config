local ft = require("Comment.ft")
ft({ "go", "rust", "jsonc" }, { "//%s", "/*%s*/" })
require("Comment").setup()
