{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Minsk";

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # KDE Plasma 6 + SDDM
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = false;
  services.desktopManager.plasma6.enable = true;

  nixpkgs.config.nvidia.acceptLicense = true;

  hardware.nvidia = {
  modesetting.enable = true;
  open = false;  # 470xx не поддерживает open-source ядро
  package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };

  # Звук
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.shani = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "input" ];
  };

  programs.kdeconnect.enable = true;
  networking.firewall = rec {
  allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  allowedUDPPortRanges = allowedTCPPortRanges;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    pciutils
    tree
  ];

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  system.stateVersion = "26.05";
}
