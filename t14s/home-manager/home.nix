{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.binutils # readelf
    pkgs.colordiff
    pkgs.curl
    pkgs.lsof
    pkgs.kdePackages.kleopatra
    pkgs.htop
    pkgs.hypnotix
    pkgs.hwinfo
    pkgs.jetbrains.goland
    pkgs.jq
    pkgs.ledger-live-desktop
    pkgs.monero-cli
    pkgs.monero-gui
    pkgs.nixpkgs-fmt
    pkgs.pciutils
    pkgs.peek # tool for recording GIFs
    pkgs.python3
    pkgs.ripgrep
    pkgs.signal-desktop
    pkgs.spotify
    pkgs.tree
    pkgs.tor-browser
    pkgs.unzip
    pkgs.usbutils
    pkgs.vlc
    pkgs.vscode
    pkgs.wget
    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.yq
  ];

  # Fix broken hypnotix package
  # nixpkgs.overlays = [(
  #   final: prev:
  #   {
  #     hypnotix = prev.hypnotix.overrideAttrs (old: {
  #       patches = (old.patches or []) ++ [
  #         ./attribute-missing-fix.patch
  #       ];
  #     });
  #   }
  # )];

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-qt;
  };

  programs = {
    gpg.enable = true;
    alacritty = {
      enable = true;
      settings = {
        terminal = {
          shell.program = "${pkgs.tmux}/bin/tmux";
        };
        window = {
          padding = {
            x = 4;
            y = 0;
          };
          dynamic_padding = true;
          decorations = "full";
          startup_mode = "Maximized";
          title = "terminal";
          dynamic_title = true;
        };

        font = {
          normal = {
            family = "Hack";
          };
          size = 10.0;
        };

        selection = {
          save_to_clipboard = true;
        };

        general = {
          live_config_reload = true;
        };
      };
    };

    bash = {
      enable = true;
      historyIgnore = [ "ls" "cd" "exit" ];
      shellAliases = {
        g = "git";
        gcaan = "git commit -a --amend --no-edit";
        gchma = "git checkout master && git fetch && git reset --hard origin/master";
        grexec = "git rebase --exec='cd backend && make' origin/master";
        gau = "git add -u";
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
        hme = "home-manager edit";
        hms = "home-manager switch";
        xcp = "xclip -selection c";
      };
      # workaround to get the EDITOR env set.
      # Assigning `sessionVariables` does not work.
      # LESSQUIET, see https://github.com/wofr06/lesspipe/issues/103
      initExtra = ''
        export EDITOR="vim"
        export LESSQUIET="true"
      '';
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
          gpgSign = "true";
        };
        gpg = {
          format = "ssh";
        };
        user = {
          signingKey = "${config.home.homeDirectory}/.ssh/id_ed25519";
        };
      };
    };

    gh = {
      enable = true;
    };

    readline = {
      enable = true;
      variables = {
        completion-ignore-case = "on";
      };
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

  # Add Go bin directory to $PATH
  # Add local bin directory to $PATH
  home.sessionPath = [ "~/go/bin" "~/.local/bin" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "thall";
  home.homeDirectory = "/home/thall";

  nix = {
    package = pkgs.nix;
    settings.experimental-features = [ "nix-command" "flakes" ];
  };
  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";
}
