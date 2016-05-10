//
//  ViewController.swift
//  Jump-The-Line
//
//  Created by Ivan Yanakiev on 1/23/16.
//  Copyright © 2016 Kriviq. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var venuesTableView: UITableView!
    @IBOutlet var chooseCityButton: UIButton!
    @IBOutlet var tableViewGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet var cityPicker: UIPickerView!
    @IBOutlet var pickerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var pickerOffsetConstraint: NSLayoutConstraint!
    var isPickerShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let cityProvider = JTLCityProvider.sharedInstance
        
        if let city = cityProvider.currentCity() {
            self.chooseCityButton.setTitle(city, forState: .Normal)
        }
        
        self.adjustPickerView();
    }
    
    func adjustPickerView() {
        self.pickerHeightConstraint.constant = CGFloat(self.pickerView(self.cityPicker, numberOfRowsInComponent: 0)) * 40.0 + 10.0;
        self.pickerOffsetConstraint.constant = -self.pickerHeightConstraint.constant;
    }
    
    func showPicker() {
        self.view.bringSubviewToFront(self.cityPicker)
        self.pickerOffsetConstraint.constant = 0.0;
        UIView.animateWithDuration(0.5, animations: {
            self.cityPicker.alpha = 1;
            self.view.layoutSubviews();
            self.isPickerShown = true
        })
    }
    
    @IBAction func hidePicker() {
        self.pickerOffsetConstraint.constant = -self.pickerHeightConstraint.constant;
        UIView.animateWithDuration(0.5, animations: {
            self.cityPicker.alpha = 0;
            self.view.layoutSubviews();
            self.isPickerShown = false
        })
    }
    
    @IBAction func chooseButtonTapped(sender: AnyObject) {
        if self.isPickerShown {
            self.hidePicker()
        }
        else {
            self.showPicker()
        }
    }

    ///PICKER DELEGATE STUFF
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return JTLCityProvider.sharedInstance.cities().count;
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return JTLCityProvider.sharedInstance.cities()[row] as! String;
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let city = JTLCityProvider.sharedInstance.cities()[row] as! String
        self.chooseCityButton.setTitle(city, forState: .Normal)
        
        JTLVenueProvider.sharedInstance.venueForCityAndName("Paris", category:"sights" ,venueName: "Musée du Louvre") { (places) -> Void in
            NSLog("places returned from venue finder %@", places)
        }
        
//        JTLVenueProvider.sharedInstance.venuesForCity(city) { (places) -> Void in
//            NSLog("places returned from venue finder %@", places)
//        }
    }
    
    ///TABLE VIEW
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell();
    }
    
    
}

