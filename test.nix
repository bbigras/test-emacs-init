{ pkgs, ... }:
let
  sources = import ./nix/sources.nix;

  helloWorld = pkgs.writeScriptBin "helloWorld" ''
    #!${pkgs.stdenv.shell}

    set -euxo pipefail

    mkdir -p /home/bbigras/
    touch /tmp/bleh.rs

    mkdir -p /home/bbigras/Dropbox/emacs
    touch /home/bbigras/Dropbox/emacs/custom-server.el

    sudo -i -u bbigras /home/bbigras/.nix-profile/bin/emacs -l /home/bbigras/.emacs.d/early-init.el --batch -l /home/bbigras/.emacs.d/init.el --eval "(progn (setq lsp-restart 'ignore) (find-file \"/tmp/bleh.rs\") )"

    sudo -i -u bbigras /home/bbigras/.nix-profile/bin/emacs -l /home/bbigras/.emacs.d/early-init.el --batch -l /home/bbigras/.emacs.d/init.el --eval "(progn (setq lsp-restart 'ignore) (find-file \"/tmp/bleh.rs\") )" 2>&1 | (! grep -q Error)
  '';
in
{
  name = "test-emacs-init";
  nodes.machine = { ... }: {
    imports = [
      (import (sources.home-manager + "/nixos"))
    ];

    users.users.bbigras = {
      createHome = true;
      isNormalUser = true;
    };

    home-manager.users.bbigras = { pkgs, ... }: {
      imports = [ ./emacs.nix ];

      programs.emacs = {
        enable = true;
        init.enable = true;
      };
    };
  };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")
    machine.succeed("${helloWorld}/bin/helloWorld")
  '';
}
