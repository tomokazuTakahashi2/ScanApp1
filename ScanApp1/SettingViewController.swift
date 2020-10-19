//
//  SettingViewController.swift
//  ScanApp1
//
//  Created by Raphael on 2020/10/19.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import EMAlertController

class SettingViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var album: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ナビゲーションバーを非表示（表示・・・false）
        navigationController?.setNavigationBarHidden(false, animated: true)

        // 中心まで移動させる
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveLinear], animations: {
            
            //アニメーション
            self.camera.center.x = self.view.center.x
            self.album.center.x = self.view.center.x
            
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }, completion: {(finished: Bool)in
            
        })
    }
    @IBAction func openCamera(_ sender: Any) {
        
        let sourceType: UIImagePickerController.SourceType = .camera
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    @IBAction func openAlbum(_ sender: Any) {
        let sourceType: UIImagePickerController.SourceType = .photoLibrary
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.originalImage] as? UIImage{
            
            imageView.image = pickedImage
            //アラートを出す
            DispatchQueue.main.async {
                self.checkAlert()
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    //キャンセル時
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func checkAlert(){
        let alert = EMAlertController(icon: UIImage(named: ""), title: "確認", message: "この背景画像でよろしいですか？")
        let action1 = EMAlertAction(title: "はい", style: .normal){
            
            self.imageView.contentMode = .scaleAspectFill
            var data = Data()
            data = self.imageView.image?.pngData() as! Data
            UserDefaults.standard.set(data, forKey: "image")
            self.navigationController?.popViewController(animated: true)
        }
        let action2 = EMAlertAction(title: "もう１度", style: .normal)
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
