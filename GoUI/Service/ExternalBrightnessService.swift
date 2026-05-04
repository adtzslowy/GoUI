import Foundation
import Combine
import CoreGraphics

struct ExternalDisplay: Identifiable {
    let id: Int
    var name: String
}

final class ExternalBrightnessService: ObservableObject {
    @Published var brightness: Double = 100
    @Published var isSupported: Bool = false
    @Published var statusMessage: String = "Checking monitor..."
    @Published var displays: [ExternalDisplay] = []
    @Published var brightnessMap: [Int: Double] = [:]

    private let ddcctlPath = [
        "/usr/local/bin/ddcctl",
        "/opt/homebrew/bin/ddcctl"
    ]

    private var pendingWorkItem: DispatchWorkItem?

    init() {
        scanDisplays()
        setupDisplayListener()
    }

    private func setupDisplayListener() {
        CGDisplayRegisterReconfigurationCallback({ (_, flags, userInfo) in
            let service = Unmanaged<ExternalBrightnessService>
                .fromOpaque(userInfo!)
                .takeUnretainedValue()

            DispatchQueue.main.async {
                print("Display changed:", flags)
                service.scanDisplays()
            }
        }, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
    }

    private func resolvePath() -> String? {
        return ddcctlPath.first {
            FileManager.default.isExecutableFile(atPath: $0)
        }
    }

    func scanDisplays() {
        guard let path = resolvePath() else {
            DispatchQueue.main.async {
                self.displays = []
                self.isSupported = false
                self.statusMessage = "ddcctl tidak ditemukan."
            }
            return
        }

        runShell("\"\(path)\" -d 1") { [weak self] status, output in
            DispatchQueue.main.async {
                guard let self else { return }

                print("SCAN OUTPUT:\n\(output)")

                if output.lowercased().contains("found 1 external display") ||
                   output.lowercased().contains("display") {

                    self.displays = [
                        ExternalDisplay(id: 1, name: "External Display")
                    ]
                    
                    self.brightnessMap[1] = 100

                    self.isSupported = true
                    self.statusMessage = "1 monitor terdeteksi"
                } else {
                    self.displays = []
                    self.isSupported = false
                    self.statusMessage = "Monitor tidak terdeteksi"
                }
            }
        }
    }

    func setBrightness(_ value: Int, for displayID: Int, isFinal: Bool = false) {
        pendingWorkItem?.cancel()

        let delay: Double = isFinal ? 0 : 0.2

        let workItem = DispatchWorkItem { [weak self] in
            self?.applyBrightness(value, displayID: displayID)
        }

        pendingWorkItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    func setBrightnessAll(_ value: Int, isFinal: Bool = false) {
        pendingWorkItem?.cancel()

        let delay: Double = isFinal ? 0 : 0.2

        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            for display in self.displays {
                self.applyBrightness(value, displayID: display.id)
            }
        }

        pendingWorkItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    private func applyBrightness(_ value: Int, displayID: Int) {
        guard let path = resolvePath() else {
            DispatchQueue.main.async {
                self.isSupported = false
                self.statusMessage = "ddcctl tidak ditemukan."
            }
            return
        }

        runShell("\"\(path)\" -d \(displayID) -b \(value)") { [weak self] status, output in
            DispatchQueue.main.async {
                print("Display \(displayID):", output)

                if status == 0 {
                    self?.brightness = Double(value)
                    self?.brightnessMap[displayID] = Double(value)
                    self?.isSupported = true
                    self?.statusMessage = "Display \(displayID): \(value)%"
                } else {
                    self?.isSupported = false
                    self?.statusMessage = "Gagal ubah brightness display \(displayID)"
                }
            }
        }
    }

    private func runShell(_ command: String, completion: @escaping (Int32, String) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let process = Process()
            let pipe = Pipe()

            process.executableURL = URL(fileURLWithPath: "/bin/zsh")
            process.arguments = ["-lc", command]
            process.standardOutput = pipe
            process.standardError = pipe

            do {
                try process.run()
                process.waitUntilExit()

                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8) ?? ""

                completion(process.terminationStatus, output)
            } catch {
                completion(1, error.localizedDescription)
            }
        }
    }
}
