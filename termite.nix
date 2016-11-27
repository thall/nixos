{ config, pkgs, ... }:

{
  environment = {
    systemPackages = [ pkgs.termite];
    etc."xdg/termite/config".text = ''
      [options]
      font = Inconsolata 6
      
      [colors]
      background = rgba(10, 10, 10, 0.70)
    '';
  };
}
