//
//  CardViewController.swift
//  ScanApp1
//
//  Created by Raphael on 2020/10/17.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import MBDocCapture

class CardViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,ImageScannerControllerDelegate {
    
    var displayName = String()
    var pictureURLString = String()
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var myProfileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    weak var element: Element?
    var listOfData = [Element]()
    
    //カード
    var cardImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //UserDefaultsにログイン履歴を記録
        UserDefaults.standard.set(1, forKey: "loginOK")
        
        //ナビゲーションバーを非表示（表示・・・faise）
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        //引っ張って更新
        refreshControl.attributedTitle = NSAttributedString(string: "引っ張って更新！")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        //テーブルビューにrefreshControlを機能追加する
        tableView.addSubview(refreshControl)
        
        //テーブルビュー
        tableView.delegate = self
        tableView.dataSource = self
        
        //UserDefaultsを呼び出す
        displayName = UserDefaults.standard.object(forKey: "displayName")as! String
        pictureURLString = UserDefaults.standard.object(forKey: "pictureURLString")as! String
        
        displayNameLabel.text = displayName
        
        //SDWebImage
        let url = URL(string: pictureURLString)
        myProfileImageView.sd_setImage(with: url, completed: nil)
        
    }
    
    //#selector(refresh)
    @objc func refresh(){
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    
//MARK:-テーブルビュー
    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfData.count
    }
    //セルを構築
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //userNameLabelはセルのタグ番号(1)のラベルとして扱う
        let userNameLabel = cell.viewWithTag(1) as! UILabel
        userNameLabel.text = listOfData[indexPath.row].userName
        
        //companyNameLabelはセルのタグ番号(2)のラベルとして扱う
        let companyNameLabel = cell.viewWithTag(2) as! UILabel
        companyNameLabel.text = listOfData[indexPath.row].company
        
        //cardImageViewはセルのタグ番号(2)のイメージビューとして扱う
        cardImageView = cell.viewWithTag(3) as! UIImageView
        let profileImageURL = URL(string: listOfData[indexPath.row].imageString as! String)
        //SDWebImage
        cardImageView.sd_setImage(with: profileImageURL, completed: nil)
        //角丸にする
        cardImageView.layer.cornerRadius = 10.0
        //描画をUIImageViewの領域内に限定する
        cardImageView.clipsToBounds = true
        
        //creatAtLabelはセルのタグ番号(4)のラベルとして扱う
        let creatAtLabel = cell.viewWithTag(4) as! UILabel
        let dateUnix = Double(listOfData[indexPath.row].createAt!)as! TimeInterval
        let date = Date(timeIntervalSince1970: dateUnix/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd hh:mm"
        let dateStr: String = formatter.string(from: date)
        creatAtLabel.text = dateStr
        
        return cell
    }
    //セクションの数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //セルフのフレームの高さ÷３
        return self.view.frame.size.height/3
    }
    //タップされたセルに対して行う処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //値を渡しながら画面遷移
        let detailVC = self.storyboard?.instantiateViewController(identifier: "detail")as! DetailViewController
        //各パーツへ値を渡す
        detailVC.nameString = listOfData[indexPath.row].userName!
        detailVC.companyString = listOfData[indexPath.row].company!
        detailVC.memoString = listOfData[indexPath.row].memo!
        detailVC.cardImage = listOfData[indexPath.row].imageString!
        //日付も渡す
        let dateUnix = Double(listOfData[indexPath.row].createAt!)as! TimeInterval
        let date = Date(timeIntervalSince1970: dateUnix/1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateStr = formatter.string(from: date)
        detailVC.dateString = dateStr
        
        //detailVCへ画面遷移
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    //MARK:- データをFirebaseからとってくる
    func fetchData(){
        
        //データベースのpostの最新100件のpostDateのスナップショットからとってくる
        let ref = Database.database().reference(fromURL: "https://scanapp1-436ea.firebaseio.com/").child("post").queryLimited(toLast: 100).queryOrdered(byChild: "postDate").observe(.value){(snapshot) in
            
            //一旦listOfDataを削除する
            self.listOfData.removeAll()
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                
                //snapshotから一つずつ取り出す
                for snap in snapshot{
                    //取り出したものがnilじゃなかったら、
                    if let postData = snap.value as? [String:Any]{
                        let userName = postData["userName"]as? String
                        let company = postData["company"]as? String
                        let imageString = postData["imageString"]as? String
                        let memo = postData["memo"]as? String
                        var postDate:CLong?
                        if let postedDate = postData["createAt"]as? CLong{
                            postDate = postedDate
                        }
                        self.listOfData.append(Element(userName: userName!, company: company!, imageString: imageString!, memo: memo!, createAt: postDate!))
                    }
                }
                
                self.tableView.reloadData()
            }
        }
        
    }
//MARK:- カメラ
    @IBAction func openCamera(_ sender: Any) {
        
        //ImageScannerControllerのインスタンス
        let scannerViewController = ImageScannerController(delegate:self)
        //ドキュメントの表と裏をスキャンする
        scannerViewController.shouldScanTwoFaces = false
    }
    //ユーザーがドキュメントをスキャンしたことをデリゲートに通知します。
    /// -パラメーター：
    ///    -スキャナー：スキャンインターフェイスを管理するスキャナーコントローラーオブジェクト。
    ///    -結果：ユーザーがカメラでスキャンした結果。
    /// -ディスカッション：デリゲートによるこのメソッドの実装では、イメージスキャナーコントローラーを閉じる必要があります。
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        
        //値を保持して画面遷移
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "edit")as! EditViewController
        editVC.cardImage = results.scannedImage
        self.navigationController?.pushViewController(editVC, animated: true)
        
    }
    //ユーザーがドキュメントをスキャンしたことをデリゲートに通知します。
    /// -パラメーター：
    ///    -スキャナー：スキャンインターフェイスを管理するスキャナーコントローラーオブジェクト。
    ///    - page1Results：ユーザースキャンするページ1の結果
    ///    - page2Results：2ページをスキャンし、ユーザーの結果
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithPage1Results page1Results: ImageScannerResults, andPage2Results page2Results: ImageScannerResults) {
        //戻る
        scanner.dismiss(animated: true, completion: nil)
    }
    //ユーザーがスキャン操作をキャンセルしたことをデリゲートに通知します。
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        //戻る
        scanner.dismiss(animated: true, completion: nil)
    }
    //ユーザーのスキャンエクスペリエンス中にエラーが発生したことをデリゲートに通知します。
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        //戻る
        scanner.dismiss(animated: true, completion: nil)
    }
}
