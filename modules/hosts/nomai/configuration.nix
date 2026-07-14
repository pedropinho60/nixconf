# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ self, inputs, ... }: {
    flake.nixosModules.nomaiConfiguration = { pkgs, lib, ... }: {
      imports =
        [ # Include the results of the hardware scan.
          self.nixosModules.nomaiHardware
          self.nixosModules.niri
          self.nixosModules.nvim
          self.nixosModules.nh
        ];

      nix.channel.enable = false;
      nixpkgs.config.allowUnfree = true;

      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      fileSystems = {
        "/".options = [ "compress=zstd" ];
        "/home".options = [ "compress=zstd" ];
        "/nix".options = [ "compress=zstd" "noatime" ];
      };
    
      services.btrfs.autoScrub.enable = true;
    
      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    
      networking.hostName = "nomai"; # Define your hostname.
    
      # Configure network connections interactively with nmcli or nmtui.
      networking.networkmanager.enable = true;
    
      # Set your time zone.
      time.timeZone = "America/Fortaleza";
    
      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    
      # Select internationalisation properties.
      i18n.defaultLocale = "pt_BR.UTF-8";
      console = {
        font = "Lat2-Terminus16";
        useXkbConfig = true;
      };
    
      # Enable the X11 windowing system.
      # services.xserver.enable = true;

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };

        nvidia = {
          open = true;
          modesetting.enable = false;

          prime = {
            offload = {
              enable = true;
              enableOffloadCmd = true;
            };

            amdgpuBusId = "PCI:5@0:0:0";
            nvidiaBusId = "PCI:1@0:0:0";
          };
        };
      };

      services.xserver.videoDrivers = [ 
        "amdgpu"
        "nvidia" 
      ];
      
    
      # Configure keymap in X11
      services.xserver.xkb = {
        layout = "br";
        variant = "abnt2";
      };
    
      # Enable CUPS to print documents.
      services.printing.enable = true;
    
      # Enable sound.
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = false;
      };

      # Enable touchpad support (enabled default in most desktopManager).
      # services.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.pedro = {
        isNormalUser = true;
        extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
        packages =   [
        ];
      };

      virtualisation.libvirtd.enable = true;
      programs.virt-manager.enable = true;

      programs.firefox.enable = true;

      programs.steam.enable = true;
      programs.gamemode.enable = true;

      programs.obs-studio = {
        enable = true;
        package = pkgs.obs-studio.override { cudaSupport = true; };
      };

      programs.direnv.enable = true;

      # List packages installed in system profile.
      # You can use https://search.nixos.org/ to find more packages (and options).
      environment.systemPackages = with pkgs; [
        git
        kitty
        vim
        wget
        wl-clipboard
        inputs.helium.packages.${stdenv.hostPlatform.system}.default
        mangohud
        appimage-run
        heroic
        protonplus
        waywall
        prismlauncher
        jetbrains.idea
        jdk
        nautilus
        discord
        eden
      ];

      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      # programs.mtr.enable = true;
      # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      # services.openssh.enable = true;

      # Open ports in the firewall.
      # networking.firewall.allowedTCPPorts = [ ... ];
      # networking.firewall.allowedUDPPorts = [ ... ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # Copy the NixOS configuration file and link it from the resulting system
      # (/run/current-system/configuration.nix). This is useful in case you
      # accidentally delete configuration.nix.
      # system.copySystemConfiguration = true;

      nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 14d";
      };

      # This option defines the first version of NixOS you have installed on this particular machine,
      # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
      #
      # Most users should NEVER change this value after the initial install, for any reason,
      # even if you've upgraded your system to a new NixOS release.
      #
      # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
      # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
      # to actually do that.
      #
      # This value being lower than the current NixOS release does NOT mean your system is
      # out of date, out of support, or vulnerable.
      #
      # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
      # and migrated your data accordingly.
      #
      # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
      system.stateVersion = "26.05"; # Did you read the comment?
    
    };
}
