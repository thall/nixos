{ config, pkgs, ... }:

{

  # https://github.com/NixOS/nixpkgs/issues/196651
  manual.manpages.enable = false;

  home.packages = [
    pkgs.binutils # readelf
    pkgs.colordiff
    pkgs.curl
    pkgs.gcc # Needed to compile / run Go programs
    pkgs.gnumake
    pkgs.google-cloud-sdk
    pkgs.htop
    pkgs.jetbrains.clion
    pkgs.jetbrains.goland
    pkgs.jetbrains.idea-community
    pkgs.jetbrains.webstorm
    pkgs.jq
    pkgs.kleopatra
    pkgs.ledger-live-desktop
    pkgs.maven # Apache maven
    pkgs.monero-cli
    pkgs.monero-gui
    pkgs.nixpkgs-fmt
    pkgs.nodejs-18_x
    pkgs.patchelf
    pkgs.pavucontrol
    pkgs.pciutils
    pkgs.peek # tool for recording GIFs
    pkgs.python3
    pkgs.ripgrep
    pkgs.signal-desktop
    pkgs.spotify
    pkgs.terraform
    pkgs.tree
    pkgs.unzip
    pkgs.usbutils
    pkgs.vlc
    pkgs.vscode
    pkgs.wget
    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.yarn
    pkgs.yq
    pkgs.yubico-pam # https://nixos.wiki/wiki/Yubikey#Logging-in
    pkgs.yubikey-manager
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 8;
            y = 8;
          };
          dynamic_padding = true;
          decorations = "none";
          startup_mode = "Maximized";
          title = "terminal";
          dynamic_title = true;
        };

        font = {
          normal = {
            family = "Hack";
          };
          size = 8.0;
        };

        selection = {
          save_to_clipboard = true;
        };

        live_config_reload = true;
      };
    };

    bash = {
      enable = true;
      historyIgnore = [ "ls" "cd" "exit" ];
      shellAliases = {
        gapit = "gcloud auth print-identity-token";
        g = "git";
        gcaan = "git commit -a --amend --no-edit";
        gd = "git diff";
        gdc = "git diff --cached";
        gf = "git fetch";
        gl = "git log";
        gp = "git pull";
        gsh = "git show";
        gs = "git status";
        gri = "git rebase -i HEAD~10";
        grc = "git rebase --continue";
        grh = "git reset --hard";
        gpfl = "git push --force-with-lease";
        gpuh = "git push";
        urldec = "python -c \"import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))\"";
        urlenc = "python -c \"import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))\"";
        xcp = "xclip -selection c";
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
      package = pkgs.go_1_19;
      goPrivate = [ "github.com/einride" "go.einride.tech" ];
      goPath = "go";
      goBin = "go/bin";
    };

    readline = {
      enable = true;
      variables = {
        completion-ignore-case = "on";
      };
    };

    java = {
      enable = true;
      package = pkgs.openjdk17;
    };

    firefox = {
      enable = true;
    };

    tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 5000;
      keyMode = "vi";
      terminal = "screen-256color";
      extraConfig = ''
        # Colors
        set -g default-terminal "tmux-256color" 
        set -ga terminal-overrides ",xterm-termite:Tc"

        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection
        bind-key -T copy-mode-vi r send-keys -X rectangle-toggle
        bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

        # Open new tab / window in CWD
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind c new-window -c "#{pane_current_path}"

        # Windows
        set -g xterm-keys on
        set -g base-index 1

        # Panes
        bind-key -n S-Left select-pane -L
        bind-key -n S-Right select-pane -R
        bind-key -n S-Up select-pane -U
        bind-key -n S-Down select-pane -D
      '';
    };

    vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-airline
      ];
      extraConfig = ''
        syntax on
        set t_Co=256
      '';
    };
  };

  home.file.".local/bin/patch_interpreter" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      set -eEuo pipefail
      patchelf --set-interpreter "$(nix-build --no-out-link "<nixpkgs>" -A glibc)/lib64/ld-linux-x86-64.so.2" "$@"
    '';
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
