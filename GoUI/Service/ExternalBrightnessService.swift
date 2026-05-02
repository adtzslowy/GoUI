import Foundation
import Combine
import CoreGraphics

final class ExternalBrightnessService: ObservableObject {
    @Published var brightness: Double = 100
    @Published var isSupported: Bool = false
    @Published var statusMessage: String = "Checking monitor..."

    private let ddcctlPath = [
        "/usr/local/bin/ddcctl",
        "/opt/homebrew/bin/ddcctl"
    ]

    private var pendingWorkItem: DispatchWorkItem?

    init() {
        probeSupport()
        setupDisplayListener()
    }
    
    private func setupDisplayListener() {
        CGDisplayRegisterReconfigurationCallback( { (_, flags, userInfo) in
            let services = Unmanaged<ExternalBrightnessService>.fromOpaque(userInfo!).takeUnretainedValue()
            
            DispatchQueue.main.async {
                print("Display changed: ", flags)
                services.probeSupport()
            }
        }, UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
    }

    private func resolvePath() -> String? {
        return ddcctlPath.first { FileManager.default.isExecutableFile(atPath: $0)}
    }

    func probeSupport() {
        guard let path = resolvePath() else {
            isSupported = false
            statusMessage = "ddcctl tidak ditemukan."
            print("ddcctl not found in known paths")
            return
        }

        runShell("\"\(path)\" -d 1") { [weak self] status, output in
            DispatchQueue.main.async {
                print("probe output:", output)
                if status == 0, output.lowercased().contains("external display") || output.lowercased().contains("polling edid") {
                    self?.isSupported = true
                    self?.statusMessage = "Monitor eksternal terdeteksi."
                } else {
                    self?.isSupported = false
                    self?.statusMessage = "Hubungkan monitor eksternal untuk mengatur brightness."
                }
            }
        }
    }

    func setBrightness(_ value: Int, isFinal: Bool = false) {
        pendingWorkItem?.cancel()
        
        let delay: Double = isFinal ? 0 : 0.2
        
        let workItem = DispatchWorkItem {[weak self] in
            self?.applyBrightness(value)
        }
        
        pendingWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
    }

    private func applyBrightness(_ value: Int) {
        guard let path = resolvePath() else {
            DispatchQueue.main.async {
                self.isSupported = false
                self.statusMessage = "ddcctl tidak ditemukan."
            }
            return
        }

        runShell("\"\(path)\" -d 1 -b \(value)") { [weak self] status, output in
            DispatchQueue.main.async {
                print("brightness output:", output)
                if status == 0 {
                    self?.isSupported = true
                    self?.brightness = Double(value)
                    self?.statusMessage = "Brightness \(value)%"
                } else {
                    self?.isSupported = false
                    self?.statusMessage = "Gagal mengubah brightness."
                }
            }
        }
    }

    private func runShell(_ command: String, completion: @escaping (Int32, String) -> Void) {
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
