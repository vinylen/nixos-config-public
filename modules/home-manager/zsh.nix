# vim: ft=nix
{
  programs.zsh = {
    enable = true;
    antidote.enable = true;
    antidote.plugins = [
      "ohmyzsh/ohmyzsh path:plugins/magic-enter"
      "ohmyzsh/ohmyzsh path:lib/key-bindings.zsh"
      "zsh-users/zsh-syntax-highlighting"
      "zsh-users/zsh-completions"
      "zshzoo/cd-ls"
    ];
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting.enable = true;
    history = {
      # path = "$HOME/.config/home-manager/zsh/${HOSTNAME}/.zsh_history";
      save = 1000000;
      size = 1000000;
    };
    localVariables = {
      "LC_ALL" = "en_US.UTF-8";
    };
    initExtra = ''
      # Exports!
      export PATH="\${"KREW_ROOT:-$HOME/.krew"}/bin:"$HOME"/.local/bin:$PATH"
      export FZF_DEFAULT_OPTS="--bind ctrl-a:toggle-all,ctrl-d:deselect-all --color 16,hl:bright-red,hl+:reverse:yellow,info:bright-black,marker:reverse:-1,pointer:bright-cyan --marker +"
      export EDITOR=nvim
      export VISUAL=$EDITOR
      export VDPAU_DRIVER=va_gl

      fpath+=(/usr/share/zsh/site-functions)
      setopt incappendhistory

      function os_info {
        [[ -n $OS_CLOUD ]] || return

        local username=$(yq e '.clouds['\"$OS_CLOUD\"'].auth.username' ~/.config/openstack/clouds.yaml)
        local color=$(yq e '.clouds['\"$OS_CLOUD\"'].custom.prompt' ~/.config/openstack/clouds.yaml)

        [[ $color == "null" ]] && color=cyan
        [[ ! -z $OS_REGION ]] && region=/$OS_REGION

        echo '('%{$fg[$color]%}''${username}@''${OS_CLOUD}''${region}%{$reset_color%}') '
      }

      function vault_search_for_certificate(){
          str=$1
          vault_list_certificates | grep -B2 $str
      }

    '';
    shellAliases = {
      "cd" = "z";
      "ls" = "eza";
      "ll" = "ls -la";
      "llt" = "eza --tree";
      "k" = "kubectl";
      "load_openstack_env" = "source ~/.config/openstack/os-venv/bin/activate && export OS_PASSWORD=$(rbw get openstack)";
      "ospass" = "LIST=$(rbw list) && NAME=$(echo $LIST | grep -i openstack | fzf --tac) && export OS_PASSWORD=$(rbw get $NAME)";
      "osunset" = "unset OS_CLOUD OS_REGION_NAME OS_PASSWORD";
      "k9s" = "k9s --insecure-skip-tls-verify";
      "terraform" = "tofu";
      "nix-flake-commit" = "git commit -m 'Nix flake update' -a && git push";
      "vault-auth" = "vault login -method=ldap username=vicnil password=$(rbw get AD-Logon)";
      "nix-root" = "sudo env PATH=$PATH"; #Run nix programs as root
    };
  };
}
