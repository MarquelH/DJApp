//
//  scheduleViewController.swift
//  DJ APP
//
//  Created by Marquel Hendricks on 12/28/17.
//  Copyright © 2017 Marquel and Micajuine App Team. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase
import StoreKit
import NVActivityIndicatorView

class scheduleViewController: UIViewController, NVActivityIndicatorViewable {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var weekdayLabels: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuesdayLabel: UILabel!
    @IBOutlet weak var wednesdayLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    
    var dj: UserDJ?
    var eventSnapshot: [String: AnyObject]?
    var refEventList: DatabaseReference!
    //var editingLocation: String?
    //var editingStartDate: String?
    //var editingEndDate: String?
    var dateForDeletion: String?
    
    let today = Date.init()
    let formatter = DateFormatter()
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {

        let alert = UIAlertController(title: "Oops!", message: "Are you sure you want to delete this event?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.destructive, handler: { action in
                    self.deleteEvent()
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default
                , handler: { action in
                self.dismissAlert()
                }))
            
            self.present(alert, animated: true, completion: nil)
        
            return
    }
    
    func dismissAlert(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setThefonts() {
        year.font = UIFont(name: "BebasNeue-Regular", size: 15)
        month.font = UIFont(name: "BebasNeue-Regular", size: 20)
        locationLabel.font = UIFont(name: "BebasNeue-Regular", size: 25)
        timeLabel.font = UIFont(name: "BebasNeue-Regular", size: 20)
        sundayLabel.font = UIFont(name: "BebasNeue-Regular", size: 20)
        mondayLabel.font = UIFont(name: "BebasNeue-Regular", size: 20)
        tuesdayLabel.font = UIFont(name: "BebasNeue-Regular", size: 20)
        wednesdayLabel.font = UIFont(name: "BebasNeue-Regular", size: 20)
        thursdayLabel.font = UIFont(name: "BebasNeue-Regular", size: 20)
        fridayLabel.font = UIFont(name: "BebasNeue-Regular", size: 20)
        saturdayLabel.font = UIFont(name: "BebasNeue-Regular", size: 20)
    }
    
    func deleteEvent() {
        startAnimating()
        if let workingSnap = self.eventSnapshot {
            for (k,v) in workingSnap {
                if let dateAndTime = v["StartDateAndTime"] as? String, let theName = v["DJ Name"] as? String{
                    //print("WE'RE IN")
                    //print("\(dateAndTime)")
                    let dateAloneArray = dateAndTime.split(separator: ",")
                    let dateForComparison = dateAloneArray[0]
                    let realDate = String(dateForComparison)
                    
                    
                    let dateFormatter2 = DateFormatter()
                    
                    dateFormatter2.dateStyle = DateFormatter.Style.short
                    dateFormatter2.timeStyle = DateFormatter.Style.short
                    dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
                    
                    
                    for date in calendarView.selectedDates{
                        let strDate = dateFormatter2.string(from: date)
                        let clickedOndateAloneArray = strDate.split(separator: ",")
                        let clickedOnDateForComparison = clickedOndateAloneArray[0]
                        let clickedOnRealDate = String(clickedOnDateForComparison)

                        if (realDate == clickedOnRealDate && theName == dj?.djName){
                        refEventList.child(k).removeValue()
                        self.getEventSnapshot()
                        calendarView.reloadData()
                        self.stopAnimating()
                        let alert = UIAlertController(title: "Event deleted successfully!", message: "We have successfully removed your event from your calendar.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { action in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
    func setEditButtonShape(){
        deleteButton.layer.cornerRadius = 10
        deleteButton.titleLabel?.font = UIFont(name: "BebasNeue-Regular", size: 20)
    }
    
    
    func getEventSnapshot(){
        if refEventList != nil {
            refEventList.observeSingleEvent(of: .value, with: {(snapshot) in
                if snapshot.exists() {
                    //print("snap exists")
                    DispatchQueue.main.async {
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            self.eventSnapshot = dictionary
                        }
                    }
                }
                else {
                    self.eventSnapshot = nil
                    //print("snap does not exist")
                }
            }, withCancel: nil)
        } else {
            self.eventSnapshot = nil
            //print("ref even does not exist")
        }
    }
    
    
    func isFound(eventDateAndTime: String) ->(found: Bool, key: String, location: String,time: String,otherTime: String) {
        if let workingSnap = self.eventSnapshot {
            for (k,v) in workingSnap {
                
                if let dateAndTime = v["StartDateAndTime"] as? String, let endDateAndTime = v["EndDateAndTime"] as? String, let theName = v["DJ Name"] as? String, let location = v["location"] as? String {
                    
                    let dateAloneArray = dateAndTime.split(separator: ",")
                    let dateForComparison = dateAloneArray[0]
                    let realDate = String(dateForComparison)
                    
                    let realTimeForString = dateAloneArray[1]
                    let realTime = String(realTimeForString)
                    let realTimeBare = realTime.replacingOccurrences(of: " ", with: "")
                    
                    
                    let timeAloneArray = endDateAndTime.split(separator: ",")
                    let realEndTimeForString = timeAloneArray[1]
                    let realEndTime = String(realEndTimeForString)
                    let realEndTimeBare = realEndTime.replacingOccurrences(of: " ", with: "")
                
                    if theName == dj?.djName && realDate == eventDateAndTime {
                        //cache this data here
                        return (true, k, location,realTimeBare,realEndTimeBare)
                    }
                }
            }
        }
        else {
            //print("Snap did not load")
        }
        return (false, "","","","")
    }

    @IBAction func addTapped(_ sender: Any) {
        //let theView = self.tabBarController?.viewControllers![2] as! addEventViewController

        //let theArrayOfDates = calendarView.selectedDates
        
        //for date in theArrayOfDates{
         //   formatter.dateStyle = DateFormatter.Style.short
          //  formatter.timeStyle = DateFormatter.Style.short
           // theView.eventToAddDateAndTime.text = formatter.string(from: date)
        //}
        
        self.tabBarController?.selectedIndex = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        setEditButtonShape()
        timeLabel.isHidden = true
        deleteButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.calendarView.reloadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        if let _ = dj?.uid {
            //print("DJ has uid")
            refEventList = Database.database().reference().child("Events")
        }
        else {
            //print("DJ does not have uid")
        }
        getEventSnapshot()
        setThefonts()
    }
    
    //override func viewWillDisappear(_ animated: Bool) {
      //  UIApplication.shared.statusBarStyle = .default
    //}
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = formatter.string(from: date)
    }
    
    func setupCalendarView() {
        //Set up calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        //Set up labels
        calendarView.visibleDates { (visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*func handleEdit() {
        if let viewControllers = self.tabBarController?.viewControllers, let addController = viewControllers[2] as? addEventViewController {
            
            if let location = self.editingLocation, let startTime = self.editingStartDate, let endTime =
                self.editingEndDate {
                addController.isEditingEvent = true
                addController.editingEventInfo = [startTime, endTime, location]
                self.tabBarController?.selectedIndex = 2
            }
            else {
                //print("Editing location, start date, and end date not set. ")
            }
        }
        else {
            //print("Can't make the 2nd view controller an addevent view controller")
        }
    }*/
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as! CalendarCell?
            else{return}
        if cellState.isSelected {
            validCell.selectedView.isHidden = false //Showing selected circle.
        }
        else{
            validCell.selectedView.isHidden = true //Not Showing selected circle.
        }
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState, date: Date){
        guard let validCell = view as! CalendarCell? else{return}
        if cellState.isSelected {
            validCell.dateLabel.textColor = UIColor.black
        }
        else{
                if cellState.dateBelongsTo == .thisMonth{
                validCell.dateLabel.textColor = UIColor.white
                }
                else{
                validCell.dateLabel.textColor = UIColor.darkGray
                }
        }
    }
    
    func checkForEvent(date: Date) -> Bool{
        let dateFormatter2 = DateFormatter()
        
        dateFormatter2.dateStyle = DateFormatter.Style.short
        dateFormatter2.timeStyle = DateFormatter.Style.short
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        
        let strDate = dateFormatter2.string(from: date)
        
        let arr = strDate.split(separator: ",")
        let dateAlone = arr[0]
        
        let isFoundTuple = isFound(eventDateAndTime: String(dateAlone))
        if isFoundTuple.0 {
            return true
        }
        else {
            //print("RETURNED FALSE")
        return false
        }
    }
}

extension scheduleViewController: JTAppleCalendarViewDataSource {
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let date = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.short
        dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        
        let startDate = formatter.date(from: "\(year) \(month) \(day)")
        let endDate = formatter.date(from: "2030 12 29")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }
}

extension scheduleViewController: JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        _ = cell as! CalendarCell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "calCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState,date: date)
        //handleCellColorAndTextForEvents(view: cell, date: date, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState,date: date)
        
        //Here, we will take snapshot of event and make labels visible upon
        //the sight of an event.
        let dateFormatter2 = DateFormatter()
        
        dateFormatter2.dateStyle = DateFormatter.Style.short
        dateFormatter2.timeStyle = DateFormatter.Style.short
        dateFormatter2.locale = Locale(identifier: "en_US_POSIX")
        
        let strDate = dateFormatter2.string(from: date)
        
        dateForDeletion = strDate
        let arr = strDate.split(separator: ",")
        let dateAlone = arr[0]
        
        let isFoundTuple = isFound(eventDateAndTime: String(dateAlone))
        
        if isFoundTuple.0 {
            locationLabel.adjustsFontSizeToFitWidth = true
            locationLabel.text = "Show at \(isFoundTuple.2)"
            timeLabel.isHidden = false
            timeLabel.text = "\(isFoundTuple.3) - \(isFoundTuple.4)"
            deleteButton.isHidden = false
        }
        else{
            locationLabel.text = "No Scheduled gigs on Selected Day"
            timeLabel.isHidden = true
            deleteButton.isHidden = true
        }
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState, date: date)
        //handleCellColorAndTextForEvents(view: cell, date: date, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
}
