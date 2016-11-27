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


  networking.wireless.enable = true;  # Enables wireless.
  networking.firewall.enable = false;
  networking.extraHosts = ''
    127.0.0.1 nixos
    127.0.0.1 edgarcube
  '';

  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "sv-latin1";
    defaultLocale = "en_US.UTF-8";
  };
  time.timeZone = "Europe/Stockholm";

  environment = {
    systemPackages = with pkgs; [
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
      openjdk
      firefox
      rofi
      rtorrent
      rxvt_unicode
      spotify
      strace
      sudo
      tmux
      termite
      unrar
      unzip
      vim
      vlc
      wget
      xfontsel
      xlibs.xf86inputsynaptics
      zip
    ];
    extraInit = ''
      # Java
      export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
  };

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
  hardware.pulseaudio = {
    enable = true;
    zeroconf.discovery.enable = true;
#    package = pkgs.pulseaudioFull;
#    tcp.enable = true;
  };

  # Enable the X11 windowing system.
  services = {
    avahi.enable = true;
    printing = {
      enable = true;
      gutenprint = true;
    };
    xserver = {
      autorun = true;
      enable = true;
      layout = "se";
      multitouch.enable = true;
      resolutions = [ { x = 1600; y = 900; } ];

      libinput = {
        enable = true;
        clickMethod = "clickfinger";
        tapping = false; 
      };

      windowManager = {
        default = "xmonad";
        xmonad.enable = true;
        xmonad.enableContribAndExtras = true;
      };

      displayManager = {
        slim = {
          enable = true;
          defaultUser = "niclast";
        };
        sessionCommands = ''
          xsetroot -cursor_name left_ptr
          xrdb -merge ~/.Xresources
          feh --bg-scale ~/nix-wallpaper-simple-blue.png &
          '';
      };

      desktopManager = {
        default = "none";
        xterm.enable = false;
      };
    };
    logstash = {
      enable = true;
      inputConfig = ''
        # Read from journal
        pipe {
          command => "${pkgs.systemd}/bin/journalctl -f -o json"
          type => "syslog"
          codec => "json"
        }
      '';
      outputConfig = ''
        elasticsearch {
                hosts => "172.20.0.2:9200"
        }
      '';

    };
  };

  users.mutableUsers = false;
  users.extraUsers.thall = {
    extraGroups = [ "wheel" "cdrom" "disk" "audio" "docker" ];
    isNormalUser = true;
    uid = 1000;
    passwordFile = "/etc/passwd.d/thall.passwd";
  };
  users.extraUsers.niclast = {
    extraGroups = [ "wheel" "cdrom" "disk" "audio" "docker" "libvirt" ];
    isNormalUser = true;
    uid = 1001;
    passwordFile = "/etc/passwd.d/niclast.passwd";
  };
  security.sudo.enable = true;

  programs.bash = {
    enableCompletion = true;
    interactiveShellInit = ''
      export EDITOR=vim

      PS1='[\w]$ '

      export PROMPT_COMMAND="history -a"
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

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
  };

  system.stateVersion = "17.09";
}

