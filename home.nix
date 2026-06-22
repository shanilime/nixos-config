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

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  programs.zsh = {
    enable = true;

    #historySubstringSearch.enable = true;

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-dotfiles#nixos";
    };

    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" "history-substring-search" ];
    };

    syntaxHighlighting = {
      enable = true;
    };

    autosuggestion = {
      enable = true;
    };
  };
  programs.fzf.enable = true;
  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };
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
    alacritty
    vscode
    recaf-launcher
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
    prismlauncher
    jdk21
    kdePackages.kdialog
    android-tools
    python3
    lua51Packages.luarocks
  ];
}
