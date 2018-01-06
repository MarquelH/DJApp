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

class scheduleViewController: UIViewController {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let djRootViewController = DJRootViewController()
        djRootViewController.dj = dj
        
        let djNavController = UINavigationController(rootViewController: djRootViewController)
        self.present(djNavController, animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ScehdulingStoryboard", bundle:nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "addEventView") as! addEventViewController
        controller.dj = dj
        self.present(controller, animated: true, completion: nil)
    }
    
    var dj: UserDJ?
    
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCalendarView()
    }
    
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
    
    func handleCellTextColor(view: JTAppleCell?, cellState: CellState){
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
    
}

extension scheduleViewController: JTAppleCalendarViewDataSource {
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 12 29")
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
        handleCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
}
