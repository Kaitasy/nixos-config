{
  inputs,
  lib,
  config,
  ...
}: let
  cfg = config.modules.programs.development.neovim;
in {
  options.modules.programs.development.neovim = {
    enable = lib.mkEnableOption "Neovim";
  };

  imports = [
    inputs.nvf.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;

      settings.vim = {
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = true;
        };

        viAlias = true;
        vimAlias = true;

        spellcheck.enable = false;

        lsp = {
          enable = true;

          formatOnSave = true;
          trouble.enable = true;
        };

        treesitter = {
          enable = true;
          indent.enable = true;
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          nix.enable = true;
          clang.enable = true;
          rust.enable = true;
        };

        visuals = {
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = true;
          fidget-nvim.enable = true;
          highlight-undo.enable = true;
          indent-blankline.enable = true;
        };

        statusline.lualine = {
          enable = true;
          theme = "catppuccin";
        };

        autopairs.nvim-autopairs.enable = true;
        autocomplete.blink-cmp.enable = true;
        filetree.neo-tree.enable = true;
        tabline.nvimBufferline = {
          enable = true;
          mappings.closeCurrent = "<leader>bq";
          mappings.cycleNext = "<Tab>";
        };

        binds = {
          whichKey.enable = true;
          cheatsheet.enable = true;
        };

        telescope.enable = true;

        git = {
          enable = true;
          gitsigns.enable = true;
          neogit.enable = true;
        };

        terminal = {
          toggleterm = {
            enable = true;
            lazygit.enable = true;
          };
        };

        ui = {
          borders.enable = true;
          noice.enable = true;
          colorizer.enable = true;
          illuminate.enable = true;
          fastaction.enable = true;
        };

        presence.neocord.enable = true;
      };
    };
  };
}
