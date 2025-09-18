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
    extraGroups = [ "networkmanager" "wheel" "podman" "adbusers" "video" "render" ];
    packages = with pkgs; [
    ];
  };

  virtualisation.containers.enable = true;
    virtualisation = {
      podman = {
        enable = true;

        # Create a `docker` alias for podman, to use it as a drop-in replacement
        # dockerCompat = true;

        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
  };

  security.polkit.enable = true;

  services.power-profiles-daemon.enable = true;

  programs.mtr.enable = true;
}
