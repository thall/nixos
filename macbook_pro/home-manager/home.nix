{ config, pkgs, ... }:

{

  home.packages = [
    pkgs.colordiff
    pkgs.htop
    pkgs.firefox
    pkgs.hypnotix
    pkgs.nixpkgs-fmt
    pkgs.vlc
  ];

  # Fix broken hypnotix package
  nixpkgs.overlays = [(
    final: prev:
    {
      hypnotix = prev.hypnotix.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
          ./../../patches/hypnotix/fix_remove_crash.patch
        ];
      });
    }
  )];

  programs = {
    bash = {
      enable = true;
      historyIgnore = [ "ls" "cd" "exit" ];
      # workaround to get the EDITOR env set. Assigning `sessionVariables` does not work.
      initExtra = '' export EDITOR="vim"
      '';
    };

    git = {
      enable = true;
      userName = "Niclas Thall";
      userEmail = "niclas.thall@gmail.com";
      aliases = {
        st = "status";
      };
      extraConfig = {
        pull = {
          rebase = "true";
        };
      };
    };

    gh = {
      enable = true;
    };

    vim = { 
      enable = true;
    };

    readline = {
      enable = true;
      variables = {
        completion-ignore-case = "on";
      };
    };
  };

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thall";
  home.homeDirectory = "/home/thall";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
