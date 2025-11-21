{ config, pkgs, lib, ... }:

{
  imports = [
    <nixos-hardware/framework/13-inch/intel-core-ultra-series1>
    ./hardware.nix
  ];

  networking.hostName = "frame1";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 0;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 3;
  boot.kernelParams = ["quiet" "udev.log_level=0" "splash" "boot.shell_on_fail" "rd.systemd.show_status=auto"];
  boot.kernelPackages = pkgs.linuxPackages_latest;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt          # for newer GPUs on NixOS >24.05 or unstable
      vaapiIntel
      intel-media-driver
    ];
  };
  hardware.enableRedistributableFirmware = true;

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "tokyo-night";
  };


  programs.uwsm = {
    enable = true;
  };

  services.fwupd = {
    enable = true;
    extraRemotes = [ "lvfs-testing" ];
    uefiCapsuleSettings.DisableCapsuleUpdateOnDisk = true;
  };

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Configure keymap in X11
   services.xserver.xkb = {
     layout = "gb";
     variant = "";
   };

   # Configure console keymap
   console.keyMap = "us";
   console.font = "Lat2-Terminus16";

   programs.gnupg.agent.enable = true;

   # Sudoers config
   security.sudo = {
     enable = true;
     wheelNeedsPassword = false;
     extraRules = [{
      commands = [
        {
          command = "${pkgs.podman}/bin/podman'";
          options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
     }];
   };

   services.udev.extraRules = ''
       SUBSYSTEMS=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="304e", MODE="0666", GROUP="plugdev"
     '';

  environment.systemPackages = with pkgs; [
      tokyo-night-sddm
      logitech-udev-rules
      libsForQt5.qtgraphicaleffects
  ];

  networking.wg-quick.interfaces.wg0 = {
    autostart = false;

    # IP(s) you get on the VPN
    address = [ "10.8.0.2/32" ];

    # Where you store your private key (chmod 600)
    privateKeyFile = "/etc/wireguard/wg0.key";

    # Optional preshared key
    # presharedKeyFile = "/etc/wireguard/wg0.psk";

    peers = [
      {
        # Public key of the *server* you’re connecting to
        publicKey = "FqLfw7g7sMOqVj9bzj7sOuXfa7en7P7k/rfpJSdXOXU=";

        # Route everything over the tunnel:
        allowedIPs = [ "10.8.0.0/24" "10.132.0.0/24" "10.53.0.0/24" ];

        # Endpoint of your WireGuard server
        endpoint = "vpn.ittybit-robots.com:51820";

        # Keep NATs happy
        persistentKeepalive = 25;
      }
    ];
  };

   system.stateVersion = "25.05";
}
