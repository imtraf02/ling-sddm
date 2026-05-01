{ stdenv, lib }:

stdenv.mkDerivation {
  pname = "lingsddm";
  version = "1.0.0";

  src = ../.;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/default
    cp -r $src/* $out/share/sddm/themes/default/
    chmod -R u+w $out/share/sddm/themes/default/

    # Remove nix directory from the installed theme
    rm -rf $out/share/sddm/themes/default/nix
    rm -f $out/share/sddm/themes/default/flake.nix
    rm -f $out/share/sddm/themes/default/flake.lock

    # Install fonts to the standard location as well
    mkdir -p $out/share/fonts
    cp -r fonts/redhat $out/share/fonts/
    cp -r fonts/redhat-vf $out/share/fonts/
    chmod -R u+w $out/share/fonts/
  '';

  meta = with lib; {
    description = "Optimized SDDM theme based on SilentSDDM, featuring the Rei theme.";
    homepage = "https://github.com/imtraf/lingSDDM";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
