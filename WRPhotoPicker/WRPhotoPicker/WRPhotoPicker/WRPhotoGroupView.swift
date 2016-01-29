//
//  WRPhotoGroupView.swift
//  WRPhotoPicker
//
//  Created by 温锐 on 16/1/7.
//  Copyright © 2016年 wbg. All rights reserved.
//

import UIKit
import AssetsLibrary
import Foundation


/**
 *  遮罩视图的代理
 */
@objc protocol WRPhotoGroupViewDelegate:NSObjectProtocol {
    
    //点击操作
    func didSelectGroup(assetsGroup: ALAssetsGroup?)
    
}



class WRPhotoGroupView: UITableView,UITableViewDataSource,UITableViewDelegate {
    
    //代理
    var my_delegate:WRPhotoGroupViewDelegate?
    
    //代理选择的索引
    var selectIndex:Int=0
    
    //过滤
    var assetsFilter:ALAssetsFilter!
    
    //所有图片库
    private var assetsLibrary:ALAssetsLibrary=ALAssetsLibrary()
    
    //名字集合
    private var _groups:NSMutableArray?
    var groups:NSMutableArray{
        get{
            if (_groups == nil){
                _groups=NSMutableArray()
            }
             return _groups!
        
        }
        set{
            _groups=newValue
        
        }
    
    
    }
    
    //初始化
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame,style:style)
        initCommon()
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    /**
     初始化
     
     - returns: nil
     */
    private func initCommon(){
        self.delegate = self;
        self.dataSource = self;
        self.registerClass(WRPhotoGroupCell.classForCoder(), forCellReuseIdentifier: "cell")
        self.separatorStyle = UITableViewCellSeparatorStyle.None;
        self.backgroundColor = UIColor(WRRGB: 0xebebeb);
       
    
    }

    
    /**
    加载相册
    */
    func setupGroup(){
        self.groups.removeAllObjects()
        
        let resultsBlock:ALAssetsLibraryGroupsEnumerationResultsBlock={ (group, stop) -> Void in
            if (group != nil){
                group.setAssetsFilter(self.assetsFilter)
                let vc=(self.my_delegate as! WRPhotoViewController)
                
                if group.numberOfAssets() > 0 || vc.showEmptyGroups {
                    
                    if(UInt32(group.valueForProperty(ALAssetsGroupPropertyType).intValue) == ALAssetsGroupSavedPhotos){
                        self.groups.insertObject(group, atIndex: 0)
                    }else if(UInt32(group.valueForProperty(ALAssetsGroupPropertyType).intValue) == ALAssetsGroupPhotoStream && self.groups.count>0){
                        self.groups.insertObject(group, atIndex: 1)
                        
                    }else{
                        self.groups.addObject(group)
                    }
                    
                    
                
                }
                
               
            
            }else{
                self.dataReload()
            
            }
        }
        
        let failureBlock:ALAssetsLibraryAccessFailureBlock  = { (error) -> Void in
             //没权限
            self.showNotAllowed()
            
        }

        
        let type:UInt32  = ALAssetsGroupSavedPhotos | ALAssetsGroupPhotoStream |
            ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent |
        ALAssetsGroupFaces
        
        self.assetsLibrary.enumerateGroupsWithTypes(type, usingBlock: resultsBlock, failureBlock: failureBlock)
        

    
    }
    
    
    /**
     重新数据显示
     */
    private func dataReload(){
        
        if (self.groups.count == 0){
            //没有图片
            self.showNoAssets()
        
        }

        if(self.groups.count>0){
            my_delegate?.didSelectGroup(self.groups[0] as? ALAssetsGroup)
        }
        self.reloadData()
        
        
    
    }
    
    //没权限
    private func showNotAllowed(){
       NSNotificationCenter.defaultCenter().postNotificationName("NotAllowedPhoto", object: nil)
        my_delegate?.didSelectGroup(nil)
        
    }
    
    //没有图片
    private func showNoAssets(){
        print("相册没有照片")
    
    }
    //---------------------------uitableviewDelegate-----------------------------------
    var  cellIdentifer:String  = "cell";
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:WRPhotoGroupCell?=tableView.dequeueReusableCellWithIdentifier(cellIdentifer, forIndexPath: indexPath) as? WRPhotoGroupCell
        if(cell == nil){
            cell = WRPhotoGroupCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifer)
        }
    
        cell?.bind(self.groups.objectAtIndex(indexPath.row) as! ALAssetsGroup)
        
        if (indexPath.row == self.selectIndex) {
            cell?.backgroundColor = UIColor(WRRGB: 0xd9d9d9);
        }
         return cell!;
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return self.groups.count;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0;
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectIndex = indexPath.row;
        self.reloadData()
        let group:ALAssetsGroup?=self.groups.objectAtIndex(indexPath.row) as? ALAssetsGroup
       my_delegate?.didSelectGroup(group)
        
    }
    
    
    

    
    
    
}
