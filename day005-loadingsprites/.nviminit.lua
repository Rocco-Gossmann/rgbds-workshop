local wk = require("which-key");

wk.register({
    ["<leader>d"] =  {
        name = "RGBDS",
        r = { ":!tmux split-pane 'make run'<CR>", "Run Game" } }
}, {
    mode="n"
})
