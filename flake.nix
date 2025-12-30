{
  description = "NixOS derivation of vqmetrics";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = ["x86_64-linux" "x86_64-darwin"];
    forEachSupportedSystem = f:
      nixpkgs.lib.genAttrs supportedSystems (system:
        f {
          pkgs = import nixpkgs {inherit system;};
          inherit system;
        });
  in {
    packages = forEachSupportedSystem ({
      pkgs,
      system,
      ...
    }: {
      default = pkgs.stdenv.mkDerivation {
        pname = "vqmetrics";
        version = "1.0";
        src = self;

        nativeBuildInputs = [
          pkgs.pkg-config
          pkgs.opencv4
        ];

        buildInputs = [
          pkgs.pkg-config
          pkgs.opencv4
        ];

        buildPhase = ''
          make clean
          make
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp -v ./vqtool $out/bin/
        '';

        meta = with pkgs.lib; {
          description = "Command‑line tool for VQMetrics";
          homepage = "https://github.com/allesis/vqmetric";
          license = licenses.mit;
          maintainers = with maintainers; [Sean Allesina-McGrory];
          platforms = platforms.unix;
        };
      };
    });
  };
}
