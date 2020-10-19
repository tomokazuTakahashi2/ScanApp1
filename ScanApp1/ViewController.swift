//
//  ViewController.swift
//  ScanApp1
//
//  Created by Raphael on 2020/10/17.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import LineSDK
import Photos
import SVProgressHUD

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var lineLoginButton: LoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ユーザーに許可を促す
        PHPhotoLibrary.requestAuthorization{(status) in
        
            switch(status){
                
            case.authorized:
                break
            case.denied:
                break
            case.notDetermined:
                break
            case.restricted:
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        //ナビゲーションバーを消す
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    //ログインボタン
    @IBAction func loginAction(_ sender: Any) {
        
        LoginManager.shared.login(permissions: [.profile], in: self){ result in
            
            switch result{
            //成功した場合
            case .success(let loginResult):
                
                //loginResult.userProfileがnilじゃなかったら
                if let profile = loginResult.userProfile {
                    //profile.displayNameをUserDefaultに保存
                    UserDefaults.standard.set(profile.displayName,forKey: "displayName")
                    
                    do {
                        let data = try Data(contentsOf: profile.pictureURL!)
                        UserDefaults.standard.set(data, forKey: "pictureURLString")
                    }catch let error{
                        print(error)
                        
                    }
                    
                    
                    //画面遷移
                    let cardVC = self.storyboard?.instantiateViewController(withIdentifier: "cardVC")as! CardViewController
                    self.navigationController?.pushViewController(cardVC, animated: true)
                    
                }
            //失敗した場合
            case.failure(let error):
                print(error)
                SVProgressHUD.showError(withStatus: "ログインに失敗しました")
            }
        }
    }
    

}

