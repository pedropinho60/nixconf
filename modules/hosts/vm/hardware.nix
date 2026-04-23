{ self, inputs, ... }: {
    flake.nixosModules.vmHardware = { config, lib, pkgs, modulesPath, ... }: {

        imports =
            [ (modulesPath + "/profiles/qemu-guest.nix")
            ];

        boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        fileSystems."/" =
        { device = "/dev/disk/by-uuid/f6d4e436-77bb-49d0-99c8-f6ae35523f2f";
            fsType = "ext4";
        };

        swapDevices = [ ];

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    };
}
