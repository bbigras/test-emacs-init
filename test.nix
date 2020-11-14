{ ... }:
let
  sources = import ./nix/sources.nix;
  pkgs = import sources.nixpkgs { };
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
    machine.succeed(
        "! (sudo -i -u bbigras /home/bbigras/.nix-profile/bin/emacs --batch -l /home/bbigras/.emacs.d/init.el 2>&1 | grep -q Error)"
    )
  '';
}
