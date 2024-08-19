{
  pkgs,
  inputs,
  outputs,
  ...
}: {
  imports = [
    outputs.homeManagerModules.devops
    outputs.homeManagerModules.zsh
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      outputs.overlays.unstable-packages
    ];
  };
  home.username = "vicnil";
  home.homeDirectory = "/home/vicnil";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".local/bin" = {
  #   source = ./scripts;
  #   recursive = true; # link recursively
  #   executable = true; # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  #xresources.properties = {
  #  "Xcursor.size" = 16;
  #  "Xft.dpi" = 172;
  #};

  ## Managed files by home-manager

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them
    # Nixvim related
    inputs.nixvim.packages.${system}.default
    ansible-lint
    tflint

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    bat
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    vault

    # networking tools
    mtr # A network diagnostic tool
    iperf3
    dnsutils # `dig` + `nslookup`
    doggo
    ldns # replacement of `dig`, it provide the command `drill`
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    openssl

    # misc
    file
    gawk
    gnupg
    gnused
    gnutar
    ncdu
    pandoc
    rbw
    tig
    tmux-xpanes
    tree
    which
    zstd

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor
    nurl

    # productivity
    atop
    btop # replacement of htop/nmon
    htop # Classic htop
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    powertop
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "vinylen";
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "kubernetes" = {
        disabled = false;
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    tmux = {
      enableShellIntegration = true;
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = true;
    historyLimit = 100000;
    baseIndex = 1;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    shell = "/home/vicnil/.nix-profile/bin/zsh";
    plugins = with pkgs; [
      tmuxPlugins.tmux-thumbs
      tmuxPlugins.sensible
      # must be before continuum edits right status bar
      {
        plugin = tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'macchiato'
          set -g @catppuccin_window_tabs_enabled on
          set -g @catppuccin_date_time "%H:%M"
        '';
      }
      {
        plugin = tmuxPlugins.resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'on'
          set -g @continuum-save-interval '10'
        '';
      }
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.yank
    ];
    extraConfig = ''
      # https://old.reddit.com/r/tmux/comments/mesrci/tmux_2_doesnt_seem_to_use_256_colors/
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
      set-environment -g COLORTERM "truecolor"

      # Xpanes sync
      bind S set -w synchronize-panes \; display "synchronize-panes is #{?pane_synchronized,on,off}"
      # Restart panes
      bind R respawn-pane -k \; display "Restarting pane"

      set-option -g set-titles on
      set-option -g set-titles-string '#H:#S.#I.#P #W #T'

      set -g @yank_selection_mouse 'clipboard' # or 'primary' or 'secondary'
    '';
  };

  programs.go = {
    enable = true;
  };

  programs.rbw = {
    enable = true;
    # package = customRbw;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.foot = {
    enable = true;
    server = {
      enable = true;
    };
    settings = {
      main = {
        term = "xterm-256color";
        font = "FiraCode Nerd Font:size=11";
        shell = "/home/vicnil/.nix-profile/bin/zsh";
      };
      scrollback = {
        lines = 100000;
      };
    };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  # programs.home-manager.enable = true;
}
