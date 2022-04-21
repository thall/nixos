{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.colordiff
    pkgs.gcc # Needed to compile / run Go programs
    pkgs.gnumake
    pkgs.google-cloud-sdk
    pkgs.jetbrains.goland
    pkgs.jetbrains.webstorm
    pkgs.jq
    pkgs.nodejs
    pkgs.ledger-live-desktop
    pkgs.patchelf
    pkgs.peek # tool for recording GIFs
    pkgs.python3
    pkgs.ripgrep
    pkgs.signal-desktop
    pkgs.spotify
    pkgs.tree
    pkgs.unzip
    pkgs.vlc
    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.yarn
    pkgs.yq
    pkgs.yubico-pam # https://nixos.wiki/wiki/Yubikey#Logging-in
    pkgs.yubikey-manager
  ];
  programs = {
    bash = {
      enable = true;
      historyIgnore = [ "ls" "cd" "exit" ];
      shellAliases = {
        urldec = "python -c \"import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))\"";
        urlenc = "python -c \"import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))\"";
        gf     = "git fetch";
        gs     = "git status";
        gp     = "git pull";
        xcp    = "xclip -selection c";
        gapit  = "gcloud auth print-identity-token";
     };
    };

    git = {
      enable = true;
      userName = "Niclas Thall";
      userEmail = "niclas.thall@einride.tech";
      aliases = {
        st = "status";
      };
      extraConfig = {
        pull = {
          rebase = "true";
        };
        commit = {
          verbose = "true";
       };
      };
    };

    gh = {
      enable = true;
    };

    go = {
      enable = true;
      package = pkgs.go_1_17;
      goPrivate = [ "github.com/einride" "go.einride.tech" ];
    };

    readline = {
      enable = true;
      variables = {
        completion-ignore-case = "on";
      };
    };

    tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 5000;
      keyMode = "vi";
      extraConfig = ''
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection
        bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'
      '';
    };

    vim = {
      enable = true;
      # plugins = with pkgs.vimPlugins; [ 
      #   vim-colors-solarized vim-terraform vim-go vim-protobuf 
      # ];
    };
  };

  # Add Go bin directory to $PATH
  # Add local bin directory to $PATH
  home.sessionPath = [ "~/go/bin" "~/.local/bin" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "thall";
  home.homeDirectory = "/home/thall";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
