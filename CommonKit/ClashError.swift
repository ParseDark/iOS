import Foundation

public struct ClashError: CustomNSError {
    
    public static let errorDomain: String = "com.Arror.Clash"
    
    public let errorCode: Int
    
    public let errorUserInfo: [String : Any]
    
    public init(code: Int, localizedDescription: String) {
        self.errorCode = code
        self.errorUserInfo = [NSLocalizedDescriptionKey: localizedDescription]
    }
    
    public static func custom(withLocalizedDescription description: String) -> ClashError {
        ClashError(code: 0, localizedDescription: description)
    }
}
