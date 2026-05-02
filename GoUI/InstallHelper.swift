import ServiceManagement
import Security

func installHelper() {
    var authRef: AuthorizationRef?
    
    let status = AuthorizationCreate(nil, nil, [], &authRef )
    guard status == errAuthorizationSuccess else {
        print("Auth gagal")
        return
    }
    
    var error: Unmanaged<CFError>?
    
    let ok = SMJobBless(kSMDomainSystemLaunchd, "adtzslowy.xyz.GoUIHelper" as CFString, authRef, &error)
    
    if ok {
        print("✅ Helper installed")
    } else {
        print("❌ Bless gagal: ", error!.takeRetainedValue())
    }
}
