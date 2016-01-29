//
//  WRPhotoListView.swift
//  WRPhotoPicker
//
//  Created by 温锐 on 16/1/6.
//  Copyright © 2016年 wbg. All rights reserved.
//

import UIKit
import AssetsLibrary
import Foundation

/**
 *  遮罩视图的代理
 */
@objc protocol WRPhotoListViewDelegate:NSObjectProtocol {
    
    //点击操作
    func tapAction(asset: AnyObject)
    
}

/// 图片容器
class WRPhotoListView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WRPhotoListCellDelegate {
    
    
    var my_delegate:WRPhotoListViewDelegate!
    
    private var _assetsGroup:ALAssetsGroup!
    
    var assetsGroup:ALAssetsGroup{
        get{
            return _assetsGroup
        }
        set{
            _assetsGroup=newValue
            self.setupAssets()
        
        }
    
    }
    
    
    private var assets:NSMutableArray=NSMutableArray()
    
    private var indexPathsForSelectedItems:NSMutableArray=NSMutableArray()
    
    init() {
        let flowLayout:UICollectionViewFlowLayout=UICollectionViewFlowLayout()
        flowLayout.scrollDirection=UICollectionViewScrollDirection.Vertical
        let frame:CGRect=CGRectMake(0, 64, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        super.init(frame:frame,collectionViewLayout:flowLayout)
        initCommon()
    }

    
    private func initCommon(){
        self.delegate = self;
        self.dataSource = self;
        self.registerClass(WRPhotoListCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        self.backgroundColor=UIColor.whiteColor()
    
    }
    
    
    /**
     加载图片
     */
    func setupAssets(){
        self.indexPathsForSelectedItems.removeAllObjects()
        self.assets.removeAllObjects()
        
        
        let tempList:NSMutableArray = NSMutableArray()
//        tempList.addObject(UIImage(named: "BoAssetsCamera")!)
        
        let resultsBlock:ALAssetsGroupEnumerationResultsBlock = {
            (asset, index, stop) -> Void in
           
            if ((asset) != nil){
                tempList.addObject(asset)
            
            }else if (tempList.count > 0){
                //排序
                let sortedList:NSArray=tempList.sortedArrayUsingComparator({ (first, second) -> NSComparisonResult in
                    
                let firstData=first.valueForProperty(ALAssetPropertyDate) as! NSDate
                let secondData=second.valueForProperty(ALAssetPropertyDate) as! NSDate
                return secondData.compare(firstData)//降序
                    
                })
               
                
                self.assets.addObjectsFromArray(sortedList as [AnyObject])
               self.assets.insertObject(UIImage(named: "BoAssetsCamera")!, atIndex: 0)
                
                self.scrollRectToVisible(CGRectMake(0, 0, 1, 1),animated:true)
                
               
            
            }
            
            if tempList.count == 0 {
             self.assets.insertObject(UIImage(named: "BoAssetsCamera")!, atIndex: 0)
            }
         
            
        }
     
        
        self.assetsGroup.enumerateAssetsUsingBlock(resultsBlock)
        self.reloadData()
    
    
    }
    

    //--------------代理－－－－－－－－－－－－－－－－
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.assets.count;
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell:WRPhotoListCell=collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as!  WRPhotoListCell
        let isSeleced:Bool=(self.my_delegate as! WRPhotoViewController).indexPathsForSelectedItems.containsObject(self.assets[indexPath.row])
        cell.delagate = self;
        
        cell.bind(self.assets[indexPath.row], selectionFilter: (self.my_delegate as! WRPhotoViewController).selectionFilter!, isSeleced: isSeleced)

        return cell;
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let wh:CGFloat  = (collectionView.bounds.size.width - 20)/3.0;
        
        return CGSizeMake(wh, wh);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 5.0;
    }
    
    
    //WRPhotoListCellDelegate
    func shouldSelectAsset(asset: AnyObject) -> Bool {
        if asset.isKindOfClass(UIImage.classForCoder()){
            return false
        }
        
        let vc:WRPhotoViewController  = self.my_delegate as! WRPhotoViewController;
        
        //单选

        if(vc.multipleSelection&&self.indexPathsForSelectedItems.count==1){
            let index:Int  = self.assets.indexOfObject(self.indexPathsForVisibleItems()[0])
            let indexPath:NSIndexPath  = NSIndexPath(forItem: index, inSection: 0)
            self.indexPathsForSelectedItems.removeAllObjects()
            self.reloadItemsAtIndexPaths([indexPath])
            
        }
        let selectable:Bool  = vc.selectionFilter.evaluateWithObject(asset)
        if self.indexPathsForSelectedItems.count >= vc.maximumNumberOfSelection && !vc.indexPathsForSelectedItems.containsObject(asset) {
            vc.delegate?.PhotoViewControllerDidMaxnum?(vc)
        
        }
     
        return (selectable && self.indexPathsForSelectedItems.count < vc.maximumNumberOfSelection);
        
        
    }
    
    func didSelectAsset(asset: AnyObject) {
        self.indexPathsForSelectedItems.addObject(asset)
        let vc:WRPhotoViewController  = self.my_delegate as! WRPhotoViewController;
        vc.indexPathsForSelectedItems = self.indexPathsForSelectedItems;
        vc.delegate?.PhotoViewController?(vc, didSelectAsset: asset)
    }

 
    
    func didDeselectAsset(asset:AnyObject){
        indexPathsForSelectedItems.removeObject(asset)
        let vc:WRPhotoViewController  = self.my_delegate as! WRPhotoViewController;
        vc.indexPathsForSelectedItems = self.indexPathsForSelectedItems
        vc.delegate?.PhotoViewController?(vc, didDelectAsset: asset)
    }
    
    
    func tapAction(asset: AnyObject) {
        self.my_delegate.tapAction(asset)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
