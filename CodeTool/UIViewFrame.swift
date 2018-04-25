//
//  UIViewFrame.swift
//  TextProject
//
//  Created by 小黎 on 2017/11/7.
//  Copyright © 2017年 小黎. All rights reserved.
//

/**
UIView 的类别（分类）
 */
import Foundation
import UIKit
extension UIView {
    /** 视图X轴起点*/
    public var X: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    /** 视图Y轴起点*/
    public var Y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    /** 视图X轴最大值*/
    public var MaxX: CGFloat{
        get{
            return self.frame.maxX
        }
        set{
            var r = self.frame
            r.origin.x = newValue-r.size.width
            self.frame = r
        }
    }
    /** 视图Y轴最大值*/
    public var MaxY: CGFloat{
        get{
            return self.frame.maxY
        }
        set{
            var r = self.frame
            r.origin.y = newValue-r.size.height
            self.frame = r
        }
    }
    /** 视图中心点X值（相对于其父视图）*/
    public var centerX: CGFloat{
        get{
            return self.center.x
        }
        set{
            let r = CGPoint(x: newValue, y: self.center.y)
            self.center = r
        }
    }
    /** 视图中心点Y值（相对于其父视图）*/
    public var centerY: CGFloat{
        get{
            return self.center.y
        }
        set{
            let r = CGPoint(x: self.center.x, y: newValue)
            self.center = r
        }
    }
    /** 视图宽度*/
    public var Width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    /** 视图高度*/
    public var Height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
     /** 视图size*/
    public var Size: CGSize{
        get{
            return self.frame.size
        }
        set{
            //var c = self.center
            var r = self.frame
            r.size = newValue
            self.frame = r
        }
    }
    
    /**  找到view 所在控制器*/
    public func getviewController(_ view:UIView)-> UIViewController? {
        var next = view.superview
        var tempIndex = true
        while tempIndex == true {
            let nextResponder = next?.next
            if (nextResponder?.isKind(of: UIViewController.self))!{
                tempIndex = false
                return (nextResponder as! UIViewController)
            }else {
                next = (nextResponder as! UIView)
                tempIndex = true
            }
        }
        return nil
    }
}
