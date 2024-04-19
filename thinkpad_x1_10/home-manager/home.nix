{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.binutils # readelf
    pkgs.colordiff
    pkgs.curl
    pkgs.gcc # Needed to compile / run Go programs
    pkgs.glxinfo
    pkgs.gnumake
    pkgs.google-cloud-sdk
    pkgs.htop
    pkgs.hwinfo
    pkgs.hypnotix
    pkgs.jetbrains.goland
    pkgs.jq
    pkgs.ledger-live-desktop
    pkgs.lsof
    pkgs.lshw
    pkgs.monero-cli
    pkgs.monero-gui
    pkgs.nixpkgs-fmt
    pkgs.nodejs-18_x
    pkgs.pciutils
    pkgs.peek # tool for recording GIFs
    pkgs.python3
    pkgs.qgis
    pkgs.ripgrep
    pkgs.signal-desktop
    pkgs.spotify
    pkgs.terraform
    pkgs.tree
    pkgs.unzip
    pkgs.usbutils
    pkgs.vlc
    pkgs.vscode
    pkgs.vulkan-tools
    pkgs.wayland-utils
    pkgs.wget
    pkgs.wl-clipboard
    pkgs.xclip
    pkgs.yarn
    pkgs.yq
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = {
        shell.program = "${pkgs.tmux}/bin/tmux";
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


        live_config_reload = true;
      };
    };

    bat = {
      enable = true;
    };

    bash = {
      enable = true;
      historyIgnore = [ "ls" "cd" "exit" ];
      shellAliases = {
        cat="bat";
        gapit = "gcloud auth print-identity-token";
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
        urldec = "python -c \"import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))\"";
        urlenc = "python -c \"import sys, urllib.parse as ul; print (ul.quote_plus(sys.argv[1]))\"";
        xcp = "xclip -selection c";
      };
      # workaround to get the EDITOR env set.
      # Assigning `sessionVariables` does not work.
      # LESSQUIET, see https://github.com/wofr06/lesspipe/issues/103
      initExtra = ''
        export EDITOR="vim"
        export LESSQUIET="true"
        # source <(bookctl completion bash)
        # source <(deliverctl completion bash)
        # source <(orchestratectl completion bash)
        # source <(ownctl completion bash)
        # source <(sagaiamctl completion bash)
        # source <(collector completion bash)
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

    go = {
      enable = true;
      package = pkgs.go_1_21;
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
      defaultEditor = true;
      plugins = with pkgs.vimPlugins; [
        vim-airline
      ];
      extraConfig = ''
        syntax on
        set t_Co=256
        " Syntax highlight, sensible colors for git commit verbose
        hi diffAdded   ctermfg=green
        hi diffRemoved ctermfg=red
      '';
    };
  };

  # Add Go bin directory to $PATH
  # Add local bin directory to $PATH
  home.sessionPath = [ "~/go/bin" "~/.local/bin" ];
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
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/thall/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
