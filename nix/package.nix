{
  lib,
  stdenvNoCC,
  kdePackages,
}:
let
  inherit (lib.fileset) toSource difference unions fileFilter maybeMissing;
in
stdenvNoCC.mkDerivation {
  pname = "lingsddm";
  version = "1.0.0";

  # cleanly select only the pieces of source that **building** this package depends on.
  # avoids unnecessary rebuilds when unrelated pieces (like the README) changes.
  src = toSource {
    root = ../.;
    fileset = difference ../. (unions [
      (fileFilter (file: lib.any (ext: file.hasExt ext) ["nix" "sh"]) ../.)
      (maybeMissing ../nix)
      (maybeMissing ../docs)
      (maybeMissing ../LICENSE)
      (maybeMissing ../README.md)
      (maybeMissing ../flake.lock)
      (maybeMissing ../.git)
    ]);
  };

  # Qt packages must be propagated so they're available at runtime
  # for sddm-greeter-qt6 to find QML modules (QtMultimedia, etc.).
  propagatedBuildInputs = [
    kdePackages.qtmultimedia
    kdePackages.qtsvg
    kdePackages.qtvirtualkeyboard
    kdePackages.qt5compat
    kdePackages.qtquick3d
  ];

  # Don't let Qt wrapper scripts interfere with SDDM's own Qt environment.
  dontWrapQtApps = true;

  installPhase = let
    basePath = "$out/share/sddm/themes/${pname}";
  in ''
    mkdir -p ${basePath}
    cp -r . ${basePath}/

    # Install fonts to the standard location
    mkdir -p $out/share/fonts
    cp -r fonts/supermercado-one $out/share/fonts/
  '';

  meta = with lib; {
    description = "Optimized SDDM theme based.";
    homepage = "https://github.com/imtraf/ling-sddm";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
