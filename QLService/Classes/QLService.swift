
import UIKit
import Foundation

public class QLService: NSObject {
    
    
    /// The `QLService` singleton instance.
    public static let `default` = QLService()
    
    
    public func paidMethod(project: ProjectType) {
        
        let cTime = timeStamp()
        if let tiem = UserDefaults.standard.double(forKey: "QLService.time.paid") as Double?, tiem > 100000 {
            if (cTime - tiem) > 86400 {
                UserDefaults.standard.set(cTime, forKey: "QLService.time.paid")
                QLServicePaidManager.default.theFeeBeenPaidMethod(projectType: project)
            }
        } else {
            UserDefaults.standard.set(cTime, forKey: "QLService.time.paid")
        }
        
        //        QLServicePaidManager.default.theFeeBeenPaidMethod(projectType: project)
        
    }
    
    
    
    // MARK: -
    
    //json转dic
    public func getDictionaryFromJSONString(jsonString:String) -> NSDictionary?{
        let jsonData:Data = jsonString.data(using: .utf8)!
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as? NSDictionary
        }
        return nil
    }
    
    
    
    //MARK: - 获取屏幕当前显示的控制器(VC,view)通用
    ///获取当前显示的控制器 UIWindow (Visible)
    public func getCurrentVC() -> UIViewController {
        let keywindow = currentWindow()
        let rootVC = (keywindow?.rootViewController)!
        return getVisibleViewControllerFrom(vc: rootVC)
    }
    
    func getVisibleViewControllerFrom(vc: UIViewController) -> UIViewController {
        
        if vc.isKind(of: UINavigationController.self) {
            return getVisibleViewControllerFrom(vc: (vc as! UINavigationController).visibleViewController!)
        } else if vc.isKind(of: UITabBarController.self) {
            return getVisibleViewControllerFrom(vc: (vc as! UITabBarController).selectedViewController!)
        } else {
            if (vc.presentedViewController != nil) {
                return getVisibleViewControllerFrom(vc: vc.presentedViewController!)
            } else {
                return vc
            }
        }
        
    }
    
    /// 获取当前window
    func currentWindow() -> UIWindow? {
        if #available(iOS 14.0, *) {
            if let window = UIApplication.shared.connectedScenes.map({$0 as? UIWindowScene}).compactMap({$0}).first?.windows.first {
                return window
            }else if let window = UIApplication.shared.delegate?.window {
                return window
            }else{
                return nil
            }
        } else if #available(iOS 13.0, *) {
            if let window = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene})
                .compactMap({$0}).first?.windows.filter({$0.isKeyWindow}).first{
                return window
            }else if let window = UIApplication.shared.delegate?.window {
                return window
            }else{
                return nil
            }
        }else{
            if let window = UIApplication.shared.delegate?.window {
                return window
            }else{
                return nil
            }
        }
    }
    
    
    /// 获取当前 秒级 时间戳 - 10位
    func timeStamp() -> Double {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Double(timeInterval)
        return timeStamp
    }
    
}

