# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = true;
    };

    packageOverrides = pkgs: with pkgs; {

      mplayer = pkgs.mplayer.override {
        vdpauSupport = true;
        pulseSupport = true;
      };
    };
  };


  networking.hostName = "thall"; # Define your hostname.
  networking.hostId = "7ba8afd9";
  networking.wireless.enable = true;  # Enables wireless.
  networking.firewall.enable = false;

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "sv-latin1";
    defaultLocale = "en_US.UTF-8";
  };
  time.timeZone = "Europe/Stockholm";

  environment.systemPackages = with pkgs; [
    colordiff
    curl
    dmenu
    feh
    git
    glxinfo
    gnumake
    google-chrome
    haskellPackages.xmobar
    htop
    hwinfo
    lsof
    man
    mplayer
    pavucontrol
    pciutils
    firefox
    rtorrent
    rxvt_unicode
    strace
    sudo
    tmux
    unrar
    unzip
    vim
    vlc
    wget
    xfontsel
    xlibs.xf86inputsynaptics
    zip
  ];

  fonts = {
    enableFontDir = true;
    enableCoreFonts = true;
    enableGhostscriptFonts = true;	
    fonts = with pkgs; [	
      dejavu_fonts
      freefont_ttf
      inconsolata
      terminus_font
    ];
  };

  # Sound 
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable the X11 windowing system.
  services.xserver = {
    autorun = true;
    enable = true;
    layout = "se";
    multitouch.enable = true;
    synaptics = {
      enable = true;
      tapButtons = false;
      additionalOptions = ''
        Option "TapButton1" "0"
        Option "TapButton2" "0"
        Option "TapButton3" "0"
        '';
    };
    deviceSection = ''
      Option "NoLogo" "true"
      '';

    windowManager = {
      default = "xmonad";
      xmonad.enable = true;
      xmonad.enableContribAndExtras = true;
    };

    displayManager = {
      slim = {
        enable = true;
        defaultUser = "thall";
      };
      sessionCommands = ''
        xsetroot -cursor_name left_ptr
        xrdb -merge ~/.Xresources
        '';
    };

    desktopManager = {
      default = "none";
      xterm.enable = false;
    };
  };

  users.mutableUsers = false;
  users.extraUsers.thall = {
    extraGroups = [ "wheel" "cdrom" "disk" "audio" "docker" ];
    isNormalUser = true;
    uid = 1000;
    passwordFile = "/etc/passwd.d/thall.passwd";
  };
  security.sudo.enable = true;

  programs.bash = {
    enableCompletion = true;
    interactiveShellInit = ''
      export EDITOR=vim

      # Java
      export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
      export _JAVA_AWT_WM_NONREPARENTING=1

      PS1='[\w]$ '
      '';
    shellAliases = {
      ls="ls --color=auto";
      l="ls -alh";
      ll="ls -alh";
      diff="colordiff";
      grep="grep -i --color=auto";
      less="less -R";
      livestreamer="livestreamer --player mplayer";
      tmux="tmux -2";
    };
  };
  programs.light.enable = true;

  virtualisation.docker.enable = true;

  system.stateVersion = "16.03";
}

