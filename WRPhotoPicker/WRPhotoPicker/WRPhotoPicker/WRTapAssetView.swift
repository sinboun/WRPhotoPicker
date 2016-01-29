//
//  WRTapAssetView.swift
//  WRPhotoPicker
//
//  Created by 温锐 on 16/1/6.
//  Copyright © 2016年 wbg. All rights reserved.
//

import UIKit



/**
 *  遮罩视图的代理
 */
@objc protocol WRTapAssetViewDelegate:NSObjectProtocol {
    
    //选中
     func touchSelect(select:Bool)
    //是否可选
    func shouldTap()->Bool
    
    //不可选时进行其他操作
    func shouldTapAction()
}

/// 选中图片时的遮罩层
class WRTapAssetView: UIView {
    //选中
    private var _selected:Bool=false
    
    //没有选择中
    private var _disabled:Bool=false
    
    
    //选中
    var selected:Bool{
        set{
            if (disabled) {
                self.backgroundColor = disabledColor;
                self.selectView.image=nil
                return;
            }
            _selected = newValue;
            
            if (_selected) {
                self.backgroundColor = selectedColor;
                self.selectView.image=checkedIcon
            }else{
                self.backgroundColor = UIColor.clearColor()
                self.selectView.image=nil
            }        
        }
        get{
            return self._selected
        }
    
    
    }
    
    //没有选择中
     var disabled:Bool{
        set{
            _disabled = newValue;
            if (_disabled) {
                self.backgroundColor = disabledColor;
            }else{
                self.backgroundColor = UIColor.clearColor()
            }
            
        }
        get{
            return self._disabled
            
        }
    }    
    
    
    //是否寻中
    var delegate:WRTapAssetViewDelegate?
    ///选中的图片
    private var checkedIcon:UIImage!
    //选中的颜色
    private var selectedColor:UIColor!
    //没有选中的颜色
    private var disabledColor:UIColor!
    
    //没有选中的颜色
    private var selectView:UIImageView!
    
    

    private func initialize(){
        checkedIcon=UIImage(named: "BoAssetsPickerChecked")
        selectedColor=UIColor(white: 1, alpha: 0.3)
        selectedColor=UIColor(white: 1, alpha: 0.8)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        self.backgroundColor=UIColor.clearColor()
        self.clipsToBounds=true
        selectView=UIImageView(frame: CGRect(x: frame.size.width-self.checkedIcon.size.width-1,y: frame.size.height-self.checkedIcon.size.height-1,width: checkedIcon.size.width,height: checkedIcon.size.height))
        self.addSubview(selectView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     开始触摸
     
     - parameter touches:
     - parameter event:
     */
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //执行触摸动画
        self.touchAnimation(touches)
        if (_disabled){
            return
        }
        if delegate != nil && delegate!.respondsToSelector("shouldTap"){
            if (!delegate!.shouldTap() && !_selected) {
                    delegate?.shouldTapAction()
         
                return
            }
        
        }
       
        if (_selected == false) {
            self.backgroundColor = selectedColor
            selectView.image=self.checkedIcon
        }else{
            self.backgroundColor = UIColor.clearColor()
            selectView.image=nil
        }
         _selected = !_selected
        

        
        if delegate != nil && delegate!.respondsToSelector("touchSelect:"){
            self.delegate?.touchSelect(_selected)
        
        }
        
        
        
    }
    
    
    
//   触摸动作的相关过程动画
    private func touchAnimation(touches:Set<UITouch>){
        let  touch:UITouch? = touches.first
        if (touch == nil){
            return
        }
        let clickPoint:CGPoint  = touch!.locationInView(self)
        
        let clickLayer:CALayer=CALayer()
        clickLayer.backgroundColor = UIColor.whiteColor().CGColor
        clickLayer.masksToBounds = true;
        clickLayer.cornerRadius = 3;
        clickLayer.frame = CGRectMake(0, 0, 6, 6);
        clickLayer.position = clickPoint;
        clickLayer.opacity = 0.3;
        clickLayer.name = "clickLayer";
        self.layer.addSublayer(clickLayer)
        
        let zoom:CABasicAnimation=CABasicAnimation(keyPath: "transform.scale")
        zoom.toValue = 38.0;
        zoom.duration = 0.4;
        let fadeout:CABasicAnimation=CABasicAnimation(keyPath: "opacity")
        fadeout.toValue = 0.0;
        fadeout.duration = 0.4;
        let group:CAAnimationGroup=CAAnimationGroup()
        group.duration = 0.4;
        group.animations=[zoom,fadeout]
        group.delegate = self;
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = false;
        clickLayer.addAnimation(group, forKey: "animationKey")
    }
    

    

    /**
    删除动画层
    
    - parameter anim: 动画
    - parameter flag: 成功
    */
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        if flag{
            for (var i:Int = 0; i < self.layer.sublayers?.count; i++) {
                let obj:CALayer=self.layer.sublayers![i]
                if (obj.name != nil && "clickLayer"==obj.name && obj.animationForKey("animationKey") == anim){
                    obj.removeFromSuperlayer()
                }
            
            }
        }
    }
    
    
    

    

}
