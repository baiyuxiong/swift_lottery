//
//  AppDelegate.swift
//  Hello
//
//  Created by 白玉雄 on 14/10/21.
//  Copyright (c) 2014年 baiyuxiong. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var isStarted = false
    
    private var userList: [String] = []
    
    private var winPreferences:Preferences! = nil

    @IBOutlet weak var window: NSWindow!
    
    @IBOutlet weak var imgBackground: NSImageView!
    
    @IBOutlet weak var mStartOrStop: NSMenuItem!
    
    @IBOutlet weak var lbCurrentUser: NSTextField!
    
    @IBAction func btnPreferences(sender: AnyObject) {
        println("show Preferences window")
        
        if(winPreferences == nil)
        {
            winPreferences = Preferences(windowNibName: "Preferences")
            winPreferences.setOwner(self)
        }
        winPreferences.showWindow(self);
    }
    
    @IBAction func mImportData(sender: AnyObject) {
        var myFiledialog: NSOpenPanel = NSOpenPanel()
        myFiledialog.worksWhenModal = true
        myFiledialog.allowsMultipleSelection = false
        myFiledialog.canChooseDirectories = false
        myFiledialog.resolvesAliases = true
        myFiledialog.title = "请选择抽奖数据文件"
        myFiledialog.message = "文本格式，一行一个，如一行一条手机号的txt文件"
        myFiledialog.runModal()
        var chosenfile = myFiledialog.URL
        if (chosenfile != nil)
        {
            var err: NSError? = NSError()
            var s = String(contentsOfURL: chosenfile!, encoding: NSUTF8StringEncoding, error: &err)
            
            if(s != nil)
            {
                self.userList = s!.componentsSeparatedByString("\n")
            }
        }
    }
    @IBAction func btnSetBackground(sender: AnyObject) {
        var myFiledialog: NSOpenPanel = NSOpenPanel()
        myFiledialog.worksWhenModal = true
        myFiledialog.allowsMultipleSelection = false
        myFiledialog.canChooseDirectories = false
        myFiledialog.resolvesAliases = true
        myFiledialog.title = "请选择背景图片"
        myFiledialog.message = "Jpg、gif、png格式"
        myFiledialog.runModal()
        var chosenfile = myFiledialog.URL
        if (chosenfile != nil)
        {
            imgBackground.image = NSImage(contentsOfURL:chosenfile!)
        }
    }
    
    @IBAction func btnStartOrStop(sender: AnyObject) {
        if isStarted
        {
            isStarted = false
            mStartOrStop.title = "开始"
        }
        else
        {
            var count = userList.count
            if(count < 3)
            {
                var alert = NSAlert()
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
                        var random = Int(arc4random_uniform(UInt32(count)))
                        dispatch_sync(dispatch_get_main_queue(), {
                            //dispatch_async里面的函数调与外层不具有严格的顺序关系，可能random产生结束了，修改界面UI才刚开始
                            //dispatch_sync是同步的
                            self.lbCurrentUser.stringValue = self.userList[random]
                        })
                        usleep(50000)
                    }
                    usleep(100000)
                    for (index,value) in enumerate(self.userList)
                    {
                        if(value == self.lbCurrentUser.stringValue)
                        {
                            self.userList.removeAtIndex(index)
                            println("remove at index : ")
                            println(index)
                        }
                    }
                })
            }
        }
    }
    
    
    //Preferences
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
    }

    func applicationWillTerminate(aNotification: NSNotification) {
    }


}

