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
      self.nixosModules.nomaiHardware
      self.nixosModules.nvim
      self.nixosModules.git
    ];

    nix.channel.enable = false;
    nixpkgs.config.allowUnfree = true;

    nix.settings.experimental-features = ["nix-command" "flakes"];

    boot.tmp.useTmpfs = true;

    services.fstrim.enable = false;
    services.btrfs.autoScrub.enable = true;

    services.gvfs.enable = true;

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

    time.timeZone = "America/Fortaleza";

    i18n.defaultLocale = "pt_BR.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };

    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true;
    };

    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    users.users."rejane" = {
      isNormalUser = true;
      description = "Rejane";
      extraGroups = [
        "wheel"
        "networkmanager"
        "uinput"
        "scanner"
        "lp"
        "i2c"
      ];
    };

    users.users."pedro" = {
      isNormalUser = true;
      description = "Pedro";
      extraGroups = [
        "wheel"
        "networkmanager"
        "uinput"
        "scanner"
        "lp"
        "i2c"
      ];
    };

    programs.firefox.enable = true;

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
        powerOnBoot = true;
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
    services.printing = {
      enable = true;
      drivers = [pkgs.epson-escpr];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services = {
      desktopManager.plasma6.enable = true;

      displayManager.plasma-login-manager.enable = true;
    };

    hardware.sane = {
      enable = true;
      extraBackends = [pkgs.epsonscan2];
    };

    programs.localsend.enable = true;

    services.tailscale.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    environment.systemPackages = with pkgs; [
      keepassxc
      libreoffice
      hunspell
      hunspellDicts.pt_BR
      man-pages
      man-pages-posix
      moonlight-qt
    ];

    hardware.i2c.enable = true;

    fonts.packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
      corefonts
      vista-fonts
    ];

    services.cloudflare-warp.enable = true;

    environment.etc."alsa-card-profile/mixer/paths/analog-input-headset-mic.conf".source = pkgs.runCommand "patched-headset-mic.conf" {} ''
      sed 's/^priority = .*/priority = 90/' \
      ${pkgs.pipewire}/share/alsa-card-profile/mixer/paths/analog-input-headset-mic.conf > $out
    '';

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    system.autoUpgrade = {
      enable = true;

      flake = "github:pedropinho60/nixconf";

      dates = "daily";
      randomizedDelaySec = "45min";

      operation = "boot";
    };

    system.stateVersion = "26.05";
  };
}
