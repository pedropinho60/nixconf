{self, ...}: {
  flake.nixosModules.gaming = {pkgs, ...}: {
    imports = [
      self.nixosModules.prismlauncher
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs = {
      steam.enable = true;
      gamemode.enable = true;
    };

    services = {
      sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
      };

      udev.extraRules = ''
        ATTRS{name}=="Sony Interactive Entertainment Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
        ATTRS{name}=="Wireless Controller Touchpad", ENV{LIBINPUT_IGNORE_DEVICE}="1"
      '';
    };

    environment.systemPackages = with pkgs; [
      steam-run
      heroic

      mangohud
      protonplus
      gamescope

      eden

      (osu-lazer-bin.override {nativeWayland = true;})
    ];
  };
}
