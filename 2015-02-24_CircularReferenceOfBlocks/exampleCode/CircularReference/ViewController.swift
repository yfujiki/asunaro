//
//  ViewController.swift
//  CircularReference
//
//  Created by Yuichi Fujiki on 2/16/15.
//  Copyright (c) 2015 YFUJIKI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var simpleRunButton: UIButton!
    @IBOutlet weak var dispatchAsyncButton: UIButton!
    @IBOutlet weak var localObjectLeakButton: UIButton!
    @IBOutlet weak var typicalLeakButton: UIButton!
    @IBOutlet weak var instanceVarLeakButton: UIButton!
    @IBOutlet weak var classLeakButton: UIButton!
    @IBOutlet weak var singletonLeakButton: UIButton!

    @IBOutlet weak var leakSwitch: UISwitch!
    @IBOutlet weak var typicalLeakSwitch: UISwitch!
    @IBOutlet weak var dispatchLeakSwitch: UISwitch!
    @IBOutlet weak var instanceVarLeakSwitch: UISwitch!
    @IBOutlet weak var localLeakSwitch: UISwitch!
    @IBOutlet weak var classLeakSwitch: UISwitch!
    @IBOutlet weak var singletonLeakSwitch: UISwitch!

    var mutableBufferArray:[LeakObject]?

    override func viewDidLoad() {
        super.viewDidLoad()

        mutableBufferArray = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func simpleRun(sender: AnyObject) {
        let object = LeakObject()

        mutableBufferArray!.append(object)

        if (!leakSwitch.on) {
            mutableBufferArray!.removeLast()
        }
    }

    @IBAction func typicalLeakRun(sender: AnyObject) {
        let object = LeakObject()

        object.runTypicalLeak(typicalLeakSwitch.on)
    }

    @IBAction func dispatchAsyncRun(sender: AnyObject) {
        let object = LeakObject()
        object.runDispatchBlock(leak: dispatchLeakSwitch.on)
    }

    @IBAction func instanceLeakRun(sender: AnyObject) {
        let object = LeakObject()
        object.runInstanceVariableLeak(instanceVarLeakSwitch.on)
    }

    @IBAction func localLeakRun(sender: AnyObject) {
        let object = LeakObject()
        object.runLocalVariableLeak(localLeakSwitch.on)
    }

    @IBAction func classLeakRun(sender: AnyObject) {
        let object = LeakObject()
        object.runClassLeak(classLeakSwitch.on)
    }

    @IBAction func singletonLeakRun(sender: AnyObject) {
        let object = LeakObject()
        object.runSingletonLeak(singletonLeakSwitch.on)
    }
}

