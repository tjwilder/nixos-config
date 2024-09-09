# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # Garbage collect old nix installs
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 14d";
  };

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # automatically put packages into the file
  environment.etc."current-system-packages".text =
  let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  powerManagement.enable = false;
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  networking.hostName = "nixos"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.gnome.gnome-keyring.enable = true;

  # Fix brave browser not opening

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  #services.xserver.enable = true;
  # Configure keymap in X11
  #services.xserver.xkb = {
  #  layout = "us";
  #  variant = "";
  #};
  #services.xserver.displayManager.startx.enable = true;
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  #services.desktopManager.plasma6.enable = true;

  # Enable cinnamon desktop
  services.xserver.desktopManager.cinnamon.enable = true;

  # Enable Wayland window manager (https://drakerossman.com/blog/wayland-on-nixos-confusion-conquest-triumph)
  # Allow configuring lower priviledged programs to talk to higher privledged ones
  security.polkit.enable = true;
  

	#  xdg = {
	#   autostart.enable = true;
	#   portal = {
	#      config.common.default = [ "*" ];
	#      xdgOpenUsePortal = true;
	#     enable = true;
	#     extraPortals = [
	#       pkgs.xdg-desktop-portal
	#       # pkgs.xdg-desktop-portal-gtk # Duplicated under cinnamon
	#       pkgs.xdg-desktop-portal-wlr
	#        pkgs.xdg-desktop-portal-hyprland
	#     ];
	#   };
	# };


  # NVIDIA GPU
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nouveau" ];
  # boot.initrd.kernelModules = [ "nvidia" ];
  boot.kernelModules = [ "nouveau" ];
  #boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  # Disable Intel Integrated GPU
  boot.kernelParams = [ "module_blacklist=i915" "nouveau.modeset=0" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      mesa.drivers
    ];
  };
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  #nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  programs.tmux = {
    enable = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      resurrect
      mode-indicator
      continuum
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tj = {
    isNormalUser = true;
    description = "tj";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [
      #pkgs.kdePackages.kate
      inputs.fix-python.packages."${pkgs.system}".default

    #  thunderbird
    ];
    useDefaultShell = true;
    shell = pkgs.zsh;
  };
  #onsider nushell for structured shell like powershell or xonsh for a python-powered shell 

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "tj";

  # Install firefox.
  programs.firefox.enable = true;

   # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Dev and Productivity
    #neovim
    nvim-pkg # The default kickstart-nix-nvim package added by the overlay
    git
    wget
    brave
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
    };
  };
  services.teamviewer.enable = true;
  systemd.timers."backup-unity" = {
  wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "backup-unity.service";
    };
};

systemd.services."backup-unity" = {
  script = ''
    set -eu

    cd /home/tj/code/unity/echoes-of-civilization
    if ${pkgs.coreutils}/bin/cmp --silent ./Temp/__Backupscenes/0.backup ./Temp-backup/0.backup; then
      echo "No backup necessary"
    else
      cp -f ./Temp-backup/4.backup ./Temp-backup/5.backup
      cp -f ./Temp-backup/3.backup ./Temp-backup/4.backup
      cp -f ./Temp-backup/2.backup ./Temp-backup/3.backup
      cp -f ./Temp-backup/1.backup ./Temp-backup/2.backup
      cp -f ./Temp-backup/0.backup ./Temp-backup/1.backup
      cp -f ./Temp/__Backupscenes/0.backup ./Temp-backup/0.backup
    fi
  '';
  serviceConfig = {
    Type = "oneshot";
    User = "tj";
  };
};

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  system.autoUpgrade = {
  enable = true;
  flake = inputs.self.outPath;
  flags = [
    "--update-input"
    "nixpkgs"
    "-L" # print build logs
  ];
  dates = "02:00";
  randomizedDelaySec = "45min";
};

}
