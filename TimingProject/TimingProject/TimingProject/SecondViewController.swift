//
//  SecondViewController.swift
//  TimingProject
//
//  Created by Alexis Saint-Jean on 1/30/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBAction func numbersPicked(sender: AnyObject) {
//        self.pickerView(pickerView: UIPickerView, didSelectRow: Int, inComponent: Int)
    }
    @IBOutlet weak var picker: UIPickerView!
    
    var goalTimeData = [ ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24"],["hours"],["05","10","15","20","30","40","45","50","55"],["min"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.picker.dataSource = self
        self.picker.delegate = self
        println("\(goalTimeData[0][0])")
        println("\(goalTimeData[1][0])")

   
    }
    
    // The following function is required as part of the
    // UIPickerViewDataSource. It indicates how many
    // 'components' (i.e. columns) are in the UIPickerView
    func numberOfComponentsInPickerView(pickerView: UIPickerView)->Int {
        
        return 4
    }
    
    // The following function is also required as part of the
    // UIPickerViewDataSource. It indicates how many
    // rows of data are in the UIPickerView
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return goalTimeData[component].count

    }
    
    // this method returns a plain NSString to display the row for each component.
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return goalTimeData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 45
    }
    
    // Catpure the picker view selection   
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("the value from component \(self.goalTimeData[component].count) is \(self.goalTimeData[component][row])")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Number of columns in the number picker

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
