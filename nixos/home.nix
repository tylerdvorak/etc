{ config, pkgs, ... }:


#Test Home Flake for Tyler

{
  home.username = "tyler";
  home.homeDirectory = "/home/tyler";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
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

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "tylerdvorak";
    userEmail = "github@tylerdvorak.com";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    neofetch
    vim
    htop
    curl
    git
    tldr

    #terminal tools
    alacritty
    tmux

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    flameshot
    rofi
    synergy
    tmux

    #languages
    #python - need a version for this
    powershell

    # networking tools
    dnsutils  # `dig` + `nslookup`

    # misc
    cowsay
    file
    which

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    bitwarden
    discord
    firefox
    gimp
    onlyoffice-bin
    remmina
    teams
    trilium-desktop
    vscode
    
    #gaming
    lutris
    mangohud
    protonup-qt
    steam
    wine
    winetricks

    # system tools
    pciutils # lspci
    usbutils # lsusb
  ];

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      format = "($git_branch$git_state$git_status)$time $hostname-$username [»](bold green)[$directory](bold cyan)| ";

      git_branch ={
        style = "bold green";
        format = "[\\[[$branch$tag](bold green)\\]](bold white)";
      };

      git_status ={
       format = "'([\$conflicted$deleted$renamed$modified$staged$untracked$ahead_behind\]($style))'";
      };

      directory = {
        style = "bold cyan";
        truncate_to_repo = false;
        truncation_length = 1;
        fish_style_pwd_dir_length = 1;
      };

      python = {
        scan_for_pyfiles = false;
      };

      ruby = {
        disabled = true;
        format = "($git_branch$git_state$git_status)$time $hostname-$username [»](bold green)[$directory](bold cyan)| ";
      };

      swift = {
       disabled = true;
      };

      hostname = {
        ssh_only = false;
        format = "[$hostname]($style)";
        style = "bold white";
      };

      username = {
        show_always = true;
        style_user = "bold white";
        format = "[$user]($style)";
      };

      time = {
        disabled = false;
        format = "[$time]($style)";
        time_format = "%H:%M";
      };
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };
  
  #Enable Fish Shell and Nix Integration with Shell
  programs.fish = {
    enable = true;
    # set aliases
    #shellAbbr = {
    #test  = test
    #};
  };

  programs.nix-index.enableFishIntegration =  true;


  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}