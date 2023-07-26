{
  description = "Create VSCode EPuck2's installer flake";
  inputs = { nixpkgs.url = "nixpkgs/nixos-23.05"; };
  
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs { inherit system; };
    in {
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = [
          pkgs.python311
	  pkgs.python311Packages.kivy
	  pkgs.python311Packages.tkinter
          pkgs.python311Packages.termcolor
        ];
        shellHook = ''echo "hello world!"'';
      };
    };
}
