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
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var wv: WKWebView!
    var mvo: MovieVO! // 목록 화면에서 전달하는 영화 정보를 받을 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("\(self.mvo.detail!),\(self.mvo.title!)")
        //WKNavigationDelegate 의 델리게이트 객체를 지정
        self.wv.navigationDelegate = self
        
        //내비게이션 바의 타이틀에 영화이름
        let navibar = self.navigationItem
        navibar.title = self.mvo.title
        
        if let url = self.mvo.detail{
            if let urlObj = URL(string: url){
                let req = URLRequest(url: urlObj)
                self.wv.load(req)
            }else{
                //경고창 형식으로 오류 메시지
                let alert = UIAlertController(title: "오류", message: "잘못된 URL 입니다.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "확인", style: .cancel){(_) in
                    //이전 페이지로 되돌려보낸다.
                    _ = self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(cancelAction)
                self.present(alert,animated: false)
            }
        }else{//URL 값이 전달되지 않았을 경우에 대한 예외처리
            //경고창 형식으로 오류 메시지를 표시해준다.
            let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다.", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel){(_)in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(cancelAction)
            self.present(alert, animated: false, completion: nil)
        }
        
        //URLRequest 인스턴스를 생성한다.
        let url = URL(string: (self.mvo.detail)!)
        let req = URLRequest(url: url!)
        
        //loadRequest 메소드를 호출하면서 req를 인자값으로 전달한다.
        self.wv.load(req)
    }
}

//MARK:- WKnavigationDelegate 프로토콜 구현
extension DetailViewController: WKNavigationDelegate{
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.spinner.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.spinner.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        self.alert("상세 페이지를 읽어오지 못했습니다."){
            //이전화면으로
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.spinner.stopAnimating()
        self.alert("상세 페이지를 읽어오지 못했습니다."){
            //이전화면으로
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
}

//실무에서 사용하는 alert 코드
extension UIViewController{
    func alert(_ message: String, onClick: (()-> Void)? = nil){
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel){
            (_)in onClick?()
        })
        DispatchQueue.main.async {
            self.present(controller, animated: false)
        }
    }
}

    

