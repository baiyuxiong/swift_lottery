//
//  AppDelegate.swift
//  Hello
//
//  Created by 白玉雄 on 14/10/21.
//  Copyright (c) 2014年 baiyuxiong. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, SettingControllerDelegate {
    
    private var isStarted = false
    
    private var userList: [String] = []
    
    private var settingController : SettingController?

    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var imgBackground: NSImageView!
    
    @IBOutlet weak var mStartOrStop: NSMenuItem!
    
    @IBOutlet weak var lbCurrentUser: NSTextField!
    
    @IBAction func menuFontSet(sender: NSMenuItem) {
        if nil == self.settingController{
            let sc = SettingController()
            sc.delegate = self
            sc.showWindow(self)
            self.settingController = sc
        }
        else{
            self.settingController?.showWindow(self)
        }
    }
    
    @IBAction func mImportData(sender: AnyObject) {
        let myFiledialog: NSOpenPanel = NSOpenPanel()
        myFiledialog.worksWhenModal = true
        myFiledialog.allowsMultipleSelection = false
        myFiledialog.canChooseDirectories = false
        myFiledialog.resolvesAliases = true
        myFiledialog.title = "请选择抽奖数据文件"
        myFiledialog.message = "文本格式，一行一个，如一行一条手机号的txt文件"
        myFiledialog.runModal()
        let chosenfile = myFiledialog.URL
        if (chosenfile != nil)
        {
            var err: NSError? = NSError(domain: "com.baiyuxiong", code: 1, userInfo: nil)
            var s: String?
            do {
                s = try String(contentsOfURL: chosenfile!, encoding: NSUTF8StringEncoding)
            } catch let error as NSError {
                err = error
                s = nil
            }
            
            if(s != nil)
            {
                self.userList = s!.componentsSeparatedByString("\n")
            }
        }
    }
    
    @IBAction func btnSetBackground(sender: AnyObject) {
        let myFiledialog: NSOpenPanel = NSOpenPanel()
        myFiledialog.worksWhenModal = true
        myFiledialog.allowsMultipleSelection = false
        myFiledialog.canChooseDirectories = false
        myFiledialog.resolvesAliases = true
        myFiledialog.title = "请选择背景图片"
        myFiledialog.message = "Jpg、gif、png格式"
        myFiledialog.runModal()
        let chosenfile = myFiledialog.URL
        if (chosenfile != nil)
        {
            var importedImage = NSImage(contentsOfURL:chosenfile!)
            let screenSize = NSScreen.mainScreen()?.frame
            
            NSLog("screenSize.width %f, height %f" , screenSize!.size.width,screenSize!.size.height)
            if screenSize!.size.width < importedImage?.size.width || screenSize!.size.height < importedImage?.size.height{
                importedImage = resizeImage(importedImage!,w:screenSize!.size.width,h:screenSize!.size.height)
            }
            imgBackground.image = importedImage
        }
    }
    
    func resizeImage(image: NSImage, w: CGFloat, h: CGFloat) -> NSImage {
        let destSize = NSMakeSize(w, h)
        image.size = destSize
        return image
    }
    
    @IBAction func btnStartOrStop(sender: AnyObject) {
        if isStarted
        {
            isStarted = false
            mStartOrStop.title = "开始"
        }
        else
        {
            let count = userList.count
            if(count < 3)
            {
                let alert = NSAlert()
                alert.informativeText = "用户数据太少，如未导入用户数据，请先通过[数据]菜单导入"
                alert.messageText = "提示"
                alert.runModal()
            }
            else
            {
                isStarted = true
                mStartOrStop.title = "结束"
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    while(self.isStarted)
                    {
                        let random = Int(arc4random_uniform(UInt32(count)))
                        dispatch_sync(dispatch_get_main_queue(), {
                            //dispatch_async里面的函数调与外层不具有严格的顺序关系，可能random产生结束了，修改界面UI才刚开始
                            //dispatch_sync是同步的
                            self.lbCurrentUser.stringValue = self.userList[random]
                        })
                        usleep(50000)
                    }
                    usleep(100000)
                    for (index,value) in self.userList.enumerate()
                    {
                        if(value == self.lbCurrentUser.stringValue)
                        {
                            self.userList.removeAtIndex(index)
                            print("remove at index : ")
                            print(index)
                        }
                    }
                })
            }
        }
    }
    
    
    //Preferences
    func settingControllerDidUpdate(controller:SettingController)
    {
        print("settingControllerDidUpdate")
        lbCurrentUser.textColor = controller.textColorWell.color
        
        let fontSize = NSString(string: controller.fontSizeField.stringValue)
        lbCurrentUser.font = NSFont(name: "Menlo", size: CGFloat(fontSize.doubleValue))
        
        //horizontal position
        if controller.horizontalCenterBtn.state == NSOnState{
            lbCurrentUser.alignment = NSTextAlignment.Center
        }else if controller.horizontalLeftBtn.state == NSOnState{
            lbCurrentUser.alignment = NSTextAlignment.Left
        }else{
            lbCurrentUser.alignment = NSTextAlignment.Right
        }
        
        //vertical position
        
        /***
        !!!!!!!!!! TODO this not works now !!!!!!!!!!
        */
        if controller.verticalCenterBtn.state == NSOnState{
            let verticalConstraint = NSLayoutConstraint(
                item: lbCurrentUser,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.window.contentView,
                attribute: NSLayoutAttribute.CenterY,
                multiplier: 1,
                constant: 0)
            NSLayoutConstraint.activateConstraints([verticalConstraint])
        }else{
            let verticalConstraint = NSLayoutConstraint(
                item: lbCurrentUser,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.GreaterThanOrEqual,
                toItem: lbCurrentUser.superview,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1,
                constant: stringToFloat(controller.verticalTopSizeField.stringValue))
            NSLayoutConstraint.activateConstraints([verticalConstraint])
        }
        
    }
    
    func stringToFloat(str : String) -> CGFloat{
        return CGFloat((str as NSString).floatValue);
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
    }
    
    @IBAction func labelDraged(sender: AnyObject) {
        NSLog("hello")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true;
    }

}

