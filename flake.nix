{
  description = "Flexible tool for generating customizable project templates";

  inputs.utils.url = "github:NewDawn0/nixUtils";

  outputs = { self, utils, ... }: {
    overlays.default = final: prev: {
      gen = self.packages.${prev.system}.default;
    };
    packages = utils.lib.eachSystem { } (pkgs: {
      default = pkgs.rustPlatform.buildRustPackage {
        pname = "gen";
        version = "1.0.0";
        src = ./.;
        useFetchCargoVendor = true;
        cargoHash = "sha256-QszcPmVDffCbbS1K9wm0BmVw8d8BxqoMFETmxJMfOdU=";
        meta = {
          description =
            "Flexible tool for generating customizable project templates";
          longDescription = ''
            This extensible project generator allows you to quickly set up new projects with customizable templates.
            Ideal for users who want to automate the creation of project skeletons with personalized settings.
          '';
          homepage = "https://github.com/NewDawn0/gen";
          license = pkgs.lib.licenses.mit;
          maintainers = with pkgs.lib.maintainers; [ NewDawn0 ];
          platforms = pkgs.lib.platforms.all;
        };
      };
    });
  };
}
