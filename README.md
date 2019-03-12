# SampleMovieApp_ios

Screenshots
---------
<div>
<img width = "200" src="https://user-images.githubusercontent.com/30828236/52042088-9d33c200-257f-11e9-8a57-9c0f284913a4.png">
<img width = "200" src="https://user-images.githubusercontent.com/30828236/52042125-b5a3dc80-257f-11e9-8591-b3c14774c794.png">
<img width = "200" src="https://user-images.githubusercontent.com/30828236/52042191-dcfaa980-257f-11e9-87ed-12349329965d.png">
<img width = "200" src="https://user-images.githubusercontent.com/30828236/52042215-ef74e300-257f-11e9-8189-d84e1a1bcbd8.png">
</div>


소스코드
---------
```swift
    func callTheaterAPI(){
        let requestURI = "http://swiftapi.rubypaper.co.kr:2029/theater/list"
        let sList = 100
        let type = "json"
        
        let urlObj = URL(string: "\(requestURI)?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")
        
        do{
            let stringdata = try NSString(contentsOf: urlObj! , encoding: 0x80_000_422)
            
            let encdata = stringdata.data(using:String.Encoding.utf8.rawValue)
            
            do{
                let apiArray = try JSONSerialization.jsonObject(with: encdata!, options: []) as? NSArray
                
                for obj in apiArray!{
                    self.list.append(obj as! NSDictionary)
                }
            } catch{
                let alert = UIAlertController(title: "실패", message: "데이터 분석이 실패하였습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .cancel))
                self.present(alert, animated: false, completion: nil)
            }
            self.startPoint += sList
            
        }catch{
            let alert = UIAlertController(title: "실패", message: "데이터를 불러오는데 실패하였습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: false, completion: nil)
        }
    }
 ```
