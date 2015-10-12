//
//  SettingController.swift
//  Hello
//
//  Created by 白玉雄 on 15/10/11.
//  Copyright © 2015年 baiyuxiong. All rights reserved.
//

import Cocoa

protocol SettingControllerDelegate {
    func settingControllerDidUpdate(controller:SettingController)
}

class SettingController: NSWindowController ,NSTextFieldDelegate {
    
    var delegate:SettingControllerDelegate?

    @IBOutlet weak var textColorWell: NSColorWell!
    
    @IBOutlet weak var fontSizeField: NSTextField!
    
    @IBOutlet weak var horizontalCenterBtn: NSButton!
    
    @IBOutlet weak var horizontalRightBtn: NSButton!
    
    @IBOutlet weak var horizontalLeftBtn: NSButton!
    
    @IBOutlet weak var verticalCenterBtn: NSButton!
    
    @IBOutlet weak var verticalCustomBtn: NSButton!
    
    @IBOutlet weak var verticalTopSizeField: NSTextField!
    
    
    override func windowDidLoad() {
        fontSizeField.delegate = self
        verticalTopSizeField.delegate = self
        super.windowDidLoad()
    }
    
    override var windowNibName:String?  {
        return "SettingController"
    }
    
    @IBAction func textColorWellAction(sender: NSColorWell) {
        self.delegate?.settingControllerDidUpdate(self)
    }
    
    @IBAction func horizontalCenterBtnAction(sender: NSButton) {
        horizontalRightBtn.state = NSOffState
        horizontalLeftBtn.state = NSOffState
        
        self.delegate?.settingControllerDidUpdate(self)
    }
    @IBAction func horizontalLeftBtnAction(sender: NSButton) {
        horizontalCenterBtn.state = NSOffState
        horizontalRightBtn.state = NSOffState
        self.delegate?.settingControllerDidUpdate(self)
    }
    @IBAction func horizontalRightBtnAction(sender: NSButton) {
        horizontalLeftBtn.state = NSOffState
        horizontalCenterBtn.state = NSOffState
        self.delegate?.settingControllerDidUpdate(self)
    }
    
    
    @IBAction func verticalCenterBtnAction(sender: NSButton) {
        if sender.state == NSOnState {
            verticalCustomBtn.state = NSOffState
        }else{
            verticalCustomBtn.state = NSOnState
        }
        self.delegate?.settingControllerDidUpdate(self)
    }
    
    @IBAction func verticalCustomBtnAction(sender: NSButton) {
        if sender.state == NSOnState {
            verticalCenterBtn.state = NSOffState
        }else{
            verticalCenterBtn.state = NSOnState
        }
        self.delegate?.settingControllerDidUpdate(self)
    }
    
    override func controlTextDidChange(obj: NSNotification) {
        self.delegate?.settingControllerDidUpdate(self)
    }
}
