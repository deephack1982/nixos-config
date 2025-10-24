{ config, pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "markd" ];
  };

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "Europe/Stockholm";

  services.xserver.enable = true;

  users.users.markd = {
    isNormalUser = true;
    description = "Mark Dickie";
    extraGroups = [ "networkmanager" "wheel" "podman" "adbusers" "video" "render" "plugdev" ];
    packages = with pkgs; [
    ];
  };

  virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
  };

  security.polkit.enable = true;

  services.power-profiles-daemon.enable = true;

  programs = {
    mtr.enable = true;
    direnv.enable = true;
    wshowkeys.enable = true;
  };

  services.devmon.enable = true;
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Networking
  services.resolved.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  networking = {
    networkmanager.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    nerd-fonts.caskaydia-mono
  ];

}
