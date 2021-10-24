{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (vim_configurable.customize {
      name = "vim";
      vimrcConfig.customRC = 
        ''
        syntax on
        set encoding=utf-8
        set expandtab
        set tabstop=2
        set shiftwidth=2
        '';
    })
  ];
}

