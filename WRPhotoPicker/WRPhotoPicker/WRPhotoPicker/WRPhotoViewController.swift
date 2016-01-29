//
//  WRPhotoViewController.swift
//  WRPhotoPicker
//
//  Created by 温锐 on 16/1/6.
//  Copyright © 2016年 wbg. All rights reserved.
//

import UIKit
import AssetsLibrary
/// 图片选择器
class WRPhotoViewController: UIViewController,WRPhotoListViewDelegate,WRPhotoGroupViewDelegate,UIAlertViewDelegate {
    
    /// 事件代理
    var delegate:WRPhotoViewControllerDelegate?
    
    //选择过滤
    var  selectionFilter:NSPredicate!
    
    //资源过滤
    var  assetsFilter:ALAssetsFilter!
    
    /// 选中的图片
    var  indexPathsForSelectedItems:NSMutableArray=NSMutableArray()
    
    //最多选择项
    var maximumNumberOfSelection:Int=1
    
    //最少选择项
    var minimumNumberOfSelection:Int=1
    
    //显示空相册
    var showEmptyGroups:Bool=false
    
    //是否开启多选
    var multipleSelection:Bool=false
    
    //--------------私有-----------
    //相册组
    private var photoGroupView:WRPhotoGroupView!
    //标题提示
    private var titleLabel:UILabel!
    //导航栏视图
    private var navBar:UIView!
    //背景是图
    private var bgMaskView:UIView!
    
    
 //相册组的高度
    private var _photoGroupViewHeight:CGFloat=0

    
    //相册组的高度
    var photoGroupViewHeight:CGFloat{
        set{
            _photoGroupViewHeight=newValue

        }
        get{
            if _photoGroupViewHeight==0{
                _photoGroupViewHeight=UIScreen.mainScreen().bounds.size.height*0.4
                if _photoGroupViewHeight<200{
                    _photoGroupViewHeight=200
                }
            
            }
            
            return _photoGroupViewHeight
            
            

        }
    
    }
    
    
    
    
    
    
    
    
    //相册列表
    private var photoListView:WRPhotoListView!
    //确定按钮
    private var okBtn:UIButton!
    //是否没有权限
    private var isNotAllowed:Bool=false
    //是否没有权限
    private var selectTip:UIImageView!
    
    
    
    //－－－－－－－－－－－－－－－－－－－－－－－－－重写UIViewController init
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    convenience  init() {
        self.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.assetsFilter = ALAssetsFilter.allAssets()
        showEmptyGroups = false;
        selectionFilter = NSPredicate(value: true)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     //－－－－－－－－－－－－－－－－－－－－－－－－－重写UIViewController init end //－－－－－－－－－－－－－－－－－－－－－
    
    /**
     加载视图
     */
    override func loadView() {
        super.loadView()
        //加载控件
        //导航条
        self.setupNavBar()
        
        //列表view
        self.setupPhotoListView()
        
        //相册分组
        self.setupGroupView()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showNotAllowed", name: "NotAllowedPhoto", object: nil)
        //数据初始化
        self.setupData()
       
    }
    
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    
    }
    
    
    
    
    //=---------------------- 界面初r始化
    private func setupNavBar(){
        let navBar:UIView = UIView()
         navBar.backgroundColor = UIColor(WRRGB: 0xec4243);
        
        self.view.addSubview(navBar)
        navBar.wr_makeConstraints { (wrc) -> Void in
            wrc.height(64)
            wrc.left(self.view)
            wrc.right(self.view)
        }
        self.navBar=navBar
        //取消按钮
        let cancelBtn:UIButton=UIButton(type: .Custom)
        cancelBtn.setTitle("取消", forState: UIControlState.Normal)
        cancelBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelBtn.titleLabel?.font=UIFont.systemFontOfSize(15)
        cancelBtn.addTarget(self, action: "cancelBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(cancelBtn)
        cancelBtn.wr_makeConstraints { (wrc) -> Void in
            wrc.height(44)
            wrc.left(navBar)
            wrc.top(navBar, attribute: NSLayoutAttribute.Top, offset: 20)
            wrc.width(60)
        }
        
        //title
        let titleLabel:UILabel = UILabel()
        titleLabel.textAlignment = NSTextAlignment.Center;
        titleLabel.textColor = UIColor.whiteColor()
        navBar.addSubview(titleLabel)
        titleLabel.wr_makeConstraints { (wrc) -> Void in
            wrc.centerX()
            wrc.centerY(10)
            
        }
        
        self.titleLabel = titleLabel;
        let tapBtn:UIButton  = UIButton(type: .Custom)
        tapBtn.backgroundColor = UIColor.clearColor()
        tapBtn.addTarget(self, action: "selectGroupAction:", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(tapBtn)
        tapBtn.wr_makeConstraints { (wrc) -> Void in
            wrc.centerX()
            wrc.centerY(10)
            wrc.height(44)
            wrc.width(titleLabel)
        }
        
        
        //selectTipImageView
        let selectTip:UIImageView  = UIImageView()
        selectTip.image = UIImage(named: "BoSelectGroup_tip")
        navBar.addSubview(selectTip)
        self.selectTip = selectTip;

        selectTip.wr_makeConstraints { (wrc) -> Void in
            wrc.left(titleLabel, attribute: NSLayoutAttribute.Right, offset: 5)
            wrc.width(8)
            wrc.height(5)
            wrc.centerY(titleLabel)
        }
   
        
        
        let okBtn:UIButton  = UIButton(type: .Custom)
        okBtn.backgroundColor = UIColor.clearColor()
        okBtn.setTitle("确定", forState: UIControlState.Normal)
        okBtn.titleLabel?.font=UIFont.systemFontOfSize(15)
        okBtn.addTarget(self, action: "okBtnAction:", forControlEvents: UIControlEvents.TouchUpInside)
        navBar.addSubview(okBtn)
        okBtn.wr_makeConstraints { (wrc) -> Void in
            wrc.height(44)
            wrc.width(60)
            wrc.right(navBar)
            wrc.top(navBar, attribute: NSLayoutAttribute.Top, offset: 20)

        }
        
        
        self.okBtn = okBtn;
        
    
    }
    
    
    func setupPhotoListView(){
        let collectionView:WRPhotoListView  = WRPhotoListView()
        collectionView.my_delegate = self;
        self.view.insertSubview(collectionView, atIndex: 0)
        collectionView.wr_makeConstraints { (wrc) -> Void in
            wrc.left(self.view)
            wrc.top(self.view, attribute: NSLayoutAttribute.Top, offset: 64)
            wrc.bottom(self.view)
            wrc.right(self.view)
        }
        self.photoListView = collectionView;
    
    
    }
    
    
    func setupGroupView(){
        
        let photoGroupView:WRPhotoGroupView = WRPhotoGroupView()
        photoGroupView.assetsFilter = self.assetsFilter;
        photoGroupView.my_delegate = self;
        
//        self.view.insertSubview(photoGroupView, aboveSubview: self.navBar)
        self.view.insertSubview(photoGroupView, belowSubview: self.navBar)
        
        self.photoGroupView = photoGroupView;
        photoGroupView.hidden = true;
        photoGroupView.wr_makeConstraints { (wrc) -> Void in
            wrc.left(self.view)
            wrc.top(self.navBar, attribute: NSLayoutAttribute.Bottom, offset: -self.photoGroupViewHeight)
            wrc.right(self.view)
            wrc.height(self.photoGroupViewHeight)
        }
    
    
    }
    
    //加载相册
    func setupData(){
        self.photoGroupView.setupGroup()
    
    }
    
    //------------------------------相册切换------------------------
    func selectGroupAction(sender:UIButton){
        
        
        if self.isNotAllowed {
            return;
        }
        if self.photoGroupView.hidden{
            self.initbgMaskView()
             self.photoGroupView.hidden=false
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.photoGroupView.transform = CGAffineTransformMakeTranslation(0, self.photoGroupViewHeight);
                self.selectTip.transform = CGAffineTransformMakeRotation(CGFloat(M_PI));
                })
        }else{
            self.hidenGroupView()
        
        
        }
        
    
    }
    
    func hidenGroupView(){
        
        self.bgMaskView?.removeFromSuperview()
        self.bgMaskView=nil
        UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.photoGroupView.transform = CGAffineTransformIdentity;
                self.selectTip.transform = CGAffineTransformIdentity;
            }) { (isok) -> Void in
                self.photoGroupView.hidden=true
        }
    
    }
    
    
    /**
    *  WRPhotoGroupViewDelegate
    */
    func tapAction(asset: AnyObject) {
        
        if(asset.isKindOfClass(UIImage.classForCoder()) ){
            delegate?.PhotoPickerTapAction?(self)
        
        }
    }
    
    //按钮点击Action
    //取消点击事件
    func cancelBtnAction(sender:UIButton){
        delegate?.PhotoViewControllerDidCancel?(self)
    
    }
    //确定点击事件
    func okBtnAction(sender:UIButton){
        if (self.minimumNumberOfSelection > self.indexPathsForSelectedItems.count) {
            delegate?.PhotoViewControllerDidMinnum?(self)
        
        }else{
            
            delegate?.PhotoViewController?(self, didSelectAssets: self.indexPathsForSelectedItems)
        }
    }
    
    
    
    
    //----------------------- 遮罩背景 ------------
    func initbgMaskView()->UIView{
        if (bgMaskView == nil) {
            
            let bgMaskView:UIView  = UIView()
           bgMaskView.alpha = 0.4;
            bgMaskView.backgroundColor = UIColor.blackColor()
            self.view.insertSubview(bgMaskView, aboveSubview: self.photoListView)
            
            bgMaskView.userInteractionEnabled=true
            bgMaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapBgMaskView:"))
            bgMaskView.wr_makeConstraints({ (wrc) -> Void in
                wrc.top(self.view)
                wrc.left(self.view)
                wrc.right(self.view)
                wrc.bottom(self.view)
            })
            self.bgMaskView=bgMaskView
        
        
        }
        
        return self.bgMaskView
    
    }

    //点击遮罩
    func tapBgMaskView(sender:UITapGestureRecognizer){
        
        if (!self.photoGroupView.hidden) {
            self.hidenGroupView()
        
        }
    
    
    }

    
    
    
   // ／／／／／没有访问权限提示
    func showNotAllowed(){
        //没有权限时隐藏部分控件
        self.isNotAllowed = true;
        self.selectTip.hidden = true;
        self.titleLabel.text = "无权限访问相册";
        self.okBtn.hidden = true;
        var alert:UIAlertView;
        if (NSString(string: UIDevice.currentDevice().systemVersion).floatValue < 8.0) {
            alert=UIAlertView(title: "提示", message: "请在iPhone的“设置”-“隐私”-“照片”中，找到天易便利更改", delegate: nil, cancelButtonTitle: "确定")
        
        }else{
            alert=UIAlertView(title:  "提示", message: "请在iPhone的“设置”-“隐私”-“照片”中，找到天易便利更改", delegate: self, cancelButtonTitle: "确定")
        
        
        }

        
        alert.show()
    
    
    }
  
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 1) {
            if #available(iOS 8.0, *) {
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            } else {
                //
            }
        
        }
    }
    
    
    func didSelectGroup(assetsGroup: ALAssetsGroup?) {
        
        
        if (assetsGroup != nil){
            
            self.photoListView.assetsGroup = assetsGroup!;
            self.titleLabel.text = assetsGroup?.valueForProperty(ALAssetsGroupPropertyName) as? String
            self.hidenGroupView()
            
        
        }
        
    }
    
    
    
   
    
    
}
