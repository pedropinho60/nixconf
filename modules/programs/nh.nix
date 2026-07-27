{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nh = {pkgs, ...}: {
    programs.nh = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.nh;
    };
  };

  perSystem = {pkgs, ...}: {
    packages.nh = inputs.wrapper-modules.wrappers.nh.wrap {
      inherit pkgs;

      flake = "/home/pedro/Projetos/nixconf";
    };
  };
}
