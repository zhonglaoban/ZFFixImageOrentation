# iOS中关于图片方向的处理
## 问题
在使用`即刻`app的时候，发现在iOS14上，点击图片查看大图的时候会出现图片显示方向不正确的情况。刚好之前做过这块，现在来分析一下出现这种情况的可能原因以及解决方案。这个问题在上传图片或者直接webview展示的时候会出现。

## 分析
不同的拍照设备（iOS或者Android相机），拍照的时候是有一个设备方向的，和相机的厂商有关。当我们按下快门的时候，图片会自带一个方向信息。当然，在我们iOS系统框架内显示或者预览的时候是没有问题的，系统已经帮我们处理好了。但是当我们把照片传到网上时，就会导致一些图片方向与预期不符的情况，这时候我们就需要利用图片里的方向信息来进行旋转了。

## 解决步骤
1、读取图片方向`imageOrientation`。
2、开启图片上下文`UIGraphicsBeginImageContext`，获取图片的数据`UIGraphicsGetCurrentContext`。
3、设置旋转的锚点`bitmap?.translateBy`，旋转数据`bitmap?.rotate`，再按比例缩放`bitmap?.scaleBy`至原始大小。

## 代码实现
获取旋转角度，参考[官方文档](https://developer.apple.com/documentation/uikit/uiimage/orientation)。
```swift
var degree:RotateDegree = .angle_0
let orientation = imageOrientation
switch orientation {
    case .down:
        degree = .angle_180
    case .left:
        degree = .angle_270
    case .right:
        degree = .angle_90
    default:
        break
}
```
给图片添加旋转分类。
```swift
func rotate(to degree: RotateDegree) -> UIImage {
    var rotatedSize = size
    var angle:CGFloat = 0
    switch degree {
    case .angle_0:
        rotatedSize = size
    case .angle_90:
        angle = CGFloat.pi * 0.5
        rotatedSize = CGSize(width: size.height, height: size.width)
    case .angle_180:
        angle = CGFloat.pi
        rotatedSize = size
    case .angle_270:
        angle = -CGFloat.pi * 0.5
        rotatedSize = CGSize(width: size.height, height: size.width)
    }
    
    UIGraphicsBeginImageContext(rotatedSize)
    
    let bitmap = UIGraphicsGetCurrentContext()
    bitmap?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
    bitmap?.rotate(by: angle)
    var scaleX:CGFloat = 1
    var scaleY:CGFloat = 1
    if rotatedSize.width > 0 {
        scaleX = size.width / rotatedSize.width
    }
    if rotatedSize.height > 0 {
        scaleY = size.height / rotatedSize.height
    }
    bitmap?.scaleBy(x: scaleX, y: -scaleY)
    
    let origin = CGPoint(x: -rotatedSize.width / 2, y: -rotatedSize.height / 2)
    bitmap?.draw(cgImage!, in: CGRect(origin: origin, size: rotatedSize))
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
}
```


