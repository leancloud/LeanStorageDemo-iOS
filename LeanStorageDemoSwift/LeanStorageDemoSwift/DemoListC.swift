//
//  DemoListC.swift
//  LeanStorageDemoSwift
//
//  Created by lzw on 15/9/1.
//  Copyright (c) 2015年 微信:  lzwjava. All rights reserved.
//

import UIKit

class DemoListC: UITableViewController {
    var contents : Array<AnyObject> = []
    var demo : Demo?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if demo != nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "查看源码", style: UIBarButtonItemStyle.Plain, target: self, action: "showSource")
        }
    }
    
    func showSource() {
        var sourceC = SourceC()
        sourceC.filePath = demo?.sourcePath()
        navigationController?.pushViewController(sourceC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return contents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            cell?.detailTextLabel?.textColor = UIColor.grayColor()
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        }
        var info : NSDictionary = contents[indexPath.row] as! NSDictionary
        cell!.textLabel?.text = info["name"] as? String
        cell!.detailTextLabel?.text = info["detail"] as? String
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var info : NSDictionary = contents[indexPath.row] as! NSDictionary
        var method :String? = info["method"] as? String
        var vc : UIViewController?
        
        if (method != nil) {
            var rc = DemoRunC()
            rc.demo = demo
            rc.demo?.demoRunC = rc
            rc.methodName = method!
            vc = rc
        } else {
            var className:String = info["class"] as! String
            var clsName = "LeanStorageDemoSwift." + className
            var demo : Demo = NSClassFromString(clsName).new() as! Demo
            
            var listC = DemoListC()
            var contents = [[String:String]]()
            for method in demo.allDemoMethods(demo.self) {
                if method.hasPrefix("demo") {
                    var content = [String:String]()
                    content["method"] = method
                    content["name"] = method.substringFromIndex(advance(method.startIndex, 4))
                    contents.append(content)
                }
            }
            listC.demo = demo
            listC.contents = contents
            vc = listC
        }
        if vc != nil {
            vc?.title = info["name"] as? String
            navigationController?.pushViewController(vc!, animated: true)
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
