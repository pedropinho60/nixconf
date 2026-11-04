{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.vessel = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.vesselConfiguration
    ];
  };
}
