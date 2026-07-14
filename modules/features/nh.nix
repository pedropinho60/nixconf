{ self, inputs, ... }: {

    flake.nixosModules.nh = { pkgs, ... }: {
        programs.nh = {
            enable = true;
            package = self.packages.${pkgs.stdenv.hostPlatform.system}.nh;
        };
    };

    perSystem = {pkgs, ...}: {
        packages.nh = inputs.wrappers.lib.wrapPackage {
            inherit pkgs;
            package = pkgs.nh;
            env = {
                "NH_FLAKE" = "$HOME/Projetos/nixconf";
            };
        };
    };
}
