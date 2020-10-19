//
//  EditViewController.swift
//  ScanApp1
//
//  Created by Raphael on 2020/10/18.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import Firebase
import Lottie
import Pastel

class EditViewController: UIViewController,UITextFieldDelegate {
    
    var cardImage = UIImage()
    //グラデーション
    var pastelView1 = PastelView()
    //アニメーション
    var animationView: AnimationView! = AnimationView()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = cardImage
        nameTextField.delegate = self
        companyTextField.delegate = self
        memoTextField.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        
        //グラデーション
        pastelView1.removeFromSuperview(); graduationStart1()
        NotificationCenter.default.addObserver(self, selector:
            #selector(viewWillEnterForeground(
                notification:)), name: UIApplication.willEnterForegroundNotification,
                                 object: nil)
        NotificationCenter.default.addObserver(self, selector:
            #selector(viewDidEnterBackground(
                notification:)), name: UIApplication.didEnterBackgroundNotification,
                                 object: nil)
    }
//MARK:- グラデーション
    @objc func viewWillEnterForeground(notification: Notification) {
        print("フォアグラウンド")
        pastelView1.removeFromSuperview()
        graduationStart1()
    }
    // AppDelegate -> applicationDidEnterBackgroundの通知
    @objc func viewDidEnterBackground(notification: Notification) {
        print("バックグラウンド")
    }
    func graduationStart1(){
        pastelView1 = PastelView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:
            self.view.frame.size.height))
        // Custom Direction
        pastelView1.startPastelPoint = .bottomLeft
        pastelView1.endPastelPoint = .topRight
        // Custom Duration
        pastelView1.animationDuration = 2.0
        // Custom Color
        pastelView1.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0), UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0), UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                               UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                               UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0), UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                               UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
        pastelView1.startAnimation()
        view.insertSubview(pastelView1, at: 0)
    }
//MARK:-アニメーション
    func startAnimation(){
        let animation = Animation.named("scan")
        animationView.animation = animation
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:
            self.view.frame.size.height)
        animationView.contentMode = .scaleAspectFit
        animationView.layer.zPosition = 1
        animationView.loopMode = .loop
        animationView.backgroundColor = .white
    }
//MARK:-Firebaseに保存
    func addData(){
        
        startAnimation()
        //textFieldのキーボードを閉じる
        nameTextField.resignFirstResponder()
        companyTextField.resignFirstResponder()
        memoTextField.resignFirstResponder()
        
        //Firebaseの保存先(RealtimeDatabase,Storage)
        let rootRef = Database.database().reference(fromURL: "https://scanapp1-436ea.firebaseio.com/").child("post")
        let storage = Storage.storage().reference(forURL: "gs://scanapp1-436ea.appspot.com")
        let key = rootRef.child("Users").childByAutoId().key
        let imageRef = storage.child("Users").child("\(String(describing: key!)).jpg")
        
        print(imageRef)
        
        var data: Data = Data()
        //imageView.imageがnilじゃなかったら、
        if let image = imageView.image{
            //imageViewのimageをjpeg形式の0.5に圧縮してData型にする
            data = image.jpegData(compressionQuality: 0.5)! as Data
        }
        //putData()
        let uploadTask = imageRef.putData(data, metadata: nil){(mataData,error) in
            //errorがnilじゃなかったら、
            if error != nil{
                //１つ前の画面に戻る
                self.navigationController?.popViewController(animated: true)
                
                return
            }
            //downloadURL()
            imageRef.downloadURL(completion: {(url,error) in
                
                //urlがnilじゃなかったら、
                if url != nil{
                    let feed = ["company":self.companyTextField.text as Any,"userName":self.nameTextField.text as Any,"imageString":url?.absoluteString as Any, "memo":self.memoTextField.text as Any,"createAt":ServerValue.timestamp()] as [String:Any]
                    //childByAutoId().keyの名前でfeedを書き込む
                    let postFeed = ["\(key!)":feed]
                    //Database.database().reference().child("post")にpostFeedを書き込む
                    rootRef.updateChildValues(postFeed)
                    //アニメーションを消去する
                    self.animationView.removeFromSuperview()
                    //１つ画面を戻る
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
        }
        //アップロードを再開する
        uploadTask.resume()
        //閉じる
        self.dismiss(animated: true, completion: nil)
    }
    //タッチしたら、
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //キーボードを閉じる
        nameTextField.resignFirstResponder()
        companyTextField.resignFirstResponder()
        memoTextField.resignFirstResponder()
    }
    
    //登録ボタン
    @IBAction func add(_ sender: Any) {
        
        addData()
    }
}
