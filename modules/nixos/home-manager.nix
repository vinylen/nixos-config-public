{
  inputs,
  outputs,
  nixpkgs,
  ...
}: {
  imports = [
    # Import home-manager's NixOS module
    inputs.home-manager.nixosModules.home-manager
  ];
  nixpkgs.config = {
    allowUnfree = true;
  };

  home-manager = {
    extraSpecialArgs = {inherit inputs outputs;};
    users = {
      # Import your home-manager configuration
      vicnil = import ../home-manager/home.nix;
    };
  };
}
