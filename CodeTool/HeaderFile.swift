//
//  HeaderFile.swift
//  ZHSRTM
//
//  Created by 小黎 on 2017/11/8.
//  Copyright © 2017年 小黎. All rights reserved.
//
import UIKit

/** 尺寸*/
let KWidth  = UIScreen.main.bounds.size.width  // 屏幕的宽
let KHeight = UIScreen.main.bounds.size.height // 屏幕的高
/**适配*/
func W(_ width:CGFloat) -> CGFloat { // 相对宽度（设计图）
    let  r = KWidth*1.0/750
    return width*r
}
func H(_ height:CGFloat) -> CGFloat { // 相对高度（设计图）
    let  r = KHeight*1.0/1334
    return height*r
    
}
func R(_ r:CGFloat) -> CGFloat { // 相对字体（设计图）
    return H(r)
}

func SFont(_ r:CGFloat) -> UIFont { // 相对字体大小（设计图）
    
    return UIFont.systemFont(ofSize: W(r))
}
func BFont(_ r:CGFloat) -> UIFont { // 相对字体大小加粗（设计图）
    
    return UIFont.boldSystemFont(ofSize: W(r))
}

