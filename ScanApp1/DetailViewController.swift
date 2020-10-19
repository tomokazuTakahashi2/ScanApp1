//
//  DetailViewController.swift
//  ScanApp1
//
//  Created by Raphael on 2020/10/19.
//  Copyright © 2020 Raphael. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var nameString = String()
    var companyString = String()
    var memoString = String()
    var cardImage = String()
    var dateString = String()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //イメージビューの向きを変える
    var imageView_x = CGFloat()
    var imageView_y = CGFloat()
    var imageView_w = CGFloat()
    var imageView_h = CGFloat()
    var imageView_center_y = CGFloat()
    
    var blackView = UIView()
    var closeButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //黒背景
        blackView.frame = self.view.bounds //画面全体にblackViewを適用する
        blackView.backgroundColor = .black
        blackView.isHidden = true   //blackViewを非表示にしておく
        blackView.alpha = 0     //透明にしておく
        self.view.addSubview(blackView)

        //SDWebImage
        imageView.sd_setImage(with: URL(string: cardImage),completed: nil)
        //ラベルにデータを配置する
        nameLabel.text = nameString
        companyLabel.text = companyString
        memoLabel.text = memoString
        dateLabel.text = dateString
        
        //イメージビューの向きを変える
        imageView_x = imageView.frame.origin.x
        imageView_y = imageView.frame.origin.y
        imageView_w = imageView.frame.size.width
        imageView_h = imageView.frame.size.height
        imageView_center_y = imageView.center.y
    
        //タップした時
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
    }
    //イメージビューをタップしたら
    @objc func imageViewTapped(_ sender:UITapGestureRecognizer){
        
        //アニメーション
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveLinear], animations: {
            
            //アニメーション1
            self.blackView.isHidden = false //非表示を解除する
            self.blackView.alpha = 1.0  //透明を解除する
            self.imageView.center.y = self.view.center.y    //Y軸センターを合わせる
            self.imageView.layer.zPosition = 1  //Z軸は１
            let transAnimation1 = CGAffineTransform(rotationAngle: CGFloat(90 * CGFloat.pi/180))    //90度傾ける（90×円周率÷180）
            
            //アニメーション2
            let transAnimation2 = CGAffineTransform(scaleX: 3, y: 3)
            //アニメーション3
            let transAnimation3 = transAnimation1.concatenating(transAnimation2)
            self.imageView.transform = transAnimation3
            //ナビゲーションを消す
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        //アニメーションが終わったら、
        },completion: {(finished: Bool)in
   
            //閉じるボタンをつける
            self.closeButton.layer.zPosition = 2
            self.closeButton.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: 50, height: 50)
            self.closeButton.setImage(UIImage(named: ""), for: .normal)
            self.closeButton.addTarget(self, action: #selector(self.tapCloseButton), for: .touchUpInside)
            self.view.addSubview(self.closeButton)
        })
    }
    @objc func tapCloseButton(){
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveLinear], animations: {
            
            //アニメーション
            self.blackView.isHidden = true
            self.blackView.alpha = 0
            
            self.imageView.layer.zPosition = 1
            let transAnimation1 = CGAffineTransform(rotationAngle: CGFloat(0 * CGFloat.pi/180))
            self.imageView.frame = CGRect(x: self.imageView_x, y: self.imageView_y, width: self.imageView_w, height: self.imageView_h)
            //ナビゲーションを再開する
            self.navigationController?.setNavigationBarHidden(false, animated: true)
            
        //アニメーションが終わったら、
        },completion: {(finished: Bool)in
            
            //クローズボタンを消す
            self.closeButton.removeFromSuperview()
            //blackViewを隠す
            self.blackView.isHidden = true
        })
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
