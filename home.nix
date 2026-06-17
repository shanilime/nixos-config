{ config, pkgs, ... }:

let
  dotfiles = "${config.home.homeDirectory}/nixos-dotfiles/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  configs = {
    nvim = "nvim";
    alacritty = "alacritty";
    mpv = "mpv";
  };
in

{
  home.username = "shani";
  home.homeDirectory = "/home/shani";
  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings = {
      user.name = "ShaniLime";
      user.email = "92034736+shanilime@users.noreply.github.com";
      init.defaultBranch = "main";
    };
  };


  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
    };
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  programs.zsh.enable = true;
  programs.fzf.enable = true;
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
  programs.zsh.syntaxHighlighting.enable = true;
  programs.gh.enable = true;

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    btop
    fastfetch
    firefox
    unzip
    zip
    yt-dlp
    alacritty
    vscode
    prismlauncher
    recaf-launcher
    osu-lazer
    qbittorrent
    obs-studio
    anydesk
    rustdesk
    telegram-desktop
    claude-code
    mpv
    discord
    tree-sitter
    obsidian
  ];
}
