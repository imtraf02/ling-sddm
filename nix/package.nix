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
    cp -r $src/* $out/share/sddm/themes/ling-sddm/
    chmod -R u+w $out/share/sddm/themes/ling-sddm/

    chmod -R u+w $out/share/sddm/themes/ling-sddm/

    # Remove nix directory from the installed theme
    rm -rf $out/share/sddm/themes/ling-sddm/nix
    rm -f $out/share/sddm/themes/ling-sddm/flake.nix
    rm -f $out/share/sddm/themes/ling-sddm/flake.lock
    rm -f $out/share/sddm/themes/ling-sddm/install.sh

    # Install fonts to the standard location as well
    mkdir -p $out/share/fonts
    cp -r fonts/supermercado-one $out/share/fonts/
    chmod -R u+w $out/share/fonts/
  '';

  meta = with lib; {
    description = "Optimized SDDM theme based.";
    homepage = "https://github.com/imtraf/ling-sddm";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
