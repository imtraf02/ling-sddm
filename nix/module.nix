{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.displayManager.sddm.ling-sddm;
  themeName = "default";
  pkg = pkgs.callPackage ./package.nix { };

  users = attrNames config.users.users;
in
{
  options.services.displayManager.sddm.ling-sddm = {
    enable = mkEnableOption "ling-sddm SDDM theme";
    
    profileIcons = mkOption {
      type = types.attrsOf types.path;
      default = { };
      example = literalExpression ''
        {
          imtraf = ./.face;
        }
      '';
      description = "Attrset mapping usernames to their avatar image paths.";
    };


  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      theme = themeName;
      # Qt packages are propagated from the package derivation.
      # GStreamer is added here for video background support.
      extraPackages = [
        pkgs.kdePackages.qtmultimedia
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.qtvirtualkeyboard
        pkgs.kdePackages.qt5compat
        pkgs.kdePackages.qtquick3d
        pkgs.kdePackages.qtquickeffects
        pkgs.gst_all_1.gstreamer
        pkgs.gst_all_1.gst-plugins-base
        pkgs.gst_all_1.gst-plugins-good
        pkgs.gst_all_1.gst-plugins-bad
        pkgs.gst_all_1.gst-libav
      ];
      # NOTE: Do NOT set QML2_IMPORT_PATH here.
      # sddm-greeter-qt6 uses Qt6 which ignores QML2_IMPORT_PATH (Qt5 only).
      # Component resolution is handled entirely by the qmldir files in the theme.
    };

    environment.systemPackages = [
      pkg
    ];

    # Setup profile pictures using tmpfiles.rules (the SilentSDDM way)
    systemd.tmpfiles.rules = flatten (mapAttrsToList (user: icon: [
      "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
      "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${icon}"
    ]) (filterAttrs (user: _: elem user users) cfg.profileIcons));
  };
}
