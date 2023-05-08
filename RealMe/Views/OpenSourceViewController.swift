//
//  OpenSourceViewController.swift
//  RealMe
//
//  Created by 임우섭 on 2023/05/08.
//

import UIKit
import WebKit
import Then
import SnapKit

class OpenSourceViewController: UIViewController, ViewControllerProtocol {
    
    

    let webView = WKWebView()
    let url = "https://hurricane-flavor-f7a.notion.site/215fd15456b14a2ba45960e0baab198b"
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttribute()
        addView()
        setLayout()
    }
    func setAttribute() {
        self.navigationItem.title = "오픈소스 라이선스"
        
        let request = URLRequest(url: URL(string: url)!)
        webView.do {
            $0.frame = self.view.frame
            $0.load(request)
        }
    }
    
    func addView() {
        self.view.addSubview(webView)
    }
    
    func setLayout() {
        webView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
        }
    }

    

}
