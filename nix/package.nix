{
  stdenv,
  lib,
  background ? null,
}:
stdenv.mkDerivation {
  pname = "lingsddm";
  version = "1.0.0";

  src = ../.;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/lingSDDM
    cp -r $src/* $out/share/sddm/themes/lingSDDM/
    chmod -R u+w $out/share/sddm/themes/lingSDDM/

    ${lib.optionalString (background != null) ''
      sed -i 's|^background =.*|background = "${background}"|' $out/share/sddm/themes/lingSDDM/theme.conf
    ''}

    # Remove nix directory from the installed theme
    rm -rf $out/share/sddm/themes/lingSDDM/nix
    rm -f $out/share/sddm/themes/lingSDDM/flake.nix
    rm -f $out/share/sddm/themes/lingSDDM/flake.lock

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
