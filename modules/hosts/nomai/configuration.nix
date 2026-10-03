# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nomaiConfiguration = {pkgs, ...}: {
    imports = [
      # Include the results of the hardware scan.
      self.nixosModules.nomaiHardware
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
    services.power-profiles-daemon.enable = true;

    boot.loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    networking.hostName = "nomai";

    networking.networkmanager.enable = true;
    systemd.network.wait-online.enable = false;

    # Set your time zone.
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

      bluetooth = {
        enable = true;
        powerOnBoot = false;
      };

      xpadneo.enable = true;
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
    services.printing = {
      enable = true;
      drivers = [pkgs.epson-escpr];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.epsonscan2];
    };

    # Enable sound.
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.pedro = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "networkmanager"
        "uinput"
        "scanner"
        "lp"
      ];
    };

    programs.obs-studio = {
      enable = true;
      package = pkgs.obs-studio.override {cudaSupport = true;};
    };

    programs.direnv = {
      enable = true;
      silent = true;
    };

    programs.localsend.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    # List packages installed in system profile.
    # You can use https://search.nixos.org/ to find more packages (and options).
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
      noctalia
      nbfc-linux
    ];

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

    systemd.services.nbfc_service = {
      enable = true;
      description = "NoteBook FanControl service";
      serviceConfig.Type = "simple";
      path = [pkgs.kmod];

      script = "${pkgs.nbfc-linux}/bin/nbfc_service --config-file '/home/pedro/.config/nbfc.json'";

      wantedBy = ["multi-user.target"];
    };

    programs.niri.package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri.wrap {
      settings = {
        outputs = {
          "LG Electronics LG ULTRAWIDE 0x000073D5" = {
            position = _: {
              props = {
                x = 1536;
                y = 0;
              };
            };
            mode = "2560x1080@74.991";
            focus-at-startup = _: {};
          };
          "BOE 0x0818 Unknown" = {
            position = _: {
              props = {
                x = 0;
                y = 108;
              };
            };
            scale = 1.25;
          };
        };

        debug.ignore-drm-device = "/dev/dri/renderD128";
      };
    };

    environment.etc."alsa-card-profile/mixer/paths/analog-input-headset-mic.conf".source = pkgs.runCommand "patched-headset-mic.conf" {} ''
      sed 's/^priority = .*/priority = 90/' \
      ${pkgs.pipewire}/share/alsa-card-profile/mixer/paths/analog-input-headset-mic.conf > $out
    '';

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
