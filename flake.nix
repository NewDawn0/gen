{
  description = "An extensible project generator";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nix-systems.url = "github:nix-systems/default";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs (import inputs.nix-systems);
      mkPkgs = system:
        import nixpkgs {
          inherit system;
          overlays = [ inputs.rust-overlay.overlays.default ];
        };
    in {
      overlays.default =
        (final: prev: { gen = self.packages.${prev.system}.default; });
      packages = eachSystem (system:
        let pkgs = mkPkgs system;
        in {
          default = pkgs.rustPlatform.buildRustPackage {
            name = "gen";
            version = "1.0.0";
            cargoLock.lockFile = ./Cargo.lock;
            src = pkgs.lib.cleanSource ./.;
            meta = with pkgs.lib; {
              description = "An extensible project generator";
              maintainers = with maintainers; [ "NewDawn0" ];
              license = licenses.mit;
            };
          };
        });
    };
}
