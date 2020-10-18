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

class EditViewController: UIViewController,UITextFieldDelegate {
    
    var cardImage = UIImage()

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
    func addData(){
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
                    let feed = ["company":self.companyTextField.text as Any,"userName":self.nameTextField.text as Any,"imageString":url?.absoluteURL as Any, "memo":self.memoTextField.text as Any,"creatAt":ServerValue.timestamp()] as [String:Any]
                    //childByAutoId().keyの名前でfeedを書き込む
                    let postFeed = ["\(key!)":feed]
                    //Database.database().reference().child("post")にpostFeedを書き込む
                    rootRef.updateChildValues(postFeed)
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

}
