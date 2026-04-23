{ self, inputs, ... }: {
    flake.nixosModules.nvim = { pkgs, lib, ... }: {
        environment.systemPackages = [
            self.packages.${pkgs.stdenv.hostPlatform.system}.nvim
        ];

        environment.variables.EDITOR = "nvim";
    };

    perSystem = { pkgs, lib, self', ... }: {
        packages.nvim = inputs.wrapper-modules.wrappers.neovim.wrap {
            inherit pkgs;

            specs.general = with pkgs.vimPlugins; [
                nvim-treesitter
                nvim-treesitter.withAllGrammars

                telescope-nvim
                plenary-nvim
                telescope-fzf-native-nvim
                telescope-ui-select-nvim

                nvim-web-devicons

                nvim-lspconfig
                fidget-nvim
            ];

            specs.lazy = {
                lazy = true;
                data = with pkgs.vimPlugins; [
                ];
            };

            extraPackages = with pkgs; [
                ripgrep
                fd

                clang-tools
                rust-analyzer
                rustfmt
                nixd
                alejandra
                lua-language-server
                stylua
            ];

            settings.config_directory = ./.;
        };
    };
}
