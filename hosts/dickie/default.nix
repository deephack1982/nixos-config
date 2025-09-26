{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  networking.hostName = "dickie";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "swiotlb=65536"
    "coherent_pool=64M"
    "cma=512M"
  ];

  hardware.deviceTree.enable = true;

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
 console = {
      keyMap = "sv-latin1";
      font = "${pkgs.powerline-fonts}/share/consolefonts/ter-powerline/v20n.psf.gz";
 };

 services.greetd = {
   enable = true;
   settings.default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
 };

  services.xserver = {
    enable = true;
  };
  security.rtkit.enable = true;

  services.xserver.xkb.layout = "se";

  system.stateVersion = "25.05";
}
