{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.vmConfiguration = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.vmHardware
      self.nixosModules.niri
      self.nixosModules.nvim
      self.nixosModules.nh
    ];

    nix.channel.enable = false;

    nix.settings.experimental-features = ["nix-command" "flakes"];

    programs.niri.package = lib.mkForce (self.packages.${pkgs.stdenv.hostPlatform.system}.niri.wrap {
      settings.outputs."Virtual-1" = {
        mode = "1920x1080";
        scale = 1.0;
      };
    });

    # Bootloader.
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda";
    boot.loader.grub.useOSProber = true;

    networking.hostName = "nixos"; # Define your hostname.
    networking.networkmanager.enable = true;

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

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "br";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "br-abnt2";

    users.users.pedro = {
      isNormalUser = true;
      description = "Pedro";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;

    environment.sessionVariables = {
      TERMINAL = "kitty";
      EDITOR = "nvim";
    };

    systemd.user = {
      services = {
        spice-agent = {
          wantedBy = [
            "graphical-session.target"
          ];
          serviceConfig = {
            ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";
          };
          description = "Spice guest session agent";
          after = ["graphical-session-pre.target"];
          partOf = ["graphical-session.target"];
        };
      };
    };

    environment.systemPackages = with pkgs; [
      git
      kitty
      firefox
      spice-vdagent
      wl-clipboard
    ];

    system.stateVersion = "25.11";
  };
}
