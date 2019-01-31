//
//  DetailViewController.swift
//  SampleMovieApp
//
//  Created by 박정훈 on 31/01/2019.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
import WebKit

class DetailViewController: UIViewController{
    
    @IBOutlet weak var wv: WKWebView!
    var mvo: MovieVO! // 목록 화면에서 전달하는 영화 정보를 받을 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("\(self.mvo.detail!),\(self.mvo.title!)")
        
        //내비게이션 바의 타이틀에 영화이름
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
        
        if let url = self.mvo.detail{
            if let urlObj = URL(string: url){
                let req = URLRequest(url: urlObj)
                self.wv.load(req)
            }else{
                //경고창 형식으로 오류 메시지
            }
            
        }
        
        //URLRequest 인스턴스를 생성한다.
        let url = URL(string: (self.mvo.detail)!)
        let req = URLRequest(url: url!)
        
        //loadRequest 메소드를 호출하면서 req를 인자값으로 전달한다.
        self.wv.load(req)
    }
}
