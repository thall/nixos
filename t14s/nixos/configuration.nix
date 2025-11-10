# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Network
  # networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
  # networking.useDHCP = false;
  # networking.interfaces.enp2s0f0.useDHCP = true;
  # networking.interfaces.wlp3s0.useDHCP = true;
  networking.networkmanager.enable = true;
  networking.hostName = "t14s";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "sv-latin1";
  };

  # Enable the Plasma 6 Desktop Environment.
  services.displayManager.sddm = {
    enable = true;
    wayland = {
      enable = true;
      compositor = "kwin";
    };
  };
  services.desktopManager.plasma6 = {
    enable = true;
  };

  # Enable fwupd
  services.fwupd.enable = true;

  # Enable Monero deamon
  services.monero = {
    enable = true;
    mining = {
      enable = true;
      address = "43svaEVQXdWYFhtV52Gda4EigEwJNKhzB38S9MJWy2PFQdANwZ52mymaZ6GCjjXRBeQdT63UzBBUpUo9DA6WAUdwGNLRvM9";
    };
    rpc = {
      address = "0.0.0.0";
    };
    extraConfig = ''
      confirm-external-bind=1
      prune-blockchain=1
      sync-pruned-blocks=1
    '';
  };

  # Enable input-remapper to rebind enter / delete
  services.input-remapper = {
    enable = true;
  };

  # Use Plasma5 Ksshaskpass front-end for ssh-add
  programs.ssh.startAgent = true;

  programs.dconf.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "se";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable xdg portal to get screen sharing to work on wayland
  xdg.portal = {
    enable = true;
  };

  # Support running non-nix binaries.
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # Enable sound with PipeWire
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;

    # alsa.enable = true;
    # alsa.support32Bit = true;
    pulse.enable = true;

    # Disable headset unit profile
    extraConfig.pipewire = {
      "51-disable-hfp" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
        "monitor.bluez.properties" = {
          "bluez5.roles" = ["a2dp_sink" "a2dp_source"];
        };
      };
    };
  };

  # Disable hspfpd
  hardware.bluetooth.hsphfpd.enable = false;

  # Ledger udev rules
  # Required for Ledger Live to detect Ledger Nano S Plus via USB
  # https://github.com/LedgerHQ/udev-rules/blob/2776324af6df36c2af4d2e8e92a1c98c281117c9/20-hw1.rules
  # Assigns `thall` as owner.
  services.udev.extraRules = ''
    # HW.1, Nano
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2581", ATTRS{idProduct}=="1b7c|2b7c|3b7c|4b7c", TAG+="uaccess", TAG+="udev-acl"

    # Blue, NanoS, Aramis, HW.2, Nano X, NanoSP, Stax, Ledger Test,
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", TAG+="uaccess", TAG+="udev-acl"

    # Same, but with hidraw-based library (instead of libusb)
    KERNEL=="hidraw*", ATTRS{idVendor}=="2c97", MODE="0666"

    # Ledger Test, Nano S Plus (idProduct=5011)
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="2c97", ATTRS{idProduct}=="0005|5000|5001|5002|5003|5004|5005|5006|5007|5008|5009|500a|500b|500c|500d|500e|500f|5010|5011|5012|5013|5014|5015|5016|5017|5018|5019|501a|501b|501c|501d|501e|501f", TAG+="uaccess", TAG+="udev-acl", OWNER="thall"
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.thall = {
    createHome = true;
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"]; # Enable ‘sudo’ for the user.
    hashedPassword = "$y$j9T$sU3lpd2amgKqGT.Kt7tMw.$9zfpPau/plHgvLAmge7OJbmtw7H3TI5gARLARGMboa0";
  };

  # Allow unfree software
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [];

  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
