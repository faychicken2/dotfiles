-- Plugin-specific setup for rendered Markdown.
require("render-markdown").setup({
    heading = { icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " } },
    code = { language = false },
    html = { enabled = false },
    yaml = { enabled = false },
    latex = { enabled = false },
})
