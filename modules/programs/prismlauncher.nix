{self, ...}: {
  flake.nixosModules.prismlauncher = {pkgs, ...}: {
    environment.systemPackages = [self.packages.${pkgs.stdenv.hostPlatform.system}.prismlauncher];
  };

  perSystem = {pkgs, ...}: let
    pname = "prismlauncher";
    version = "9.4";

    src = pkgs.fetchurl {
      url = "https://github.com/PrismLauncher/PrismLauncher/releases/download/9.4/PrismLauncher-Linux-x86_64.AppImage";
      hash = "sha256-3uCnVkYiA85Z0t43dYO6DCxDENCFNwfENKRwG7P+gjw=";
    };

    appimageContents = pkgs.appimageTools.extract {
      inherit pname version src;
    };
  in {
    packages.prismlauncher = pkgs.appimageTools.wrapType2 {
      inherit pname version src;

      extraPkgs = pkgs:
        with pkgs; [
          glfw3-minecraft
          waywall
        ];

      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/*.desktop -t $out/share/applications

        if [ -d "${appimageContents}/usr/share/icons" ]; then
          cp -r ${appimageContents}/usr/share/icons $out/share
        fi
      '';
    };
  };
}
