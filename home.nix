{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "kdomasze";
  home.homeDirectory = "/home/kdomasze";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    pkgs.git
    pkgs.alacritty
    pkgs.starship
    pkgs.oh-my-zsh
    pkgs.zsh
    pkgs.nil
    pkgs.eza
    pkgs.rustup
    pkgs.vscode

    (pkgs.nerdfonts.override { fonts = ["FiraCode"] ;})

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    ".config/alacritty/alacritty.toml".source = alacritty/alacritty.toml;
    ".oh-my-zsh/custom/init.zsh".source = oh-my-zsh/custom/init.zsh;
    ".oh-my-zsh/custom/aliases.zsh".source = oh-my-zsh/custom/aliases.zsh;
    ".config/Code/User/settings.json".source = vscode/settings.json;
    ".config/OpenRGB/Rainbow Barf.orp".source = openRGB/RainbowBarf.orp;
    ".config/OpenRGB/sizes.ors".source = openRGB/sizes.ors;

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
  #  /etc/profiles/per-user/kdomasze/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "code";
  };

  programs = {
    git = {
      enable = true;
      userName = "Kyle Domaszewicz";
      userEmail = "kyledomaszewicz@gmail.com";
      lfs.enable = true;
      extraConfig = {
        init = {
          defaultBranch = "main";
        };
        # changes needed to resolve weird issue with git failing with vscode extensions and other repos with large change sets
        core = {
          packedGitLimit = "1g";
          packedGitWindowSize = "1g";
          compression = "9";
        };
        pack = {
          deltaCacheSize = "1g";
          packSizeLimit = "1g";
          windowMemory = "2g";
        };
      };
    };

    alacritty = {
      enable = true;
    };

    starship = { 
      enable = true;
    };

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["git" "aliases" "bgnotify" "branch" "colored-man-pages" "command-not-found" "dnf" "extract" "git-commit" "gitfast" "git-lfs" "jsontools" "ng" "node" "nodenv" "nvm" "rust" "safe-paste" "starship" "sudo" "universalarchive" "virtualenv" "zoxide"];
        theme = "";
        custom = "$HOME/.oh-my-zsh/custom";
      };
    };

    vscode = {
      enable = true;
      extensions =  with (import (builtins.fetchGit {
                          url = "https://github.com/nix-community/nix-vscode-extensions";
                          ref = "refs/heads/master";
                          rev = "c43d9089df96cf8aca157762ed0e2ddca9fcd71e";
                    })).extensions.x86_64-linux.vscode-marketplace; [
        aaron-bond.better-comments
        alefragnani.bookmarks
        formulahendry.code-runner
        codeium.codeium
        vadimcn.vscode-lldb
        serayuzgur.crates
        coenraads.disableligatures
        usernamehw.errorlens
        tamasfe.even-better-toml
        wengerk.highlight-bad-chars
        vincaslt.highlight-matching-tag
        oderwat.indent-rainbow
        emilast.logfilehighlighter
        pkief.material-icon-theme
        jnoortheen.nix-ide
        christian-kohler.path-intellisense
        mechatroner.rainbow-csv
        rust-lang.rust-analyzer
        ryu1kn.text-marker
        gruntfuggly.todo-tree
      ];
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
  };
}
