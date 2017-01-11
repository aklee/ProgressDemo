//
//  ViewController.swift
//  SwiftD
//
//  Created by ak on 2017/1/7.
//  Copyright © 2017年 ak. All rights reserved.
//

import UIKit
//class viewcontroller has no initializer
class ViewController: UIViewController {
    
    var progress : Progress = Progress.init(totalUnitCount: 10)
    
    var childP1 : Progress?
    
    var childArr :[Progress] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        progress.addObserver(self, forKeyPath: "fractionCompleted", options: NSKeyValueObservingOptions.new, context: nil);
       
        //添加方式1
        //self.testAddChild()
        
        
        //添加方式2
        self.testAddMutiChild()
 
        print(progress);
        
        let t1:Timer = Timer.init(timeInterval: 1, target: self, selector: #selector(addProgress(timer:)), userInfo:childArr, repeats: true)
        
        
        RunLoop.current.add(t1, forMode: RunLoopMode.commonModes)
    }
    
    /*添加子节点addChild*/
    func testAddChild() {
        
    
        //添加子节点1
        let child1 : Progress = Progress.init(totalUnitCount: 10);
        
        childP1=child1;
        
        progress.addChild(child1, withPendingUnitCount: 5);
        
        
        //添加子节点2
        let child2 :Progress = Progress.init(totalUnitCount: 20);
        
        progress.addChild(child2, withPendingUnitCount: 5);
        
        childArr = [child1,child2]
    }
    
    
    func testAddMutiChild() {
        //可以同时添加多个子节点
        let child1 : Progress = Progress.init(totalUnitCount: 10, parent: progress, pendingUnitCount: 5)
        
        childP1=child1;
        
        let child2 : Progress = Progress.init(totalUnitCount: 20, parent: progress, pendingUnitCount: 5)
        
        childArr = [child1,child2]
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        

        let value:CGFloat = change?[NSKeyValueChangeKey.newKey] as! CGFloat;
        print("总进度：fractionCompleted:\(value)")
//        print("总进度：fractionCompleted:\(value) localizedDescription:"+progress.localizedDescription+" localizedAdditionalDescription:"+progress.localizedAdditionalDescription);
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("暂停child1 4 sec ")
        //暂停child1
        childP1?.pause()
        
        weak var ws:ViewController? = self;
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+4, execute: {
            
            
            print("恢复child1")
            ws?.childP1?.resume()
        });
        
    }
    
    
    func addProgress(timer:Timer){
        
        let p1 : Progress = childArr[0]
        
        var p2 : Progress? = nil
        
        if childArr.count>1 {
            p2 = childArr[1]
        }
        
        if p1.completedUnitCount>=p1.totalUnitCount
            && p2 != Optional.none
            && (p2?.completedUnitCount)!>=(p2?.totalUnitCount)!
        {
            timer.invalidate()
            return;
        }
        
        if p1.completedUnitCount<p1.totalUnitCount
            && !p1.isPaused
        {
            
            p1.completedUnitCount+=1;
            
            print("child1:\(p1.completedUnitCount)/\(p1.totalUnitCount) progress:\(progress.localizedAdditionalDescription)")
            
        }
        
        if p2 != Optional.none &&
            (p2?.completedUnitCount)! < (p2?.totalUnitCount)!
            && (p2?.isPaused)==false
        {
            p2?.completedUnitCount+=1;
            
            print("child2:\(p2?.completedUnitCount)/\(p2?.totalUnitCount) progress:\(progress.localizedAdditionalDescription)")
        }
        
        
        
    }
 

}

