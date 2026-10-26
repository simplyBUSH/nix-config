{ pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    withRuby = false;
    withPython3 = false;

    plugins = with pkgs.vimPlugins; [

      {
        plugin = nightfox-nvim;
        type = "lua";
        config = ''
          require("nightfox").setup({
            palettes = {
              carbonfox = {
                bg0 = "#000000",
                bg1 = "#000000",
              },
            },
            groups = {
              all = {
                Normal = { bg = "#000000" },
                NormalNC = { bg = "#000000" },
                NormalFloat = { bg = "#000000" },
                FloatBorder = { fg = "#525253", bg = "#000000" },
                SignColumn = { bg = "#000000" },
                EndOfBuffer = { bg = "#000000" },
              },
            },
          })

          vim.cmd.colorscheme("carbonfox")
        '';
      }

      nvim-web-devicons
      plenary-nvim

  {
      plugin = nvim-lspconfig;
      type = "lua";
      config = ''
          local capabilities = require("cmp_nvim_lsp").default_capabilities()

          -- Configure clangd using the native vim.lsp.config API
          vim.lsp.config("clangd", {
            capabilities = capabilities,
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
            },
          })

          -- Enable the server (activates automatically when opening C/C++ files)
          vim.lsp.enable("clangd")

          -- Configure error highlights and the floating error box
          vim.diagnostic.config({
            virtual_text = false, -- Disable inline clutter since we use the float box
            signs = true,         -- Highlight the line / sign column on error
            underline = true,     -- Underline the offending code
            update_in_insert = false,
            severity_sort = true,
            float = {
              border = "rounded",
              source = "always",
              header = "",
              prefix = "",
            },
          })

          -- Lower updatetime so the error box pops up quickly (300ms) when selecting a line
          vim.opt.updatetime = 300

          -- Show floating error box automatically when the cursor rests on an error line
          vim.api.nvim_create_autocmd("CursorHold", {
            callback = function()
              vim.diagnostic.open_float(nil, {
                focusable = false,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                scope = "line",
              })
            end,
          })

          -- Useful LSP keymaps once clangd attaches
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(ev)
              local opts = { buffer = ev.buf, noremap = true, silent = true }
              vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
              vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
              vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
              vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
              vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
            end,
          })
        '';
      }

      # --- Autocompletion (Variables, Functions, Snippets) ---
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      luasnip
      cmp_luasnip
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require("cmp")
          local luasnip = require("luasnip")

          cmp.setup({
            snippet = {
              expand = function(args)
                luasnip.lsp_expand(args.body)
              end,
            },
            window = {
              completion = cmp.config.window.bordered(),
              documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
              ["<C-n>"] = cmp.mapping.select_next_item(),
              ["<C-p>"] = cmp.mapping.select_prev_item(),
              ["<C-d>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp" }, -- C++ variables, functions, types from clangd
              { name = "luasnip" },
            }, {
              { name = "buffer" },
              { name = "path" },
            }),
          })
        '';
      }

      {
        plugin = oil-nvim;
        type = "lua";
        config = ''
          require("oil").setup({
            default_file_explorer = true,
            view_options = { show_hidden = true },
            keymaps = {
              ["<C-v>"] = "actions.select_vsplit",
              ["<C-s>"] = "actions.select_split",
            },
          })
        '';
      }

      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          require("telescope").setup({
            defaults = { path_display = { "truncate" } },
          })
        '';
      }

      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          require("nvim-tree").setup({
            view = { width = 30, side = "left" },
            renderer = { group_empty = true },
            filters = { dotfiles = false },
          })

          vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<CR>", {
            noremap = true,
            silent = true,
            desc = "Toggle File Tree",
          })
        '';
      }

      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = ''
          require("gitsigns").setup({
            signs = {
              add          = { text = "▎" },
              change       = { text = "▎" },
              delete       = { text = "" },
              topdelete    = { text = "" },
              changedelete = { text = "▎" },
            },
            on_attach = function(bufnr)
              local gs = require("gitsigns")
              local o = { buffer = bufnr, noremap = true, silent = true }

              vim.keymap.set("n", "]g", gs.next_hunk, o)
              vim.keymap.set("n", "[g", gs.prev_hunk, o)
              vim.keymap.set("n", "<leader>gp", gs.preview_hunk, o)
              vim.keymap.set("n", "<leader>gr", gs.reset_hunk, o)
              vim.keymap.set("n", "<leader>gb", gs.blame_line, o)
            end,
          })
        '';
      }

      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require("nvim-autopairs").setup({})
        '';
      }

      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require("Comment").setup()
        '';
      }

      {
        plugin = toggleterm-nvim;
        type = "lua";
        config = ''
          require("toggleterm").setup({
            size         = 20,
            open_mapping = [[<c-\>]],
            direction    = "horizontal",
            shell        = vim.o.shell,
          })
        '';
      }

      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require("lualine").setup({
            options = {
              theme = "auto",
              globalstatus = true,
            },
          })
        '';
      }
    ];

    # Global Options, Keymaps, and Autocmds
    initLua = ''
      local opt = vim.opt
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      opt.relativenumber = true
      opt.number = true
      opt.tabstop = 4
      opt.shiftwidth = 4
      opt.expandtab = true
      opt.autoindent = true
      opt.ignorecase = true
      opt.smartcase = true
      opt.hlsearch = true
      opt.incsearch = true
      opt.termguicolors = true
      opt.signcolumn = "yes"
      opt.wrap = false
      opt.clipboard:append("unnamedplus")
      opt.splitright = true
      opt.splitbelow = true
      opt.undofile = true

      vim.g.mapleader = " "

      -- Window navigation
      keymap("n", "<C-h>", "<C-w>h", opts)
      keymap("n", "<C-j>", "<C-w>j", opts)
      keymap("n", "<C-k>", "<C-w>k", opts)
      keymap("n", "<C-l>", "<C-w>l", opts)

      -- File explorer
      keymap("n", "-", "<cmd>Oil<CR>", {
        desc = "Open file explorer (Oil)",
      })
      keymap("n", "<leader>e", "<cmd>Oil --float<CR>", {
        desc = "Float file explorer",
      })

      -- Telescope
      keymap("n", "<leader>ff", function()
        require("telescope.builtin").find_files()
      end, { desc = "Find files" })

      keymap("n", "<leader>fg", function()
        require("telescope.builtin").live_grep()
      end, { desc = "Live grep" })

      keymap("n", "<leader>fb", function()
        require("telescope.builtin").buffers()
      end, { desc = "Buffers" })

      -- Splits
      keymap("n", "<leader>s", "<cmd>vsplit<CR>")

      -- Buffers
      keymap("n", "<S-l>", ":bnext<CR>", opts)
      keymap("n", "<S-h>", ":bprev<CR>", opts)
      keymap("n", "<leader>bd", ":bd<CR>", {
        desc = "Close buffer",
      })

      -- General
      keymap("n", "<leader>w", ":w<CR>", opts)
      keymap("n", "<leader>q", ":q<CR>", opts)
      keymap("n", "<leader>h", ":nohlsearch<CR>", opts)

      -- Visual mode
      keymap("v", "<", "<gv", opts)
      keymap("v", ">", ">gv", opts)
      keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
      keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)
    '';
  };
}
