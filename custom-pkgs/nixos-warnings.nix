{ pkgs }:

pkgs.rustPlatform.buildRustPackage {
  pname = "nixos-warnings";
  version = "0.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "mxapd";
    repo = "nixos-warnings";
    rev = "ade9d27602ec7fc272bdc04fe0da18490f2227ec";  
    sha256 = "sha256-ulRKMhzAfpKQOECG6zxV8J4e6zjMaV0BLypJpOYg9Vw=";
  };

  cargoHash = "sha256-D5UHSyetNDXAHw2+cDbqyvxkNTIoUAgtz5ezgsBZ/mQ=";
  
  meta = {
    description = "Parse NixOS rebuild warnings";
  };
}
