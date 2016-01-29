//
//  ViewController.swift
//  WRPhotoPicker
//
//  Created by 温锐 on 16/1/6.
//  Copyright © 2016年 wbg. All rights reserved.
//

import UIKit
import AssetsLibrary
class ViewController: UIViewController,WRPhotoViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        let btn:UIButton=UIButton()
        btn.setTitle("选择", forState: UIControlState.Normal)
        btn.backgroundColor=UIColor.greenColor()
        btn.addTarget(self, action: "clikc", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btn)
        btn.wr_makeConstraints { (wrc) -> Void in
            wrc.width(100)
            wrc.height(60)
            wrc.center()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clikc(){
        let vc:WRPhotoViewController=WRPhotoViewController()
        vc.assetsFilter = ALAssetsFilter.allPhotos()
        vc.delegate=self
        vc.showEmptyGroups = true;
        vc.maximumNumberOfSelection=6
        vc.selectionFilter=NSPredicate(block: { (evaluatedObject, bindings) -> Bool in
            return true;
        })
        self.presentViewController(vc, animated: true, completion: nil)
         
    }
  
    
    
    func PhotoViewControllerDidCancel(page: WRPhotoViewController) {
        page.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    //相关操作
    func PhotoPickerTapAction(picker:WRPhotoViewController){
        print("PhotoPickerTapAction")
    
    }
    
    //超过最大选择项时
    func PhotoViewControllerDidMaxnum(page:WRPhotoViewController){
          print("PhotoViewControllerDidMaxnum")
    
    }
    
    //低于最低选择项时
    func PhotoViewControllerDidMinnum(page:WRPhotoViewController){
        print("PhotoViewControllerDidMinnum")
    
    }
    
    func PhotoViewController(page: WRPhotoViewController, didDelectAsset: AnyObject) {
        print("didDelectAsset")
    }
    
    func PhotoViewController(page: WRPhotoViewController, didSelectAssets: NSArray) {
         page.dismissViewControllerAnimated(true, completion: nil)
         print("didSelectAssets")
//        var image = UIImage(CGImage:didSelectAssets[0].thumbnail().takeUnretainedValue())
//    print(image)
    }
    func PhotoViewController(page: WRPhotoViewController, didSelectAsset: AnyObject) {
        print("didSelectAsset")
    }
    
    
    
    
    
    
    

}

