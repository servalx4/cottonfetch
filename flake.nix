{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }: 
  let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    packages.x86_64-linux.default = pkgs.writeShellApplication {
      name = "cottonfetch";
      
      runtimeInputs = [
        pkgs.pciutils
        pkgs.mesa-demos
      ];

      text = builtins.readFile ./cottonfetch;
      checkPhase = "";
    };

    apps.x86_64-linux.default = {
      type = "app";
      program = "${self.packages.x86_64-linux.default}/bin/cottonfetch";
    };
  };
}
