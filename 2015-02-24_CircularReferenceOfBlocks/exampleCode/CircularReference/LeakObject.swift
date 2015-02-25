//
//  LeakObject.swift
//  CircularReference
//
//  Created by Yuichi Fujiki on 2/16/15.
//  Copyright (c) 2015 YFUJIKI. All rights reserved.
//

import UIKit

func myPrintln<String>(object: String) {
    NSLog("%@", object as NSString)
}

var classLeakBlock: (() -> Void)?

class LeakObject: NSObject {
    var childLeakObject: LeakObject?
    var leakBlock: (() -> Void)?
    let dispatch_queue = dispatch_queue_create("com.yfujiki.circularreference.LeakObject", nil)

    override init () {
        NSLog("Initialized Leak Object")
        super.init()
    }

    deinit {
        NSLog("Deinitializing Leak Object")
    }

    func runTypicalLeak(leak: Bool) {
        if leak {
            runLeak() { () -> Void in
                myPrintln("Running typical leak for \(self) with leak")
            }
        } else {
            runLeak() { [weak self] () -> Void in
                myPrintln("Running typical leak for \(self) without leak")
            }
        }
    }

    func runDispatchBlock(leak: Bool = true) {
        if leak {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
                myPrintln("Running dispatch async for \(self) with leak")
            })
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { [weak self] in
                myPrintln("Running dispatch async for \(self) without leak")
            })
        }
    }

    func runInstanceVariableLeak(leak: Bool) {
        childLeakObject = LeakObject()
        if leak {
            childLeakObject!.runLeak() { () -> Void in
                myPrintln("Running instance variable leak for \(self) with leak")
            }
        } else {
            childLeakObject!.runLeak() { [weak self] () -> Void in
                myPrintln("Running instance variable leak for \(self) without leak")
            }
        }
    }

    func runLocalVariableLeak(leak: Bool) {
        let object = LeakObject()
        if leak {
            object.runLeak() { () -> Void in
                myPrintln("Running local leak block for \(self) with leak")
            }
        } else {
            object.runLeak() { [weak self] () -> Void in
                myPrintln("Running local leak block for \(self) without leak")
            }
        }
    }

    func runClassLeak(leak: Bool) {
        if leak {
            LeakObject.runClassLeak() { () -> Void in
                myPrintln("Running class leak block for \(self) with leak")
            }
        } else {
            LeakObject.runClassLeak() { [weak self] () -> Void in
                myPrintln("Running class leak block for \(self) without leak")
            }
        }
    }

    func runSingletonLeak(leak: Bool) {
        var observer: NSObjectProtocol?
        if leak {
            observer = NSNotificationCenter.defaultCenter().addObserverForName("Dummy", object: self, queue: nil, usingBlock: { (notification: NSNotification!) -> Void in
                myPrintln("Running singleton leak block for \(self) with leak")
            })
        } else {
            observer = NSNotificationCenter.defaultCenter().addObserverForName("Dummy", object: self, queue: nil, usingBlock: { [weak self](notification: NSNotification!) -> Void in
                myPrintln("Running singleton leak block for \(self) without leak")
            })
        }

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            NSNotificationCenter.defaultCenter().postNotificationName("Dummy", object: self)
              NSNotificationCenter.defaultCenter().removeObserver(observer!, name: "Dummy", object: nil)
        })
    }
    
    func runLeak(block: () -> Void) {
        leakBlock = block

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            self.leakBlock!()
//            self.leakBlock = nil
        })
    }

    class func runClassLeak(block: () -> Void) {
        classLeakBlock = block

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
            classLeakBlock!()
        })
    }
}
