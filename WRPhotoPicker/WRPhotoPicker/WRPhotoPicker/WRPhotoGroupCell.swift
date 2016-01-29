//
//  WRPhotoGroupCell.swift
//  WRPhotoPicker
//
//  Created by 温锐 on 16/1/7.
//  Copyright © 2016年 wbg. All rights reserved.
//

import UIKit
import AssetsLibrary
import Foundation

/// 相册列表
class WRPhotoGroupCell: UITableViewCell {
    

    //所有相册组
    private var assetsGroup:ALAssetsGroup!
    //显示相册的第一张照片
    private var groupImageView:UIImageView!
    //相册的名称
    private var groupTextLabel:UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(assetsGroup:ALAssetsGroup){
        self.assetsGroup=assetsGroup
        self.backgroundColor = UIColor(WRRGB: 0xebebeb)
        if (self.groupImageView == nil) {
            let imageView:UIImageView = UIImageView(frame: CGRectMake(14, 5, 50, 50))
            self.contentView.addSubview(imageView)
            self.groupImageView = imageView;
        }
        
        if (self.groupTextLabel == nil) {
            let textLabel:UILabel=UILabel(frame: CGRectMake(70,self.bounds.size.height/2-10,UIScreen.mainScreen().bounds.size.width-70,20))
                textLabel.font = UIFont.systemFontOfSize(15)
                textLabel.backgroundColor = UIColor.clearColor()
                self.contentView.addSubview(textLabel)
                self.groupTextLabel = textLabel;
        }
        
       let posterImage  = assetsGroup.posterImage().takeUnretainedValue()
        let height:Int  = CGImageGetHeight(posterImage);
        let scale:Float  = Float(height)/78.0;
        
        self.groupImageView.image = UIImage(CGImage: posterImage, scale: CGFloat(scale), orientation: UIImageOrientation.Up)
        let text:String? = assetsGroup.valueForProperty(ALAssetsGroupPropertyName) as? String
        self.groupTextLabel.text = text
    
    }
    
    
    
    
    
    

}
