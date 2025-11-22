{ pkgs, master-pkgs, timr-tui, inputs, ... }:
let
  codexTools = inputs.nix-ai-tools.packages.${pkgs.system};
in
{
  home-manager.users.markd = { ... }: {
    nixpkgs.config.allowUnfree = true;

    imports = [ inputs.omarchy-nix.homeManagerModules.default inputs.zen-browser.homeModules.twilight ];

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
      # pkgs.devenv
      pkgs.keepassxc
      pkgs.zathura
      pkgs.satty
      pkgs.superfile
      pkgs.taskwarrior3
      pkgs.taskwarrior-tui
      pkgs.satty
      pkgs.nemu
      pkgs.virt-viewer
      pkgs.mpv
      pkgs.smassh
      pkgs.gum
      codexTools.codex
    ];

    programs.bash.enable = true;
    programs.gpg.enable = true;
    services.gpg-agent.enable = true;

    programs.oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      useTheme = "gruvbox";
    };

    programs.distrobox = {
      enable = true;
    };

    programs.zellij = {
      enable = true;
      settings = {
        theme = "tokyo-night-dark";
        default_layout = "welcome";
      };
    };

    home.shellAliases = {
      rebuild = "sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake github:deephack1982/nixos-config#dickie --impure";
    };

    home.sessionVariables = {
      GOOGLE_APPLICATION_CREDENTIALS = "/home/markd/Documents/Safe/google.json";
    };

    programs.firefox = {
      enable = true;
      languagePacks = [ "en-GB" ];
    };

    programs.zen-browser = {
      enable = true;
      nativeMessagingHosts = [ pkgs.firefoxpwa ];
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

    programs.helix = {
      enable = true;
      settings = {
        theme = "tokyonight";
        editor.lsp.display-messages = true;
      };
      extraPackages = [
        pkgs.nil
        pkgs.terraform-ls
        pkgs.ruby-lsp
      ];
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
