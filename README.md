![goui-image](.github/goui.png)

#  GoUI – macOS System Monitor (Menu Bar App)

GoUI adalah aplikasi **menu bar macOS** yang dibuat dengan **SwiftUI** untuk memonitor dan mengontrol sistem secara real-time.

Dirancang untuk ringan, cepat, dan nyaman digunakan langsung dari menu bar tanpa membuka window besar.

---

## ✨ Features

### 📊 System Monitoring

* ✅ CPU Usage (real-time)
* ✅ Memory Usage
* ✅ Disk Usage
* 🔄 Update setiap 1 detik

---

### 🌀 Fan Monitoring (Intel Mac only)

* 🔍 Detect jumlah fan otomatis (1 / 2)
* 🌡️ Tampilkan RPM real-time
* ⚙️ Mode:

  * Auto (system-controlled)
  * Manual *(coming soon / privileged)*

> ⚠️ Fan control membutuhkan akses khusus (SMC), tidak tersedia secara default.

---

### 🌞 External Monitor Brightness

* 🎚️ Control brightness monitor eksternal
* 🔌 Menggunakan `ddcctl`
* 📺 Support monitor dengan DDC/CI

---

### 🎨 UI

* 🟢 Circular stat indicators (CPU / RAM / Disk)
* 🌙 Dark translucent UI (menu bar style)
* ⚡ Lightweight & responsive

---

## 🧰 Requirements

* macOS Monterey (12) atau lebih baru
* Xcode 14+
* Intel Mac (untuk fan monitoring via SMC)
* External monitor (untuk brightness control)

---

## 📦 Installation

### 1. Clone repo

```bash
git clone https://github.com/adtzslowy/GoUI.git
cd GoUI
```

### 2. Open project

```bash
open GoUI.xcodeproj
```

---

## ⚠️ Important Setup

### 🔴 Disable App Sandbox

Agar bisa:

* akses `ddcctl`
* akses AppleSMC

Buka:

```
Target → Signing & Capabilities → App Sandbox → OFF
```

---

## 🌞 Setup External Brightness (ddcctl)

Install `ddcctl`:

```bash
brew install ddcctl
```

Kalau gagal:

```bash
brew tap kfix/ddcctl
brew install ddcctl
```

Cek:

```bash
which ddcctl
```

Harusnya:

```
/usr/local/bin/ddcctl
```

Test manual:

```bash
ddcctl -d 1 -b 50
```

---

## 🌀 Fan Monitoring (SMC)

Menggunakan Apple SMC via:

* `SMCKit` (low-level access)
* hanya bekerja di **Intel Mac**

> ⚠️ Tidak support Apple Silicon (M1/M2/M3)

---

## 🚧 Known Limitations

* ❌ Fan control manual belum aktif (butuh privileged helper)
* ❌ Tidak support Mac App Store (private API AppleSMC)
* ⚠️ Brightness hanya untuk monitor yang support DDC/CI
* ⚠️ Beberapa monitor murah tidak support control brightness

---

## 🏗️ Architecture

```
GoUI (Main App)
 ├─ UI (SwiftUI)
 ├─ SystemMonitor
 ├─ CPU / Memory / Disk Reader
 ├─ FanMonitor (SMCKit)
 └─ ExternalBrightnessService (ddcctl)

GoUIHelper (planned)
 └─ Privileged operations (fan control)
```

---

## 🚀 Roadmap

* [ ] Manual fan control (privileged helper)
* [ ] Auto fan curve (temperature-based)
* [ ] GPU monitoring
* [ ] Temperature sensors
* [ ] Multi-monitor brightness control
* [ ] Settings panel

---

## 📸 Preview

> Menu bar popup UI

* CPU / MEM / DISK ring indicators
* Fan control card
* Brightness control
* Preferences & Quit

---

## 🧑‍💻 Author

Made with ❤️ by **Adit**

---

## ⚠️ Disclaimer

Aplikasi ini menggunakan API internal (SMC) yang:

* tidak didukung Apple secara resmi
* tidak diizinkan untuk Mac App Store

Gunakan dengan risiko sendiri.

---

## ⭐ Support

Kalau kamu suka project ini:

* ⭐ Star repo ini
* 🍴 Fork & contribute
* 🧠 Kasih ide fitur baru

---
