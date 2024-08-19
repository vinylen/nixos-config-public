{pkgs, ...}: {
  stylix.enable = false;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

  stylix.image = ../../wallpapers/derrick-cooper-L505cPnmIds-unsplash.jpg;
}
