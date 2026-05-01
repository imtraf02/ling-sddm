{
  description = "lingSDDM - Optimized SDDM theme featuring the Rei theme";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (system: {
        default = nixpkgsFor.${system}.callPackage ./nix/package.nix { };
      });

      nixosModules.default = import ./nix/module.nix;
      nixosModule = self.nixosModules.default;

      apps = forAllSystems (system: {
        test = {
          type = "app";
          program = "${nixpkgsFor.${system}.writeShellScript "test-sddm-theme" ''
            export QT_QPA_PLATFORM=xcb
            export GST_PLUGIN_SYSTEM_PATH_1_0=${with nixpkgsFor.${system}; lib.makeSearchPath "lib/gstreamer-1.0" [
              gst_all_1.gstreamer
              gst_all_1.gst-plugins-base
              gst_all_1.gst-plugins-good
              gst_all_1.gst-plugins-bad
              gst_all_1.gst-libav
            ]}
            export QT_PLUGIN_PATH=${with nixpkgsFor.${system}.kdePackages; nixpkgs.lib.makeSearchPath "lib/qt-6/plugins" [
              qtmultimedia
            ]}
            export QML2_IMPORT_PATH=${with nixpkgsFor.${system}.kdePackages; nixpkgs.lib.makeSearchPath "lib/qt-6/qml" [
              qtmultimedia
              qtsvg
              qtvirtualkeyboard
              qt5compat
              qtdeclarative
              qtquick3d
              sddm
            ]}:${self.packages.${system}.default}/share/sddm/themes/default/components
            ${nixpkgsFor.${system}.kdePackages.sddm}/bin/sddm-greeter-qt6 --test-mode --theme ${self.packages.${system}.default}/share/sddm/themes/default
          ''}";
        };
      });
    };
}
