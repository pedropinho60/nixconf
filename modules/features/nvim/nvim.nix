{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nvim = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
    ];

    environment.variables.EDITOR = "nvim";
  };

  perSystem = {pkgs, ...}: {
    packages.nvim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;

      specs.general = with pkgs.vimPlugins; [
        tokyonight-nvim

        nvim-treesitter
        (nvim-treesitter.withPlugins (p: [
          p.nix
          p.rust
          p.toml
          p.lua
          p.kdl
          p.markdown
          p.c
          p.cpp
          p.json
        ]))

        telescope-nvim
        plenary-nvim
        telescope-fzf-native-nvim
        telescope-ui-select-nvim

        nvim-web-devicons

        nvim-lspconfig
        fidget-nvim

        conform-nvim

        blink-cmp
        luasnip
      ];

      specs.lazy = {
        lazy = true;
        data = [
        ];
      };

      runtimePkgs = with pkgs; [
        ripgrep
        fd

        clang-tools
        nixd
        alejandra
        lua-language-server
        stylua
      ];

      settings.config_directory = ./.;
    };
  };
}
