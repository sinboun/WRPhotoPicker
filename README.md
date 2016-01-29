# PhotoPicker

I am a beginner, I hope my code can give more inspiration for beginners. If you find that the code has bug, or want to communicate with me, please contact: 1505482941@qq.com

![image](https://raw.githubusercontent.com/TiltCitySong/WRPhotoPicker/master/WRPhotoPicker/img/p2.gif)   

![image](https://raw.githubusercontent.com/TiltCitySong/WRPhotoPicker/master/WRPhotoPicker/img/p1.gif)   

Step 1:
```swift  

    let vc:WRPhotoViewController=WRPhotoViewController()
    vc.assetsFilter = ALAssetsFilter.allPhotos()
        vc.delegate=self
        vc.showEmptyGroups = true;
        vc.maximumNumberOfSelection=6
        vc.selectionFilter=NSPredicate(block: { (evaluatedObject, bindings) -> Bool in
            return true;
     })
	self.presentViewController(vc, animated: true, completion: nil)
    
       
```
Step 1: Delegate

```swift  

     //相机被点击操作
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

    
       
```
   
