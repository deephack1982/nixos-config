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
      pkgs.podman-compose
      pkgs.qemu
      pkgs.powerline-fonts
      pkgs.powerline-symbols
      pkgs.asciinema
      pkgs.asciinema-agg
      pkgs.websocat
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
    ];

    programs.bash.enable = true;
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;

    home.shellAliases = {
      rebuild = "sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake github:deephack1982/nixos-config#dickie --impure";
    };

    home.sessionVariables = {
      GOOGLE_APPLICATION_CREDENTIALS = "/home/markd/Documents/Safe/google.json";
    };

    programs.distrobox = {
      enable = true;
    }

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
        "*" = { setEnv.TERM = "xterm-256color"; };
      };
    };
  };
}
