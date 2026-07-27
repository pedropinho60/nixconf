{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {
    pkgs,
    lib,
    ...
  }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };

    environment.systemPackages = [
      pkgs.kdePackages.breeze
    ];
  };

  perSystem = {
    pkgs,
    lib,
    self',
    inputs',
    ...
  }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;

      extraSettings = [
        {include = [{optional = true;} "~/.config/niri/config.kdl"];}
      ];

      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.noctalia)
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

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

        input = {
          keyboard = {
            xkb = {
              layout = "br";
              options = "ctrl:nocaps";
            };

            numlock = _: {};
          };

          touchpad = {
            tap = _: {};
            natural-scroll = _: {};
          };

          mouse = {
            accel-profile = "flat";
          };

          focus-follows-mouse = _: {
            props = {max-scroll-amount = "0%";};
          };
        };

        cursor = {
          xcursor-theme = "breeze_cursors";
          xcursor-size = 24;
          hide-after-inactive-ms = 2000;
        };

        layout = {
          gaps = 10;

          border = {
            width = 4;
            active-color = "#7fc8ff";
            inactive-color = "#505050";

            urgent-color = "#9b0000";
          };

          focus-ring.off = _: {};
        };

        blur = {
          passes = 3;
          offset = 5.0;
        };

        hotkey-overlay.skip-at-startup = _: {};

        window-rules = [
          {
            matches = [
              {
                app-id = "firefox$";
                title = "^Picture-in-Picture$";
              }
            ];
            open-floating = true;
          }
          {
            geometry-corner-radius = 12;
            clip-to-geometry = true;
          }
          {
            matches = [
              {
                app-id = "localsend_app";
              }
            ];
            open-floating = true;
          }
        ];

        prefer-no-csd = _: {};

        debug.ignore-drm-device = "/dev/dri/renderD128";

        binds = {
          "Mod+T".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Q".close-window = _: {};
          "Mod+B".spawn-sh = lib.getExe inputs'.helium.packages.default;

          "Mod+O".toggle-overview = _: {};

          "Mod+H".focus-column-left = _: {};
          "Mod+J".focus-window-down = _: {};
          "Mod+K".focus-window-up = _: {};
          "Mod+L".focus-column-right = _: {};

          "Mod+Ctrl+H".move-column-left = _: {};
          "Mod+Ctrl+J".move-window-down = _: {};
          "Mod+Ctrl+K".move-window-up = _: {};
          "Mod+Ctrl+L".move-column-right = _: {};

          "Mod+Shift+H".focus-monitor-left = _: {};
          "Mod+Shift+J".focus-monitor-down = _: {};
          "Mod+Shift+K".focus-monitor-up = _: {};
          "Mod+Shift+L".focus-monitor-right = _: {};

          "Mod+Shift+Ctrl+H".move-column-to-monitor-left = _: {};
          "Mod+Shift+Ctrl+J".move-column-to-monitor-down = _: {};
          "Mod+Shift+Ctrl+K".move-column-to-monitor-up = _: {};
          "Mod+Shift+Ctrl+L".move-column-to-monitor-right = _: {};

          "Mod+Home".focus-column-first = _: {};
          "Mod+End".focus-column-last = _: {};

          "Mod+Ctrl+Home".move-column-to-first = _: {};
          "Mod+Ctrl+End".move-column-to-last = _: {};

          "Mod+U".focus-workspace-down = _: {};
          "Mod+I".focus-workspace-up = _: {};

          "Mod+Shift+U".move-workspace-down = _: {};
          "Mod+Shift+I".move-workspace-up = _: {};

          "Mod+Ctrl+U".move-column-to-workspace-down = _: {};
          "Mod+Ctrl+I".move-column-to-workspace-up = _: {};

          "Mod+WheelScrollUp" = _: {
            props = {
              cooldown-ms = 150;
            };
            content = {
              focus-workspace-up = _: {};
            };
          };
          "Mod+WheelScrollDown" = _: {
            props = {
              cooldown-ms = 150;
            };
            content = {
              focus-workspace-down = _: {};
            };
          };

          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;

          "Mod+Ctrl+1".move-column-to-workspace = 1;
          "Mod+Ctrl+2".move-column-to-workspace = 2;
          "Mod+Ctrl+3".move-column-to-workspace = 3;
          "Mod+Ctrl+4".move-column-to-workspace = 4;
          "Mod+Ctrl+5".move-column-to-workspace = 5;
          "Mod+Ctrl+6".move-column-to-workspace = 6;
          "Mod+Ctrl+7".move-column-to-workspace = 7;
          "Mod+Ctrl+8".move-column-to-workspace = 8;
          "Mod+Ctrl+9".move-column-to-workspace = 9;

          "Mod+R".switch-preset-column-width = _: {};
          "Mod+Shift+R".switch-preset-window-height = _: {};
          "Mod+Ctrl+R".reset-window-height = _: {};

          "Mod+F".maximize-column = _: {};
          "Mod+Shift+F".fullscreen-window = _: {};
          "Mod+Ctrl+F".maximize-window-to-edges = _: {};
          "Mod+Ctrl+Shift+F".toggle-windowed-fullscreen = _: {};

          "Mod+C".center-column = _: {};

          "Mod+Minus".set-column-width = "-10%";
          "Mod+Equal".set-column-width = "+10%";

          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Equal".set-window-height = "+10%";

          "Mod+V".toggle-window-floating = _: {};
          "Mod+Shift+V".switch-focus-between-floating-and-tiling = _: {};

          "Mod+W".toggle-column-tabbed-display = _: {};

          "Print".screenshot = _: {};
          "Ctrl+Print".screenshot-screen = _: {};
          "Alt+Print".screenshot-window = _: {};

          "Mod+Escape" = _: {
            props = {
              allow-inhibiting = false;
            };
            content = {
              toggle-keyboard-shortcuts-inhibit = _: {};
            };
          };

          "Mod+Shift+E".quit = _: {};

          "Mod+Shift+P".power-off-monitors = _: {};

          "Mod+G".set-dynamic-cast-window = _: {};
          "Mod+Shift+G".set-dynamic-cast-monitor = _: {};
          "Mod+Ctrl+G".clear-dynamic-cast-target = _: {};

          "Mod+P" = _: {
            props = {
              repeat = false;
            };
            content = {
              spawn-sh = let
                wl-mirror = "${pkgs.wl-mirror}/bin/wl-mirror";
                niri = lib.getExe pkgs.niri;
                jq = lib.getExe pkgs.jq;
              in "${wl-mirror} $(${niri} msg --json focused-output | ${jq} -r .name)";
            };
          };

          "Mod+D".spawn-sh = "${lib.getExe self'.packages.noctalia} ipc call launcher toggle";
        };
      };
    };
  };
}
