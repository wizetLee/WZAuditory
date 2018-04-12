//
//  ChainController.swift
//  WZAuditory
//
//  Created by 李炜钊 on 2018/4/6.
//  Copyright © 2018年 wizet. All rights reserved.
//

import Foundation
import CoreImage
import UIKit

extension Int {
    func add(_ x : Int) -> Int {
        return self + x
    }
}

protocol customP {
    
}

extension Array where Element : customP {
    
}

class ChainController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        var value : Int = 0
        value.add(10).add(20).add(30)
        print(value)
        value  = self.add(x: 10)(10)
        print(value)
     
        var a : Int? = nil;
      
        if let aa : Int = a, aa > 10{
            print("over")
        } else {
            print("less")
        }
        
        switch a {
        case let tmp as Int where tmp > 1: //等于 is Int   外加where判断
            print("这是个Int 类型")
            
        case (0..<100)?:
            print("s0")
            
            
        default:
            print("s1")
        }
        
       Character(UnicodeScalar(23));
        let x : Int? = 3
        let y : Int? = nil
        if let tmpX = x , let tmpY = y {
            let z : Int? = tmpX + tmpY
        }
        
        "\(123)"//强转
        var vaalu =  "123"//
        Int(vaalu)
        
        
    }
    
    typealias Filter = ((CIImage) -> CIImage)
    
    //filter__blur
    func blur(radius : Double) -> Filter? {
        return { ciimage in
            //参数：
            let parameter : [String : Any]  = [
                kCIInputRadiusKey : radius,
                kCIOutputImageKey : ciimage,
                ]
            
//            guard let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameter) else {
//                //出错
//                return
//            }
            
//            guard let outputImage = filter.outputImage else {
//                return poll
//            }

            let filter = CIFilter(name: "CIGaussianBlur", withInputParameters: parameter)
            let outputImage = filter?.outputImage
            
            return outputImage!
        }
    }
    
    func colorGenerator(color : UIColor) -> Filter {
        return { _ in
            
//            guard let c = CIColor(color: color) else {
//                throw "chucuo"
//            }
//

//            guard let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)
//                else {
//                throw ""
//            }
//
//            guard let outputImahe = filter.outputImage else {
//                throw ""
//            }
            let c = CIColor(color: color)
            let parameters = [kCIInputColorKey : c]
            let filter = CIFilter(name: "CIConstantColorGenerator", withInputParameters: parameters)!
            let outputImahe = filter.outputImage!
            
            return outputImahe
        }
    }
    
    
    func add(x : Int) -> ((Int) -> Int) {
        return { y in (x+y) }
    }
    
}
