{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.displayManager.sddm.lingSDDM;
  themeName = "lingSDDM";
  pkg = pkgs.callPackage ./package.nix { 
    background = cfg.background;
  };

  users = attrNames config.users.users;
in
{
  options.services.displayManager.sddm.lingSDDM = {
    enable = mkEnableOption "lingSDDM SDDM theme";
    
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

    background = mkOption {
      type = types.nullOr (types.either types.path types.str);
      default = null;
      example = "./wallpaper.mp4";
      description = "Path to the background video/image file.";
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      theme = themeName;
      extraPackages = [
        pkgs.kdePackages.qtmultimedia
        pkgs.kdePackages.qtsvg
        pkgs.kdePackages.qtvirtualkeyboard
        pkgs.kdePackages.qt5compat
        pkgs.kdePackages.qtquick3d
        # Video support
        pkgs.gst_all_1.gstreamer
        pkgs.gst_all_1.gst-plugins-base
        pkgs.gst_all_1.gst-plugins-good
        pkgs.gst_all_1.gst-plugins-bad
        pkgs.gst_all_1.gst-libav
      ];
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
