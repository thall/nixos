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
      enableAdobeFlash = true;
    };

    chromium = {
      enablePepperFlash = true; # Chromium removed support for Mozilla (NPAPI) plugins so Adobe Flash no longer works 
      enablePepperPDF = true;
      enableNaCl = true;
      enableWideVine = true;
      pulseSupport = true;
    };
    packageOverrides = pkgs: with pkgs; {
      mumble = pkgs.mumble.override {
        pulseSupport = true;
      };

      mplayer = pkgs.mplayer.override {
        vdpauSupport = true;
        pulseSupport = true;
      };
    };
  };

  # Use the gummiboot efi boot loader.
  boot.loader.gummiboot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices = [{
    name = "luksroot"; device = "/dev/sdb2";
  }];
  boot.tmpOnTmpfs = true;
  boot.kernel.sysctl = { "vm.swappiness" = 10; }; #SSD OPTIMIZATION

  fileSystems."/".options = "defaults,noatime,discard";
  fileSystems."/boot".options = "defaults,noatime,discard";

  swapDevices = [ { device = "/swapfile"; } ];

  networking.hostName = "thall"; # Define your hostname.
  networking.hostId = "7ba8afd9";
  networking.wireless.enable = true;  # Enables wireless.
  networking.wireless.driver = "wext"; #MBP2009 specific
  networking.firewall.enable = false;

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "sv-latin1";
    defaultLocale = "en_US.UTF-8";
  };
  time.timeZone = "Europe/Stockholm";

  environment.systemPackages = with pkgs; [
    wget vim tmux curl sudo
    colordiff
    lsof
    strace
    htop
    man
    rxvt_unicode
    zip
    xfontsel
    git
    gnumake
    pciutils
    unrar
    hwinfo
    pkgs.firefoxWrapper 
    glxinfo
    chromium
    xlibs.xf86inputsynaptics

    mplayer
    feh
    rtorrent
    vlc
    mumble

    haskellPackages.xmobar
    dmenu

    pavucontrol
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
    videoDrivers = [ "nvidiaLegacy340" ];
    vaapiDrivers = [ pkgs.vaapiVdpau ];
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

  users.extraUsers.thall = {
    createHome = true;
    home = "/home/thall";
    extraGroups = [ "wheel" "cdrom" "disk" "audio" ];
    isNormalUser = true;
    uid = 1000;
    useDefaultShell = true;
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
    };
  };

  system.stateVersion = "15.09";
}

