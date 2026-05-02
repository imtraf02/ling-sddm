<div align="center">
  <img src="https://github.com/user-attachments/assets/dd63c526-34d6-45ec-8a7d-5c29bf08c702" width="100%" alt="lingSDDM Banner">
  
  # 🌙 lingSDDM
  
  **A premium, highly customizable, and optimized SDDM theme for modern Linux desktops.**
  
  [![NixOS](https://img.shields.io/badge/NixOS-Unstable-blue.svg?logo=nixos&logoColor=white)](https://nixos.org)
  [![QT6](https://img.shields.io/badge/QT-6.5+-blue.svg?logo=qt&logoColor=white)](https://www.qt.io/)
  [![License](https://img.shields.io/badge/License-GPL--3.0-green.svg)](LICENSE)
</div>

---

## ✨ Features

- 🎥 **Video Backgrounds**: Support for animated backgrounds (MP4, MKV, MOV, etc.).
- 👤 **Smart User Selector**: Beautifully animated avatar selection with auto-focus.
- ⌨️ **Virtual Keyboard**: Built-in support for QT Virtual Keyboard.
- ❄️ **NixOS Optimized**: First-class support for Nix Flakes and NixOS Modules.
- 🎨 **Fully Customizable**: Over 200 configuration options via `theme.conf`.
- ⚡ **Lightweight**: Optimized QML code for fast loading and low resource usage.

---

## 🛠️ Installation

### ❄️ NixOS (Recommended)

1. Add **lingSDDM** to your `flake.nix` inputs:

```nix
inputs = {
  ling-sddm = {
    url = "github:imtraf/ling-sddm";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

2. Import the module and enable it in your configuration:

```nix
{ inputs, ... }: {
  imports = [ inputs.ling-sddm.nixosModules.default ];

  services.displayManager.sddm.lingSDDM = {
    enable = true;
    profileIcons = {
      "your_username" = ./.face; # Optional: Set custom avatar path
    };
  };
}
```

### 🐧 Manual Installation (Other Distros)

1. **Install Dependencies**:
   - SDDM (>= 0.21.0)
   - QT (>= 6.5)
   - `qt6-svg`, `qt6-virtualkeyboard`, `qt6-multimedia`

2. **Clone and Install**:
```bash
git clone --depth=1 https://github.com/imtraf/ling-sddm.git
cd ling-sddm
./install.sh
```

---

## ⚙️ Configuration

The theme is highly configurable. On non-NixOS systems, edit `/usr/share/sddm/themes/default/theme.conf`.

> [!TIP]
> You can change everything from font sizes, colors, margins, to background animations. Check the `theme.conf` file for all available options.

### 👤 Setting User Avatars

For NixOS, use the `profileIcons` option in the module.
For other distros, lingSDDM follows the `AccountsService` standard. Place your avatar at `~/.face.icon` or configure it via your desktop environment's settings.

---

## 🧪 Development

Test your changes instantly without rebooting using the Nix dev environment:

```bash
# Clone the repository
git clone https://github.com/imtraf/ling-sddm.git
cd ling-sddm

# Run the test interface
nix run .#test
```

---

## 🤝 Acknowledgements

- [SilentSDDM](https://github.com/uiriansan/SilentSDDM) - The base project this theme was branched from.
- [sddm-astronaut-theme](https://github.com/Keyitdev/sddm-astronaut-theme) - Layout inspiration.
- [iconify.design](https://iconify.design/) - Beautiful system icons.

---

<div align="center">
  Made with ❤️ by <b>imtraf</b>
</div>
ons
