{ config, pkgs, ... }:

{

  home.packages = [
    pkgs.htop
    pkgs.firefox
    pkgs.hypnotix
    pkgs.nixpkgs-fmt
    pkgs.vlc
  ];

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


  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "thall";
  home.homeDirectory = "/home/thall";

  # This value determines the Home Manager release that your configuration is compatible with. This helps avoid breakage when a new Home Manager release introduces 
  # backwards incompatible changes.
  #
  # You can update Home Manager without changing this value. See the Home Manager release notes for a list of state version changes in each release.
  home.stateVersion = "22.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
