{ self, inputs, ... }: {

  flake.nixosConfigurations.nomai = inputs.nixpkgs.lib.nixosSystem {
    modules = [ 
    	self.nixosModules.nomaiConfiguration
    ];
  };

}
