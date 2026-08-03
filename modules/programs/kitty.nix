{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.kitty = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
    ];
  };

  perSystem = {pkgs, ...}: {
    packages.kitty = inputs.wrapper-modules.wrappers.kitty.wrap {
      inherit pkgs;

      settings = {
        background_opacity = 0.8;
        background_blur = 1;
      };

      themeFile = "rose-pine";
    };
  };
}
