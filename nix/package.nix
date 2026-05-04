{
  lib,
  stdenvNoCC,
  kdePackages,
}:
stdenvNoCC.mkDerivation {
  pname = "lingsddm";
  version = "1.0.0";

  src = ../.;

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

  installPhase = ''
    mkdir -p $out/share/sddm/themes/ling-sddm
    cp -r . $out/share/sddm/themes/ling-sddm/
    chmod -R u+w $out/share/sddm/themes/ling-sddm/

    # Remove unnecessary files from the installed theme
    rm -rf $out/share/sddm/themes/ling-sddm/{nix,flake.nix,flake.lock,install.sh,README.md,LICENSE,.git}

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
