import Foundation

final class FanService: ObservableObject {
    
    private let helper = HelperClient()
    private var isConnected = false
    
    
    func enableFanControl() {
        installHelper()
        connect()
    }
    
    private func connect() {
        guard !isConnected else { return }
        
        helper.connect()
        isConnected = true
        
        print("✅ Connected to helper")
    }
    
    
    func getVersion() {
        helper.proxy()?.getVersion { version in
            DispatchQueue.main.async {
                print("📦 Helper version:", version)
            }
        }
    }
    
    func getFanInfo() {
        helper.proxy()?.getFanInfo { fans in
            DispatchQueue.main.async {
                print("🌀 Fans:", fans)
            }
        }
    }
    
    func setFan(_ rpm: Int) {
        helper.proxy()?.setFanMinSpeed(rpm) { success, message in
            DispatchQueue.main.async {
                print(success ? "✅" : "❌", message)
            }
        }
    }
    
    func resetFan() {
        helper.proxy()?.resetFanAuto { success, message in
            DispatchQueue.main.async {
                print(success ? "✅" : "❌", message)
            }
        }
    }
}
