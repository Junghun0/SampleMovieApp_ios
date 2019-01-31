//
//  ListViewController.swift
//  SampleMovieApp
//
//  Created by 박정훈 on 30/01/2019.
//  Copyright © 2019 swift. All rights reserved.
//

import Foundation
import UIKit

class ListViewController: UITableViewController{
    
    var page = 1
    
    lazy var list: [MovieVO] = {
        var datalist = [MovieVO]()
        return datalist
    }()
    @IBAction func more(_ sender: Any) {
        self.page += 1
        self.callMovieAPI()
        self.tableView.reloadData()

    }
    @IBOutlet weak var moreBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callMovieAPI()
    }
    
    func callMovieAPI(){
        let url = "http://swiftapi.rubypaper.co.kr:2029/hoppin/movies?version=1&page=\(self.page)&count=10&genreId=&order=releasedateasc"
        let apiURI: URL! = URL(string: url)
        
        let apidata = try! Data(contentsOf: apiURI)
        
        let log = NSString(data: apidata, encoding: String.Encoding.utf8.rawValue) ?? "데이터x"
        NSLog("\(log)")
        
        do{
            let apiDictionary = try JSONSerialization.jsonObject(with: apidata, options: []) as! NSDictionary
            
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            for row in movie {
                let r = row as! NSDictionary
                
                let mvo = MovieVO()
                
                mvo.title = r["title"] as? String
                mvo.description = r["genreNames"] as? String
                mvo.thumbnail = r["thumbnailImage"] as? String
                mvo.detail = r["linkUrl"] as? String
                mvo.rating = ((r["ratingAverage"] as! NSString).doubleValue)
                
//                let url: URL! = URL(string: mvo.thumbnail!)
//                let imageData = try! Data(contentsOf: url)
//                mvo.thumbnailImage = UIImage(data: imageData)
                
                self.list.append(mvo)
                
                let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
                if(self.list.count >= totalCount){
                    self.moreBtn.isHidden = true
                }
            }
        }catch{}
    }
    
    func getThumbnail(_ index: Int) -> UIImage{
        //인자값으로 받은 인덱스를 기반으로 해당하는 배열 데이터를 읽어옴
        let mvo = self.list[index]
        
        //메모제이션 : 저장된 이미지가 있으면 그것을 반환하고, 없을 경우 내려받아 저장한 후 변환
        if let savedImage = mvo.thumbnailImage{
            return savedImage
        }else{
            let url: URL! = URL(string: mvo.thumbnail!)
            let imageData = try! Data(contentsOf: url)
            mvo.thumbnailImage = UIImage(data: imageData)//UIImage를 MovieVo 객체에 우선저장
            
            return mvo.thumbnailImage!//저장된 이미지 리턴
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.list[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as! MovieCell
        
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        
//        let url: URL! = URL(string: row.thumbnail!)
//
//        let imageData = try! Data(contentsOf: url)
//        cell.thumbnail.image = UIImage(data: imageData)
        
        
        //cell.thumbnail.image = row.thumbnailImage
        
        //비동기 방식으로 섬네일 이미지를 읽어옴
        DispatchQueue.main.async(execute: {
            NSLog("비동기 실행부분!")
            cell.thumbnail.image = self.getThumbnail(indexPath.row)
        })
        
        NSLog("메소드 종료 셀 리턴!")
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
extension ListViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "segue_detail"){
            //사용자가 클릭한 행을 찾아낸다
            let path = self.tableView.indexPath(for: sender as! MovieCell)
            
            //행 정보를 통해 선택된 영화 데이터를 찾은 다음, 목적지 뷰 컨트롤러의 mvo 변수에 대입한다.
            let detailVC = segue.destination as? DetailViewController
            detailVC?.mvo = self.list[path!.row]
        }
    }
}
