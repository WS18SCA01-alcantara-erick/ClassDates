//
//  DateTableViewController.swift
//  ClassDates
//
//  Created by Erick Alcantara on 2/9/19.
//  Copyright © 2019 Erick Alcantara. All rights reserved.
//

import UIKit

class DateTableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    
     var classDates: [ClassDate] = [ClassDate]();   //the model

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        //Create an array of eight Ints, giving the length in hours of each weekday's class.
        let length: [Int] = [
            0,   //unused
            0,   //Sunday
            3,   //Monday
            0,   //Tuesday
            3,   //Wednesday
            0,   //Thursday
            0,   //Friday
            6    //Saturday
        ];
        
        //Create an array of ten tuples.  Each tuple contains three Ints.
        let tuples: [(year: Int, month: Int, day: Int)] = [
            (2018, 11, 12),   //Mon Veterans Day
            (2018, 11, 21),   //Wed Thanksgiving Eve
            (2018, 11, 24),   //Sat Thanksgiving
            (2018, 12, 22),   //Sat
            (2018, 12, 24),   //Mon Christmas Eve
            (2018, 12, 26),   //Wed Day after Christmas
            (2018, 12, 29),   //Sat
            (2018, 12, 31),   //Mon New Year's Eve
            (2019,  1, 21),   //Mon Martin Luther King
            (2019,  2, 18)    //Mon Presidents Day
        ];
        
        let calendar: Calendar = Calendar.current;   //our Gregorian calendar
        
        //Create an array of ten Date objects.
        let holidays: [Date] = tuples.map {
            calendar.date(from: DateComponents(year: $0.year, month: $0.month, day: $0.day))!;
        };
        
        //Create the starting date for the course, October 10, 2018.
        let dateComponents: DateComponents = DateComponents(year: 2018, month: 10, day: 10);
        var date: Date = calendar.date(from: dateComponents)!;
        
        let dateFormatter: DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy";
        var hours: Int = 0;
        
        while hours < 270 {   //Keep going until we have amassed 270 hours of classroom time.
            if !holidays.contains(date) {       //If this date is not on the list of holidays,
                //weekday is an Int in the range 1 to 7 inclusive.  1 means Sun, 2 means Mon, etc.
                let weekday: Int = calendar.component(Calendar.Component.weekday, from: date);
                
                if length[weekday] > 0 {        //If we have class on this day,
                    hours += length[weekday];   //means hours = hours + length[weekday];
                    print(hours, dateFormatter.string(from: date));
                    
                    let classDateInstance: ClassDate = ClassDate(date: dateFormatter.string(from:date), hours: hours, weekday: weekday)
                    
                   //  classDates.append("\(hours) \(dateFormatter.string(from: date))");
                    classDates.append(classDateInstance)
                }
            }
            date = calendar.date(byAdding: .day, value: 1, to: date)! //Go to the next date.
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classDates.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "DateCell", for: indexPath)
        
        // Configure the cell...
        let classDateInstance: ClassDate = classDates[indexPath.row]
        
        //        cell.textLabel?.text = classDates[indexPath.row];
        cell.textLabel?.text = "Class \(indexPath.row + 1), \(classDateInstance.hours) hours";    //big label on top
        cell.detailTextLabel?.text = classDateInstance.date; //small label below
        cell.imageView?.image = UIImage(named: "\(classDateInstance.weekday).png")
        cell.showsReorderControl = true
        
        return cell
    }
    // MARK: - Table view delegate
    
    //Called when a cell is tapped.
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s: String = classDates[indexPath.row].date;
        print(indexPath.row, s);
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt
        fromIndexPath: IndexPath, to: IndexPath) {
        let movedDate = classDates.remove(at: fromIndexPath.row)
        classDates.insert(movedDate, at: to.row)
        tableView.reloadData()
    }

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
        
    }
    
}
