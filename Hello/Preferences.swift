//
//  Preferences.swift
//  Hello
//
//  Created by 白玉雄 on 14/10/24.
//  Copyright (c) 2014年 baiyuxiong. All rights reserved.
//

import Cocoa

class Preferences : NSWindowController{

    var ownerWindow:AppDelegate!
    
    @IBOutlet weak var txtFontSize: NSTextField!
    
    func setOwner(ownerWindow:AppDelegate)
    {
        self.ownerWindow = ownerWindow
    }
    
    func controlTextDidChange(center: NSTextField!, shouldPresentNotification notification: NSUserNotification!) -> Bool {
        println("text changed")
        return true
    }
    
    @IBAction func fontColorChanged(sender: AnyObject) {
        
        println("font Color changed")
        ownerWindow.lbCurrentUser.textColor = sender.color
    }
    @IBAction func txtFontSizeChanged(sender: AnyObject) {
        println("font size changed")
        var fontSize = NSString(string: sender.stringValue)
        ownerWindow.lbCurrentUser.font = NSFont(name: "Menlo", size: CGFloat(fontSize.doubleValue))
    }
    
    override init()
    {
        super.init()
        println(" super.init()")
    }
    
    override init(window: NSWindow!)
    {
        println("super.init(window: NSWindow!)")
        super.init(window: window)
    }
    
    required init?(coder: NSCoder)
    {
        println("super.init(coder: NSCoder)")
        super.init(coder: coder)
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
}