{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  buildInputs = with pkgs; [
    gradle
    jdk21
    jq
    xxd

    # buildtools
    git

    # sandboxing
    bubblewrap
  ];
  shellHook = let
    lib = pkgs.lib;
    jnaLibraryPath = lib.makeLibraryPath [pkgs.udev];
  in ''
    export JDK_JAVA_OPTIONS="-Djna.library.path="${lib.escapeShellArg jnaLibraryPath}
  '';
}
