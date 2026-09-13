{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.git = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.git
    ];
  };

  perSystem = {pkgs, ...}: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;

      settings = {
        user = {
          name = "Pedro V. Pinho";
          email = "pvpedrinho06@gmail.com";
        };

        init.defaultBranch = "main";

        pull.rebase = true;
      };
    };
  };
}
