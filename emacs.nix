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
        after = [
          "lsp-mode"
          # "dap-ui" # enable to fix
        ];
        command = [ "dap-mode" "dap-auto-configure-mode" ];
        config = ''
          (dap-auto-configure-mode)
        '';
      };

      dap-ui = {
        enable = true;
        command = [ "dap-ui-mode" ];
        config = ''
          (dap-ui-mode t)
        '';
      };

      dap-lldb.enable = true;
    };
  };
}
