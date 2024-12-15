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
            pname = "gen";
            version = "1.0.0";
            src = ./.;
            cargoHash = "sha256-B+4jzreHXsAgE6noNzGajtKmJ1dLBN9E4q8ZRC9G6/0=";
            meta = {
              description =
                "A flexible tool for generating customizable project templates";
              longDescription = ''
                This extensible project generator allows you to quickly set up new projects with customizable templates.
                Ideal for users who want to automate the creation of project skeletons with personalized settings.
              '';
              license = pkgs.lib.licenses.mit;
              maintainers = with pkgs.lib.maintainers; [ NewDawn0 ];
              platforms = pkgs.lib.platforms.all;
            };
          };
        });
    };
}
