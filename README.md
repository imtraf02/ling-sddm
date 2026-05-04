<div align="center">
  <img src="https://github.com/user-attachments/assets/dd63c526-34d6-45ec-8a7d-5c29bf08c702" width="100%" alt="lingSDDM Banner">
  
  # 🌙 ling-sddm
  
  **A sleek, modern, and highly customizable SDDM theme optimized for NixOS and high-end desktop setups.**
  
  [![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue.svg?logo=nixos&logoColor=white)](https://nixos.org)
  [![QT6](https://img.shields.io/badge/QT-6.5+-blue.svg?logo=qt&logoColor=white)](https://www.qt.io/)
  [![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
</div>

---

## 🌟 Overview

**ling-sddm** is a high-performance SDDM theme designed with aesthetics and flexibility in mind. Whether you want a minimal setup or a rich, animated experience, ling-sddm provides the tools to build your perfect login screen.

> [!IMPORTANT]
> Special thanks to [SilentSDDM](https://github.com/uiriansan/SilentSDDM) for the core logic and structural inspiration.

---

## ✨ Key Features

- 🎥 **Dynamic Backgrounds**: Support for ultra-smooth video backgrounds (MP4, MKV, WebM) with customizable blur and brightness.
- 👤 **Animated Interactions**: Modern typing animations for password fields and smooth transitions for user selection.
- ⌨️ **Virtual Keyboard**: Fully integrated support for Qt Virtual Keyboard with custom positioning.
- ❄️ **NixOS Native**: Built-in Nix Flakes and NixOS module for seamless configuration on Nix-based systems.
- 🎨 **Deep Customization**: Over 250 variables available via `theme.conf` to control every pixel.
- ⚡ **Optimized Performance**: Refactored QML logic for near-instant loading times.

---

## 🛠️ Installation

### ❄️ NixOS (Flakes)

1. Add **lingSDDM** to your `flake.nix`:

```nix
inputs = {
  ling-sddm = {
    url = "github:imtraf/ling-sddm";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

2. Enable the module:

```nix
{ inputs, ... }: {
  imports = [ inputs.ling-sddm.nixosModules.default ];

  services.displayManager.sddm.ling-sddm = {
    enable = true;
    background = ./.background.mp4; # Path to your custom video or image
    # Optional: custom profile icons
    profileIcons = {
      "imtraf" = ./.face; 
    };
  };
}
```

### 🐧 Manual Installation

1. **Requirements**: `sddm`, `qt6-svg`, `qt6-virtualkeyboard`, `qt6-multimedia`.
2. **Setup**:
```bash
git clone --depth=1 https://github.com/imtraf/ling-sddm.git
cd ling-sddm
chmod +x install.sh
sudo ./install.sh --background path/to/wallpaper.mp4
```

> [!TIP]
> You can omit the `--background` flag to use the default live wallpaper. You can also provide an absolute path to any video or image on your system.

---

## 👤 Setting User Avatars

### ❄️ NixOS
Use the `profileIcons` option in your configuration:
```nix
services.displayManager.sddm.ling-sddm.profileIcons = {
  "username" = ./.face; # Path to your image
};
```

### 🐧 Manual Method (Home Directory)
If you are not using the NixOS module, you can set your avatar manually:

1. **Prepare your image**: Resize your image to a reasonable size (e.g., `128x128` or `256x256` pixels) and convert it to PNG format.
2. **Move and Rename**: Place the image in your home directory and rename it to `.face`:
   ```bash
   cp /path/to/your/avatar.png ~/.face
   ```
3. **Set Permissions**: Ensure the file is readable by the SDDM user:
   ```bash
   chmod 644 ~/.face
   ```
4. **Restart SDDM**: Log out or restart your computer to see the changes.

---

## ⚙️ Configuration

Customization is handled via `theme.conf` (or via NixOS options). You can adjust:
- **Layout**: Center, Left, or Right alignment.
- **Colors**: Accent colors, backgrounds, and text styling.
- **Animations**: Enable/Disable effects, adjust durations.
- **Fonts**: Full support for custom Google Fonts.

---

## 🧪 Development & Testing

You can test changes instantly using the Nix development environment:

```bash
nix run .#test
```

---

## 🤝 Credits & Acknowledgements

- **[SilentSDDM](https://github.com/uiriansan/SilentSDDM)**: For the excellent base and architectural inspiration.
- **[sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme)**: For layout concepts.
- **[Iconify](https://iconify.design/)**: For the clean iconography.

---

<div align="center">
  Developed with passion by <b>imtraf</b>
</div>
