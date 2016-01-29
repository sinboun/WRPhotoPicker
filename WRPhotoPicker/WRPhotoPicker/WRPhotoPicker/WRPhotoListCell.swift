//
//  WRPhotoListCell.swift
//  WRPhotoPicker
//
//  Created by 温锐 on 16/1/6.
//  Copyright © 2016年 wbg. All rights reserved.
//

import UIKit
import AssetsLibrary

/**
 *  WRPhotoListCell的代理
 */
@objc protocol WRPhotoListCellDelegate:NSObjectProtocol {
    
    //每次点击相关方法
    func shouldSelectAsset(asset:AnyObject)->Bool
    
    func didSelectAsset(asset:AnyObject)->Void
    
    func didDeselectAsset(asset:AnyObject)->Void
    
    

//    //特殊的cell 点击操作
    func tapAction(asset:AnyObject)
    
    
    
    
}



class WRPhotoListCell: UICollectionViewCell,WRTapAssetViewDelegate{
    
    var delagate:WRPhotoListCellDelegate?
    
    private var imageView:UIImageView!
    private var tapAssetView:WRTapAssetView!
    private var asset:AnyObject!
    
    func bind(asset:AnyObject,selectionFilter:NSPredicate,isSeleced:Bool){
        self.asset = asset
        
        if (self.imageView == nil) {
            let imageView:UIImageView=UIImageView(frame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height))
            self.contentView.addSubview(imageView)
            self.imageView = imageView;
            self.imageView.contentMode=UIViewContentMode.ScaleAspectFill
            self.imageView.layer.cornerRadius = 3;
            self.imageView.clipsToBounds = true;
            self.backgroundColor = UIColor.whiteColor()
        }
        if ((self.tapAssetView == nil)) {
            let tapView:WRTapAssetView=WRTapAssetView(frame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height))
            tapView.delegate = self;
            self.contentView.addSubview(tapView)
            self.tapAssetView = tapView;
            
        }
        
        if (asset.isKindOfClass(UIImage.classForCoder())) {
            self.imageView.image=asset as? UIImage
        } else {
            let image=UIImage(CGImage: asset.aspectRatioThumbnail().takeUnretainedValue())
            self.imageView.image=image
        }
        
        tapAssetView.disabled = !selectionFilter.evaluateWithObject(asset)
        tapAssetView.selected = isSeleced;
    
    
    }
    
    
    /**
     --------------------代理－－－－－－－－－－－－－－－－
     */

    func shouldTap() -> Bool {
    
            return delagate!.shouldSelectAsset(self.asset)
            
       
    }
    
    func touchSelect(select: Bool) {
        if select{
            delagate?.didSelectAsset(self.asset)
        }else{
            delagate?.didDeselectAsset(self.asset)
        
        
        }
    }
    
    func shouldTapAction() {
         delagate?.tapAction(self.asset)
    }
    

    
    
    
    


}
