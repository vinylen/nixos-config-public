{
  pkgs,
  outputs,
  ...
}: {
  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [
      outputs.overlays.unstable-packages
      outputs.overlays.modifications
    ];
  };

  home.packages = with pkgs; [
    argocd
    ansible
    kind
    kubectl
    kubectx
    kubernetes-helm
    swiftclient
    opentofu
    unstable.openstackclient-full
    k9s
    lastpass-cli
    (writeShellApplication {
      name = "kctx";
      runtimeInputs = [kubectl fzf];
      text = ''
        kubectl config get-contexts -o name \
        | fzf --height=10 \
        | xargs kubectl config use-context
      '';
    })
    (writeShellApplication {
      name = "kns";
      runtimeInputs = [kubectl fzf];
      text = ''
        kubectl get namespaces -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' \
          | fzf --height=10 \
          | xargs kubectl config set-context --current --namespace
      '';
    })
  ];
}
