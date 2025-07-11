local lspconfig_ensure_installed = {
    "gopls@1.24.1",
    "bashls",
    "yamlls",
    "lua_ls",
}

-- The goal of nvim-bqf is to make Neovim's quickfix window better.
local bqf_ok, bqf = pcall(require, "bqf")
if bqf_ok then
    bqf.setup({})
end

-- folke/trouble.nvim - trouble 
local trouble_ok, trouble = pcall(require, "trouble")
if trouble_ok then
    trouble.setup({
        position = "right", -- 侧边栏显示在右侧
        width = 50,         -- 侧边栏宽度
        height = 10,        -- 侧边栏高度
        padding = false,    -- 不使用内边距
        mode = "document_diagnostics", -- 默认只显示当前文档诊断
        group = true, -- 分组相似诊断
        cycle_results = false, -- 不循环结果
        auto_jump = {}, -- 自动跳转到特定诊断类型
    })
end

-- rebelot/kanagawa.nvim
local kanagawa_ok, kanagawa = pcall(require, "kanagawa")
if kanagawa_ok then
    kanagawa.setup({
        commentStyle = { italic = false },   -- 取消注释的斜体
        keywordStyle = { italic = false },   -- 取消关键字的斜体
        functionStyle = { italic = false },  -- 取消函数名的斜体
    })
    vim.cmd("colorscheme kanagawa")
end

-- indent-blankline.nvim
local blankline_ok, blankline = pcall(require, "ibl")
if blankline_ok then
    blankline.setup({
        indent = {
            char = "│"
        },
        scope = {
            enabled = true,
            show_start = false,
            show_end = false,
        },
    })
end

-- folke/todo-comments.nvim - todo-comments 
local todo_comments_ok, todo_comments = pcall(require, "todo-comments")
if todo_comments_ok then
    todo_comments.setup()
end

-- numToStr/Comment.nvim - comment 
local comment_ok, comment = pcall(require, "Comment")
if comment_ok then
    comment.setup {
        pre_hook = function(ctx)
            local U = require "Comment.utils"

            local status_utils_ok, utils = pcall(require, "ts_context_commentstring.utils")
            if not status_utils_ok then
                return
            end

            local location = nil
            if ctx.ctype == U.ctype.block then
                location = utils.get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
                location = utils.get_visual_start_location()
            end

            local status_internals_ok, internals = pcall(require, "ts_context_commentstring.internals")
            if not status_internals_ok then
                return
            end

            return internals.calculate_commentstring {
                key = ctx.ctype == U.ctype.line and "__default" or "__multiline",
                location = location,
            }
        end,
    }
end

-- folke/flash.nvim - flash 
local flash_ok, flash = pcall(require, "flash")
if flash_ok then
    flash.setup({
        labels = "abcdefghijklmnopqrstuvwxyz",
        search = {
            mode = "fuzzy",
        },
        jump = {
            autojump = true,
        },
    })
end

-- neotest.nvim
local neotest_ok, neotest = pcall(require, "neotest")
if neotest_ok then
    neotest.setup({
        overseer = {
            enabled = true,
            -- When this is true (the default), it will replace all neotest.run.* commands
            force_default = false,
        },
        adapters = {
            require("neotest-go")({
                -- You can provide optional configuration here, like:
                experimental = {
                    test_table = true,
                },
                args = { "-count=1", "-timeout=60s" },
            }),
        },
        output = {
            open_on_run = "short",
            -- max_height = 15,
            -- max_width = 80,
        },
        output_panel = {
            enabled = true,
            open = "botright split | resize 15",
        },
        quickfix = {
            open = function()
                vim.cmd("copen") -- 自动打开 quickfix 窗口
            end,
            -- 只显示失败的测试
            -- filter = function(positions)
            --     return vim.tbl_filter(function(pos)
            --         return pos.status == "failed"
            --     end, positions)
            -- end,
        },
    })
end

-- nvim-tree
local nvim_tree_ok, nvim_tree = pcall(require, "nvim-tree")
if nvim_tree_ok then
    local function my_on_attach(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
            return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set("n", "C", api.tree.change_root_to_node,   opts("CD"))
        vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
        vim.keymap.set("n", "l", api.node.open.edit,             opts("Open"))
        vim.keymap.set("n", "y", api.fs.copy.node,               opts("Copy"))
        vim.keymap.set("n", "c", api.fs.create,                  opts("Create"))
        vim.keymap.set("n", "v", api.node.open.vertical,         opts("Open: Vertical Split"))
        vim.keymap.set("n", "s", api.node.open.horizontal,       opts("Open: Horizontal Split"))
    end

    nvim_tree.setup {
        on_attach = my_on_attach,
        update_focused_file = {
            enable = true,
            update_cwd = false,
        },
        renderer = {
            icons = {
                show = {
                    file = false,
                    folder = false,
                    -- folder_arrow = false,
                },
                glyphs = {
                    default = "",
                    symlink = "",
                    folder = {
                        arrow_closed = "",
                        arrow_open = "",
                        default = "",
                        open = "",
                        empty = "",
                        empty_open = "",
                        symlink = "",
                        symlink_open = "",
                    },
                    git = {
                        unstaged = "",
                        staged = "",
                        unmerged = "",
                        renamed = "",
                        untracked = "",
                        deleted = "",
                        ignored = "",
                    },
                },
            },
        },
        diagnostics = {
            enable = false,
            show_on_dirs = true,
            icons = {
                hint = "",
                info = "",
                warning = "",
                error = "",
            },
        },
        filters = {
            dotfiles = true,
            git_clean = false,
            no_buffer = false,
            custom = {},
            exclude = {".conf"},
        },
        filesystem_watchers = {
            enable = true,
            debounce_delay = 50,
            ignore_dirs = {},
        },
    }
end

-- bufferline.nvim
local bufferline_ok, bufferline = pcall(require, "bufferline")
if bufferline_ok then
    bufferline.setup({
        options = {
            numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
            -- close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
            -- right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
            -- left_mouse_command = "buffer %d", -- can be a string | function, see "Mouse actions"
            -- middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
            -- NOTE: this plugin is designed with this icon in mind,
            -- and so changing this is NOT recommended, this is intended
            -- as an escape hatch for people who cannot bear it for whatever reason
            -- indicator_icon = nil,
            indicator = { style = "none" },
            -- buffer_close_icon = "",
            -- buffer_close_icon = "",
            -- modified_icon = "●",
            -- close_icon = "",
            -- close_icon = "",
            -- left_trunc_marker = "",
            -- right_trunc_marker = "",
            --- name_formatter can be used to change the buffer"s label in the bufferline.
            --- Please note some names can/will break the
            --- bufferline so use this at your discretion knowing that it has
            --- some limitations that will *NOT* be fixed.
            -- name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
            --   -- remove extension from markdown files for example
            --   if buf.name:match("%.md") then
            --     return vim.fn.fnamemodify(buf.name, ":t:r")
            --   end
            -- end,
            max_name_length = 30,
            max_prefix_length = 30, -- prefix used when a buffer is de-duplicated
            tab_size = 0,
            diagnostics = false, -- | "nvim_lsp" | "coc",
            diagnostics_update_in_insert = false,
            -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
            --   return "("..count..")"
            -- end,
            -- NOTE: this will be called a lot so don"t do any heavy processing here
            -- custom_filter = function(buf_number)
            --   -- filter out filetypes you don"t want to see
            --   if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
            --     return true
            --   end
            --   -- filter out by buffer name
            --   if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
            --     return true
            --   end
            --   -- filter out based on arbitrary rules
            --   -- e.g. filter out vim wiki buffer from tabline in your work repo
            --   if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
            --     return true
            --   end
            -- end,
            -- offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
            show_buffer_icons = false,
            show_buffer_close_icons = false,
            show_close_icon = false,
            show_tab_indicators = false,
            show_duplicate_prefix = false, -- whether to show duplicate buffer prefix
            persist_buffer_sort = false, -- whether or not custom sorted buffers should persist
            -- can also be a table containing 2 custom separators
            -- [focused and unfocused]. eg: { "|", "|" }
            separator_style = {}, -- | "thick" | "thin" | { "any", "any" },
            enforce_regular_tabs = false,
            always_show_bufferline = true,
            -- sort_by = "id" | "extension" | "relative_directory" | "directory" | "tabs" | function(buffer_a, buffer_b)
            --   -- add custom logic
            --   return buffer_a.modified > buffer_b.modified
            -- end
        },
        highlights = {
            fill = {
                fg = "#9e9e9e",
                bg = "#262626",
            },
            background = {
                fg = "#262626",
                bg = "#444444",
            },
            buffer_selected = {
                fg = "#080808",
                bg = "#AFFA02",
                italic = false,
            },
            buffer_visible = {
                fg = "#87FBAF",
                bg = "#262626",
            },
            indicator_selected = {
                fg = "#080808",
                bg = "#AFFA02",
            },
            indicator_visible = {
                fg = "#9e9e9e",
                bg = "#262626",
            },
            close_button = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            close_button_visible = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            close_button_selected = {
                fg = {attribute="fg",highlight="TabLineSel"},
                bg ={attribute="bg",highlight="TabLineSel"}
            },
            tab_selected = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "Normal" },
            },
            tab = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            tab_close = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            duplicate_selected = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            duplicate_visible = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            duplicate = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            modified = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
            modified_selected = {
                fg = { attribute = "fg", highlight = "Normal" },
                bg = { attribute = "bg", highlight = "Normal" },
            },
            modified_visible = {
                fg = { attribute = "fg", highlight = "TabLine" },
                bg = { attribute = "bg", highlight = "TabLine" },
            },
        },

    })
end

-- nvim-lualine/lualine.nvim
local lualine_ok, lualine = pcall(require, "lualine")
if lualine_ok then
    -- local hide_in_width = function()
    --     return vim.fn.winwidth(0) > 80
    -- end

    -- local diagnostics = {
    --     "diagnostics",
    --     sources = { "nvim_diagnostic" },
    --     sections = { "error", "warn" },
    --     symbols = { error = " ", warn = " " },
    --     colored = false,
    --     update_in_insert = false,
    --     always_visible = true,
    -- }

    -- local diff = {
    --     "diff",
    --     colored = false,
    --     symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    --     cond = hide_in_width
    -- }

    local filetype = {
        "filetype",
        icons_enabled = false,
        icon = nil,
    }

    local branch = {
        "branch",
        icons_enabled = true,
        icon = "",
    }

    local location = {
        "location",
    }

    -- cool function for progress
    -- local progress = function()
    --     local current_line = vim.fn.line(".")
    --     local total_lines = vim.fn.line("$")
    --     local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
    --     local line_ratio = current_line / total_lines
    --     local index = math.ceil(line_ratio * #chars)
    --     return chars[index]
    -- end

    local filename = {
        "filename",
        -- file_status = false,
        -- newfile_status = false,
        path = 3,
        shorting_target = 40,
    }

    local fileformat = {
        "fileformat",
        icons_enabled = false,
    }

    local mode = {
        "mode",
        fmt = function(str)
            return str:sub(1,1)
        end,
    }

    lualine.setup({
        options = {
            icons_enabled = true,
            theme = "powerline",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
            always_divide_middle = true,
        },
        sections = {
            lualine_a = { mode },
            lualine_b = { branch },
            lualine_c = { filename },
            lualine_x = { "encoding", fileformat, filetype },
            lualine_y = { location },
            lualine_z = { "progress" },
        },
        inactive_sections = {
            lualine_a = { filename },
            lualine_b = {},
            lualine_c = {},
            lualine_x = { location },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {},
    })
end

-- nvimdev/lspsaga.nvim - lspsaga 
local lspsaga_ok, lspsaga = pcall(require, "lspsaga")
if lspsaga_ok then
    lspsaga.setup({
        lightbulb = {
            enable = false,
        },
        -- symbol_in_winbar = {
        --     enable = true,
        --     separator = "  ",
        --     hide_keyword = false,
        -- },
    })
end

-- L3MON4D3/LuaSnip - luasnip 
local luasnip_ok, luasnip = pcall(require, "luasnip")
if luasnip_ok then
    require("luasnip/loaders/from_vscode").lazy_load()

    -- local check_backspace = function()
    --   local col = vim.fn.col "." - 1
    --   return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
    -- end
end


-- hrsh7th/nvim-cmp - cmp 
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
    -- find more here: https://www.nerdfonts.com/cheat-sheet
    local kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
    }

    cmp.setup({
        snippet = {
            expand = function(args)
                if not luasnip_ok then
                    return
                end
                luasnip.lsp_expand(args.body) -- For `luasnip` users.
            end,
        },
        mapping = {
            ["<c-p>"] = cmp.mapping.select_prev_item(),
            ["<c-n>"] = cmp.mapping.select_next_item(),
            ["<c-b>"] = cmp.mapping.scroll_docs(-4),
            ["<c-f>"] = cmp.mapping.scroll_docs(4),
            ["<c-l>"] = cmp.mapping.complete(),
            ["<c-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ["<c-e>"] = cmp.mapping.abort(),
            -- Set `select` to `false` to only confirm explicitly selected items.
            -- Accept currently selected item. If none selected, `select` first item.
            ["<CR>"] = cmp.mapping.confirm ({ select = true }),
        },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function(entry, vim_item)
                -- Kind icons
                vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
                -- vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
                vim_item.menu = ({
                    nvim_lsp = "[LSP]",
                    luasnip = "[Snippet]",
                    buffer = "[Buffer]",
                    path = "[Path]",
                })[entry.source.name]
                return vim_item
            end,
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
        },
        confirm_opts = {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        window = {
            documentation = {
                border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
            },
        },
        experimental = {
            ghost_text = false,
            native_menu = false,
        },
    })
end



-- hrsh7th/cmp-nvim-lsp -- cmp-nvim-lsp 
local cmp_nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_nvim_lsp_ok then
    cmp_nvim_lsp.setup({
        capabilities = cmp_nvim_lsp.default_capabilities(),
    })
end


-- neovim/nvim-lspconfig -- lspconfig 
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
if lspconfig_ok then
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    if cmp_nvim_lsp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
    end

    local function lsp_keymaps(bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        local function opts(desc)
            return { desc = "lsp: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename"))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts("Code Action"))
        -- vim.keymap.set("n", "<leader>=", function() vim.lsp.buf.format({ async = true }) end, opts("Format"))
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts("Go to Definition"))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts("Go to Implementation"))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts("References"))
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts("Hover Documentation"))
    end



    local on_attach = function(client, bufnr)
        if client.name == "tsserver" then
            client.server_capabilities.documentFormattingProvider = false
        end

        if client.name == "lua_ls" then
            client.server_capabilities.documentFormattingProvider = false
        end

        lsp_keymaps(bufnr)
        local status_ok, illuminate = pcall(require, "illuminate")
        if not status_ok then
            return
        end
        illuminate.on_attach(client)
    end

    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
    }


    for _, server in pairs(lspconfig_ensure_installed) do
        server = vim.split(server, "@")[1]

        local require_ok, conf_opts = pcall(require, "langs." .. server)
        if require_ok then
            opts = vim.tbl_deep_extend("force", conf_opts, opts)
        end

        lspconfig[server].setup(opts)
    end

    -- handlers.setup (modernized) 
    vim.diagnostic.config({
        virtual_text = false,  -- 不显示内联错误
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "",
                [vim.diagnostic.severity.WARN]  = "",
                [vim.diagnostic.severity.HINT]  = "",
                [vim.diagnostic.severity.INFO]  = "",
            },
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })


    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })

end

-- nvim-treesitter/nvim-treesitter - nvim_treesitter_configs 
local treesitter_configs_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if treesitter_configs_ok then
    treesitter_configs.setup({
        ensure_installed = { "bash", "c", "javascript", "json", "lua", "python", "typescript", "tsx", "css", "rust", "yaml", "markdown", "markdown_inline", "go" }, -- one of "all" or a list of languages
        ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
        highlight = {
            enable = true, -- false will disable the whole extension
            disable = { "css" }, -- list of language that will be disabled
        },
        autopairs = {
            enable = true,
        },
        indent = { enable = true, disable = { "python", "css" } },
    })
end

-- telescope
-- nvim-telescope/telescope.nvim - telescope 
local telescope_ok, telescope = pcall(require, "telescope")
if telescope_ok then
    local actions = require "telescope.actions"
    telescope.setup ({
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            path_display = { "smart" },

            mappings = {
                i = {
                    -- ["<C-n>"] = actions.cycle_history_next,
                    -- ["<C-p>"] = actions.cycle_history_prev,

                    ["<CR>"] = actions.select_default,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<C-n>"] = actions.move_selection_next,
                    ["<C-p>"] = actions.move_selection_previous,

                    ["<C-c>"] = actions.close,

                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,

                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,

                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,

                    ["<PageUp>"] = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,

                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                    ["<C-l>"] = actions.complete_tag,
                    ["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
                },

                n = {
                    ["<esc>"] = actions.close,
                    ["<CR>"] = actions.select_default,
                    ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                    ["<C-x>"] = actions.select_horizontal,
                    ["<C-v>"] = actions.select_vertical,
                    ["<C-t>"] = actions.select_tab,

                    ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                    ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                    ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

                    ["<c-n>"] = actions.move_selection_next,
                    ["<c-p>"] = actions.move_selection_previous,
                    ["H"] = actions.move_to_top,
                    ["M"] = actions.move_to_middle,
                    ["L"] = actions.move_to_bottom,

                    ["<Down>"] = actions.move_selection_next,
                    ["<Up>"] = actions.move_selection_previous,
                    ["gg"] = actions.move_to_top,
                    ["G"] = actions.move_to_bottom,

                    ["<C-u>"] = actions.preview_scrolling_up,
                    ["<C-d>"] = actions.preview_scrolling_down,

                    ["<PageUp>"] = actions.results_scrolling_up,
                    ["<PageDown>"] = actions.results_scrolling_down,

                    ["?"] = actions.which_key,
                },
            },
        },
        pickers = {
            -- Default configuration for builtin pickers goes here:
            -- picker_name = {
            --   picker_config_key = value,
            --   ...
            -- }
            -- Now the picker_config_key will be applied every time you call this
            -- builtin picker
        },
        extensions = {
            -- Your extension configuration goes here:
            -- extension_name = {
            --   extension_config_key = value,
            -- }
            -- please take a look at the readme of the extension you want to configure
        },
    })
end

-- windwp/nvim-autopairs - nvim-autopairs 
local autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
if autopairs_ok then
    autopairs.setup {
        check_ts = true,
        ts_config = {
            lua = { "string", "source" },
            javascript = { "string", "template_string" },
            java = false,
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },
        fast_wrap = {
            map = "<M-e>",
            chars = { "{", "[", "(", '"', "'" },
            pattern = string.gsub([[ [%"%"%)%>%]%)%}%,] ]], "%s+", ""),
            offset = 0, -- Offset from pattern match
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            highlight = "PmenuSel",
            highlight_grey = "LineNr",
        },
    }

    local cmp_autopairs = require "nvim-autopairs.completion.cmp"
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if cmp_status_ok then
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done { map_char = { tex = "" } })
    end
end

-- ahmedkhalf/project.nvim - project_nvim 
local project_nvim_ok, project_nvim = pcall(require, "project_nvim")
if project_nvim_ok then
    project_nvim.setup({
        ---@usage set to false to disable project.nvim.
        --- This is on by default since it"s currently the expected behavior.
        active = true,

        on_config_done = nil,

        ---@usage set to true to disable setting the current-woriking directory
        --- Manual mode doesn"t automatically change your root directory, so you have
        --- the option to manually do so using `:ProjectRoot` command.
        manual_mode = false,

        ---@usage Methods of detecting the root directory
        --- Allowed values: **"lsp"** uses the native neovim lsp
        --- **"pattern"** uses vim-rooter like glob pattern matching. Here
        --- order matters: if one is not detected, the other is used as fallback. You
        --- can also delete or rearangne the detection methods.
        -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
        detection_methods = { "pattern", "lsp" },


        ---@usage patterns used to detect root dir, when **"pattern"** is in detection_methods
        patterns = { ".git", "package.json", "Makefile" },

        ---@ Show hidden files in telescope when searching for files in a project
        show_hidden = false,

        ---@usage When set to false, you will get a message when project.nvim changes your directory.
        -- When set to false, you will get a message when project.nvim changes your directory.
        silent_chdir = true,

        -- global, tab, win
        scope_chdir = "win",

        ---@usage list of lsp client names to ignore when using **lsp** detection. eg: { "efm", ... }
        ignore_lsp = { "none-ls" },

        exclude_dirs = { "~/.cargo/*" },

        ---@type string
        ---@usage path to store the project history for use in telescope
        datapath = vim.fn.stdpath("data"),
    })

    if telescope_ok then
        telescope.load_extension("projects")
    end

end

-- jose-elias-alvarez/null-ls.nvim -- null-ls 
local null_ls_ok, null_ls = pcall(require, "none-ls")
if null_ls_ok then

    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    local formatting = null_ls.builtins.formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    -- local diagnostics = null_ls.builtins.diagnostics

    null_ls.setup({
        debug = false,
        sources = {
            formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
            formatting.black.with({ extra_args = { "--fast" } }),
            formatting.stylua,
            -- diagnostics.flake8
        },
    })
end

-- folke/which-key.nvim -- which-key
local which_key_ok, which_key = pcall(require, "which-key")
if which_key_ok then
    which_key.setup ({
        delay = 300,  -- 延迟显示
        plugins = {
            marks = true, -- shows a list of your marks on " in NORMAL or ' in VISUAL mode
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            spelling = {
                enabled = true, -- enabling this will show WhichKey when pressing z= to spell check
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
        },
        show_help = true, -- 显示帮助信息
    })
    which_key.add({
        { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer Local Keymaps (which-key)" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>c", group = "code/config" },
        -- { "<leader>d", group = "debug" },
        -- { "<leader>a", group = "avante" },
        { "<leader>t", group = "test" },
    })
end

--  williamboman/mason.nvim -- mason 
local mason_ok, mason = pcall(require, "mason")
if mason_ok then
    mason.setup({
        ui = {
            border = "none",
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            },
            log_level = vim.log.levels.INFO,
            max_concurrent_installers = 4,
        },
    })
end

-- williamboman/mason-lspconfig.nvim -- mason-lspconfig 
-- local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
-- if mason_lspconfig_ok then
--     mason_lspconfig.setup({
--         ensure_installed = lspconfig_ensure_installed,
--         automatic_installation = false,
--         handlers = {},
--     })
-- end
