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
    theme = "tokyo-night-sddm";
    extraPackages = [ pkgs.tokyo-night-sddm ];
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
   console.keyMap = "uk";
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
       SUBSYSTEMS=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="35ca", ATTRS{idProduct}=="101d", MODE="0666", GROUP="plugdev"
     '';

   system.stateVersion = "25.05";
}
