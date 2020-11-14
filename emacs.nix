{ ... }:
let
  nurNoPkgs = import (import ./nix/sources.nix).NUR { };
in
{
  imports = [
    nurNoPkgs.repos.rycee.hmModules.emacs-init
  ];

  programs.emacs.init = {
    enable = true;
    usePackage = {
      lsp-mode = {
        enable = true;
        command = [ "lsp" ];
      };

      dap-mode = {
        enable = true;
        after = [ "lsp-mode" ];
        command = [ "dap-mode" "dap-auto-configure-mode" ];
        config = ''
          (dap-auto-configure-mode)
        '';
      };

      dap-lldb.enable = true;
    };
  };
}
