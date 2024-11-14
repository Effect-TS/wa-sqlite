{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-emcc.url = "github:willcohen/nixpkgs/emscripten-3.1.67";
  };
  outputs = {
    nixpkgs,
    nixpkgs-emcc,
    ...
  }: let
    forAllSystems = function:
      nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed
      (system: function system);
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-emcc = nixpkgs-emcc.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [
          corepack
          nodejs
          pkgs-emcc.emscripten
          pkgs-emcc.binaryen
          openssl
          which
          tcl
          wabt
          unzip
          zip
        ];
      };
    });
  };
}
