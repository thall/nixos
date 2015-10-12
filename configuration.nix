	# Edit this configuration file to define what should be installed on
	# your system.  Help is available in the configuration.nix(5) man page
	# and in the NixOS manual (accessible by running ‘nixos-help’).

	{ config, pkgs, ... }:

	{
	  imports =
	    [ # Include the results of the hardware scan.
	      ./hardware-configuration.nix
	    ];
	  # TODO
	  #  FONT,
	nixpkgs.config.allowUnfree = true;

	  # Use the gummiboot efi boot loader.
	  boot.loader.gummiboot.enable = true;
	  boot.loader.efi.canTouchEfiVariables = true;
	  boot.initrd.kernelModules = [ "fbcon"];
	  boot.initrd.luks.devices = [{
		name = "luksroot"; device = "/dev/sdb2";
	  }];

          fileSystems."/".options = "defaults,noatime,discard";
          fileSystems."/boot".options = "defaults,noatime,discard";

	  swapDevices = [ { device = "/swapfile"; } ];

	  networking.hostName = "thall"; # Define your hostname.
	  networking.hostId = "7ba8afd9";
	  networking.wireless.enable = true;  # Enables wireless.

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

		xlibs.xf86inputsynaptics

		mplayer
		feh
		rtorrent
		vlc

		haskellPackages.xmobar
		dmenu

		# Sound
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
	

  # Enable the X11 windowing system.
  services.xserver = {
	autorun = false;
	enable = true;
  	videoDrivers = [ "nvidiaLegacy340" ];
  	# vaapiDrivers = [ pkgs.vaapiIntel pkgs.vaapiVdpau ];
  	layout = "se";
  	multitouch.enable = true;
  	synaptics.enable = true;
  	synaptics.tapButtons = false;

  	windowManager = {
		default = "xmonad";
  		xmonad.enable = true;
  		xmonad.enableContribAndExtras = true;
	};

	displayManager = {
		slim = {
			enable = true;
			defaultUser = "thall";
#			theme = pkgs.slimThemes.nixosSlim;
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
  services.printing.enable = true;

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
			export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
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

