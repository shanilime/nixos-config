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
  documentation.nixos.enable = false;

  nixpkgs.config.nvidia.acceptLicense = true;

  hardware.nvidia = {
    modesetting.enable = true;
    open = false; # 470xx не поддерживает open-source ядро
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

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      swtpm.enable = true;
    };
  };
  users.groups.libvirtd.members = [ "shani" ];
  programs.virt-manager.enable = true;
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  programs.kdeconnect.enable = true;
  programs.zsh.enable = true;

  users.users.shani = {
    shell = pkgs.zsh;
  };

  networking.firewall = rec {
    allowedTCPPortRanges = [{ from = 1714; to = 1764; }];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    pciutils
    tree
    dnsmasq
    xclip
  ];

  programs.throne.enable = true;
  programs.throne.tunMode.enable = true;

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    qrca # Qrca - сканер QR-кодов
    konsole # Konsole
    discover # Discover
    okular # Okular
    elisa # Elisa (плеер)
    khelpcenter # Help Center
    gwenview # Gwenview
  ];

  services.xserver.excludePackages = with pkgs; [
    xterm
  ];

  services.journald.extraConfig = ''
    MaxLevelStore=warning
  '';


  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  networking.nftables.enable = true;

  system.stateVersion = "26.05";
}
