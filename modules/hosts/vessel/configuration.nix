{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.vesselConfiguration = {pkgs, ...}: {
    imports = [
      self.nixosModules.vesselHardware
      self.nixosModules.niri
      self.nixosModules.nvim
      self.nixosModules.nh
      self.nixosModules.kitty
      self.nixosModules.git
      self.nixosModules.gaming
    ];

    nix.channel.enable = false;
    nixpkgs.config.allowUnfree = true;

    boot.kernel.sysctl = {"vm.swappiness" = 10;};

    boot.kernelPackages = pkgs.linuxPackages_latest;

    nix.settings.experimental-features = ["nix-command" "flakes"];

    boot.tmp.useTmpfs = true;

    services.fstrim.enable = false;
    services.btrfs.autoScrub.enable = true;

    services.gvfs.enable = true;

    services.upower.enable = true;

    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        memtest86.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };

    networking.hostName = "vessel";

    networking.networkmanager.enable = true;
    systemd.network.wait-online.enable = false;

    time.timeZone = "America/Fortaleza";

    i18n.defaultLocale = "pt_BR.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true;
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };

      bluetooth = {
        enable = true;
        powerOnBoot = false;
      };

      sane = {
        enable = true;
        extraBackends = [pkgs.hplipWithPlugin pkgs.epsonscan2];
      };
    };

    services.xserver.videoDrivers = [
      "amdgpu"
    ];

    services.printing = {
      enable = true;
      drivers = [pkgs.epson-escpr];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users.pedro = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "uinput"
        "scanner"
        "lp"
        "i2c"
      ];
    };

    programs.obs-studio.enable = true;

    programs.direnv = {
      enable = true;
      silent = true;
    };

    programs.localsend.enable = true;

    services.tailscale.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    environment.systemPackages = with pkgs; [
      wl-clipboard
      inputs.helium.packages.${stdenv.hostPlatform.system}.default
      jetbrains.idea
      jdk
      nautilus
      discord
      keepassxc
      btop
      qpdf
      inkscape
      foliate
      loupe
      piper
      mpv
      fastfetch
      libreoffice
      hunspell
      hunspellDicts.pt_BR
      man-pages
      man-pages-posix
      gnome-themes-extra
      nwg-look
      polkit_gnome
      parsec-bin
      maven
      krita
      ddcutil
      qbittorrent
    ];

    services.lact.enable = true;
    hardware.amdgpu.overdrive.enable = true;

    services.hardware.openrgb = {
      enable = true;
      package = pkgs.openrgb-with-all-plugins;
    };

    hardware.i2c.enable = true;

    programs.nix-ld.enable = true;

    fonts.packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
    ];

    programs.dconf.enable = true;

    services.cloudflare-warp.enable = true;

    services.syncthing = {
      enable = true;
      openDefaultPorts = true;

      user = "pedro";
      dataDir = "/home/pedro";
      configDir = "/home/pedro/.config/syncthing";

      settings = {
        devices = {
          "SM-A556E" = {id = "TY74HVD-2WJ3CY3-FBZON46-S4RKGUS-Y5TG2GX-WQR4OGT-ZHUHEPX-IPPLAAW";};
        };
        folders = {
          "KeepassXC" = {
            path = "/home/pedro/Documentos/KeepassXC";
            devices = ["SM-A556E"];
          };
        };
      };
    };

    services.ratbagd.enable = true;

    programs.niri.package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri.wrap {
      settings = {
        outputs = {
          "LG Electronics LG ULTRAWIDE 0x000073D5" = {
            mode = "2560x1080@74.991";
            variable-refresh-rate = _: {};
          };
        };
      };
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    security.polkit.enable = true;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    services.displayManager.noctalia-greeter = {
      enable = true;

      settings = {
        appearance.scheme = "Rosé Pine";
        cursor.size = 24;
        keyboard.layout = "br";

        output = {
          name = "DP-1";
          scale = 1;
          refresh_rate = 75;
        };
      };

      cursorTheme = {
        package = pkgs.kdePackages.breeze;
        name = "breeze_cursors";
      };
    };

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

    system.stateVersion = "26.05";
  };
}
