{ pkgs, master-pkgs, timr-tui, inputs, ... }:

{
  home-manager.users.markd = { ... }: {
    nixpkgs.config.allowUnfree = true;

    imports = [ inputs.omarchy-nix.homeManagerModules.default ];

      home.stateVersion = "25.05";

      home.packages = [
        (pkgs.writeShellScriptBin "ittybit-git" ''
          git config user.name "Mark Dickie"
          git config user.email "md@ittybit.com"
          git config user.signkey "9B801503C0FCA9FB"
          git config commit.gpgsign true
        '')
        (pkgs.writeShellScriptBin "ericsson-git" ''
          git config user.name "Mark Dickie"
          git config user.email "mark.dickie@ericsson.com"
        '')
        pkgs.podman-compose
        pkgs.qemu
        pkgs.powerline-fonts
        pkgs.powerline-symbols
        pkgs.asciinema
        pkgs.asciinema-agg
        pkgs.websocat
        pkgs.slack
        pkgs.pgcli
        pkgs.refine
        pkgs.bruno
        pkgs.inxi
        pkgs.libreoffice
        pkgs.wireshark
        pkgs.dig
        pkgs.obs-studio
        pkgs.macchina
        pkgs.firmware-updater
        pkgs.pciutils
        pkgs.virtualgl
        pkgs.dysk
        pkgs.bottom
        pkgs.devenv
        pkgs.keepassxc
        pkgs.wob
        pkgs.swayimg
        pkgs.zathura
        pkgs.satty
        pkgs.superfile
        pkgs.taskwarrior3
        pkgs.taskwarrior-tui
        timr-tui.packages.x86_64-linux.default
        pkgs.slides
        pkgs.teams-for-linux
        pkgs.satty
        master-pkgs.intune-portal
        pkgs.nemu
        pkgs.virt-viewer
        pkgs.mpv
        pkgs.smassh
      ];

      programs.bash.enable = true;
      programs.gpg.enable = true;
      services.gpg-agent.enable = true;

      programs.oh-my-posh = {
        enable = true;
        enableBashIntegration = true;
        useTheme = "gruvbox";
      };

      home.shellAliases = {
        rebuild = "sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake github:deephack1982/nixos-config#frame1 --impure";
      };

      xdg.desktopEntries  = {
        slack = {
          name="Slack";
          comment="Slack Desktop";
          genericName="Slack Client for Linux";
          exec="slack -s --enable-features=UseOzonePlatform --ozone-platform=wayland %U";
          categories= [ "GNOME" "GTK" "Network" "InstantMessaging" ];
          mimeType=[ "x-scheme-handler/slack" ];
        };
      };

      home.sessionVariables = {
        GOOGLE_APPLICATION_CREDENTIALS = "/home/markd/Documents/Safe/google.json";
      };

      programs.distrobox = {
        enable = true;
      };

      programs.zellij = {
        enable = true;
        enableBashIntegration = true;
        attachExistingSession = true;
        exitShellOnExit = true;
        settings = {
          theme = "gruvbox-dark";
          default_layout = "welcome";
        };
      };

      programs.firefox = {
        enable = true;
        languagePacks = [ "en-GB" ];
      };

      programs.git = {
        enable = true;
        extraConfig = {
          init.defaultBranch = "main";
          url."ssh://git@github.com/" = { insteadOf = "gh:"; };
          url."ssh://git@github.com/ittybit/" = { insteadOf = "ib:"; };
        };
      };

      programs.zed-editor = {
        enable = true;
        extensions = [ "nix" "ruby" "terraform" "ansible" ];
        package = master-pkgs.zed-editor;
        extraPackages = [
          pkgs.ruby.gems.rubocop
          pkgs.ruby.gems.ruby-lsp
          pkgs.ruby.gems.rbs
          pkgs.nixd
          pkgs.terraform-ls
          pkgs.nil
        ];
        userSettings = {
          "lsp" = {
            "terraform-ls".initialization_options.experimentalFeatures.prefillRequiredFields = true;
            "ruby-lsp" = {
              "initialization_options" = {
                "enabledFeatures" = {
                  "diagnostics" = false;
                  "onTypeFormatting" = false;
                };
                "formatter" = "standard";
              };
              "settings".use_bundler = true;
            };
          };
          "nix" = {
            "language_servers" = [ "nil" "!nixd" ];
            "binary".path_lookup = true;
            "flake" = {
              autoArchive = true;
            };
          };
          "languages"."Ruby"."language_servers" = [ "ruby-lsp" "!solargraph" "..." ];
          "load_direnv" = "shell_hook";
          "theme" = {
            "mode" = "dark";
            "light" = "One Light";
            "dark" = "Ayu Dark";
          };
        };
      };

      programs.home-manager.enable = true;
      programs.fzf.enable = true;

      programs.ssh = {
        enable = true;
        addKeysToAgent = "yes";
        matchBlocks = {
          "ittybit-robots.com" = {
            user = "markd";
            identityFile = "/home/markd/.ssh/google_compute_engine";
            host = "*.ittybit-robots.com";
          };
          "vs-ssh.visualstudio.com" = {
            user = "markd";
            identityFile = "/home/markd/.ssh/google_compute_engine";
            host = "vs-ssh.visualstudio.com";
          };
          "*" = { setEnv.TERM = "xterm-256color"; };
        };
      };
    };
}
