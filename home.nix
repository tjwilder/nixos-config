{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neofetch
    httpie
    xdg-utils
    chromium
    git
    mautrix-whatsapp

    # Chat
    beeper
    discord
    slack

    # Art
    inkscape-with-extensions

    # Terminals (multiple for testing only)
    #contour
    warp-terminal
    kitty
    alacritty
    wezterm
    st

    # commandline
    zsh
    zinit
    ripgrep
    thefuck
    wl-clipboard
    bambu-studio
    blender
    zip
    unzip

    # Utils
    grim  # screenshot functionality
    slurp # screenshot functionality
    mako # Notification system
    wl-clipboard # wl-copy and wl-paste
    wl-clipboard-x11

    # networking
    ngrok

    # Dev
    unityhub
    isoimagewriter
    ventoy
    # Cloud
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "tj";
  home.homeDirectory = "/home/tj";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  #programs.xdg-utils.enable = true;
  programs.git.includes = [ { path = "~/nixos-config/git/.gitconfig.local"; } ];
  programs.zsh = {
  
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch";
  };
  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };
    oh-my-zsh = {
    enable = true;
    plugins = [ "git" "thefuck" ];
    theme = "robbyrussell";
  };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      modifier = "Mod4";
      terminal = "kitty";
      startup = [
        {command = "brave";}
      ];
    };
  };
  #config = rec {
  #  terminal = "contour";
  #};
#  services.matrix-appservices = {
#    services = {
#      whatsapp = {
#        port = 29183;
#	format = "mautrix-go";
#	package = pkgs.mautrix-whatsapp;
#      };
#    };
#  };
}
