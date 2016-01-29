//
//  WRPhotoViewControllerDelegate.swift
//  WRPhotoPicker
//
//  Created by 温锐 on 16/1/6.
//  Copyright © 2016年 wbg. All rights reserved.
//

import UIKit
import AssetsLibrary

/**
 *  图片选择控制器的代理
 */
@objc protocol WRPhotoViewControllerDelegate:NSObjectProtocol {
    
    /** 选择完成 */
    optional func PhotoViewController(page:WRPhotoViewController,didSelectAssets:NSArray)
    
    /** 选择完成 */
    optional func PhotoViewController(page:WRPhotoViewController,didSelectAsset:AnyObject)
    
    /** 选择完成 */
    optional func PhotoViewController(page:WRPhotoViewController,didDelectAsset:AnyObject)
    
    //相关操作
    optional func PhotoPickerTapAction(picker:WRPhotoViewController)        
    
    /** 用户取消选择 */
    optional func PhotoViewControllerDidCancel(page:WRPhotoViewController)
    
    //超过最大选择项时
    optional func PhotoViewControllerDidMaxnum(page:WRPhotoViewController)
    
    //低于最低选择项时
    optional func PhotoViewControllerDidMinnum(page:WRPhotoViewController)    
    
}


//二进制颜色转换
extension UIColor{
    
    convenience init(WRRGB:Int){
        self.init(WRRGB:WRRGB,alpha:1)
    }
    
    convenience init(WRRGB:Int,alpha:CGFloat){
        self.init(red: CGFloat(Float((WRRGB&0xff0000)>>0x10)/255), green:CGFloat(Float((WRRGB&0xff00)>>8)/255), blue: CGFloat(Float(WRRGB&0xff)/255), alpha: alpha)
    }
}




