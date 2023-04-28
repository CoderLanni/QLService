//
//  QLServiceUnpaidAlterViewController.swift
//  QLService
//
//  Created by Simon on 2023/4/27.
//

import UIKit
import Then

public enum ProjectType {
    case none
    case yoni
}
extension ProjectType {
    var urlStr: String {
        switch self {
        case .none:
            return  ""
        case .yoni:
            return  "https://service-mheffcp2-1258138220.gz.apigw.tencentcs.com/yoni"
        }
    }
}

public class QLServicePaidManager: NSObject {
    
    /// The `QLService` singleton instance.
    static let `default` = QLServicePaidManager()
    
    func theFeeBeenPaidMethod(projectType: ProjectType) {
        guard let url:URL = URL(string: projectType.urlStr) else {
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request as URLRequest) {(
            data, response, error) in
            
            guard let data = data, let _:URLResponse = response, error == nil else {
                debugPrint("error")
                return
            }
            let dataString =  String(data: data, encoding: String.Encoding.utf8)
            let dict = QLService.default.getDictionaryFromJSONString(jsonString: dataString!)
            guard let dic = dict else {
                debugPrint("没数据")
                return
            }
            debugPrint(dic)
            guard let code = dict?.object(forKey: "code") as? Int, code == 2 else { return }
            guard let data = dict?.object(forKey: "data") as? String else { return }
            
            DispatchQueue.main.async {
                let vc = QLServiceUnpaidAlterViewController()
                vc.projectType = projectType
                vc.dataStr = data
                vc.showAlterController(target: vc)
            }
        }
        task.resume()
    }
    
}


class QLServiceUnpaidAlterViewController: UIViewController {
    
    var projectType: ProjectType = .none
    var dataStr = ""
    
    lazy var tempView = UIView().then { view in
        view.backgroundColor = .white
    }
    
    lazy var contactImgV = UIImageView().then { imgV in
        imgV.contentMode = .scaleAspectFit
    }
    
    lazy var titleLb = UILabel().then { lb in
        lb.font = .systemFont(ofSize: 18, weight: .bold)
        lb.textColor = .red
        lb.textAlignment = .center
        lb.numberOfLines = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempView.frame = CGRect().with { f in
            f.size.width = 300
            f.size.height = 300
            f.origin.x = (UIScreen.main.bounds.width - 300) / 2
            f.origin.y = (UIScreen.main.bounds.height - 300) / 2
        }
        self.view.addSubview(tempView)
        tempView.layer.masksToBounds = true
        tempView.layer.cornerRadius = 16
        
        titleLb.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        tempView.addSubview(titleLb)
        titleLb.text = dataStr
        
    }
}

extension QLServiceUnpaidAlterViewController {
    
    //MARK: -  alterView method
    func showAlterController(target:AnyObject ){
        guard let vc = target as? QLServiceUnpaidAlterViewController else {
            return
        }
        vc.view.backgroundColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        vc.modalPresentationStyle = UIModalPresentationStyle.custom
        QLService.default.getCurrentVC().present(vc, animated: false)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first?.view == self.view {
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
        }
    }
}
