//
//  MealTableViewController.swift
//  AppDevelopmentProject1
//
//  Created by Gaurav Aryal on 2/17/20.
//  Copyright © 2020 Gaurav Aryal. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    var tasks = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved tasks, otherwise load sample data.
        let savedTasks = loadTasks()
        
        if savedTasks?.count ?? 0 > 0 {
            tasks = savedTasks ?? [Meal]()
//        } else {
//            loadSampleTasks()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    //MARK: Actions
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal
                tasks[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                tasks.sort{
                    $0.datePicker.compare($1.datePicker) == .orderedAscending
                }
                tableView.reloadData()
                tasks.sort{
                    !$0.doneSwitch && ($1.doneSwitch)
                }
                tableView.reloadData()
            }
            else {
                // Add a new meal.
                _ = IndexPath(row: tasks.count, section: 0)
                tasks.append(meal)
                tasks.sort{
                    $0.datePicker.compare($1.datePicker) == .orderedAscending
                }
                tableView.reloadData()
                tasks.sort {
                    !$0.doneSwitch && ($1.doneSwitch)
                }
                tableView.reloadData()
            }
            // Save the tasks.
            saveTasks()
        }
    }
    
    
    //MARK: Private Methods
    
    private func loadSampleTasks() {
        
        guard let meal1 = Meal(name: "Finish Project 1", datePicker: "12/02/2020", doneSwitch: false) else {
            fatalError("Unable to instantiate meal1")
        }
        
        guard let meal2 = Meal(name: "Send reply to all the emails", datePicker: "11/23/2020", doneSwitch: false) else {
            fatalError("Unable to instantiate meal2")
        }
        
        guard let meal3 = Meal(name: "Send a message to brother", datePicker: "11/24/2020", doneSwitch: false) else {
            fatalError("Unable to instantiate meal2")
        }
        
        tasks += [meal1, meal2, meal3]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "MealTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Fetches the appropriate meal for the data source layout.
        let meal = tasks[indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.datePickerLabel.text = meal.datePicker
        if(meal.doneSwitch == true){
            cell.backgroundColor = .gray
        }
        else{
            cell.backgroundColor = .white
        }
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            tasks.remove(at: indexPath.row)
            saveTasks()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
     
     let moreRowAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "More", handler:{action, indexpath in
     print("MORE•ACTION");
     });
     moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
     
     let deleteRowAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "Delete", handler:{action, indexpath in
     print("DELETE•ACTION");
     });
     
     return [deleteRowAction, moreRowAction];
     }*/
    
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
        UISwipeActionsConfiguration? {
            let doneButton = UIContextualAction(style: .normal, title:
            "Done") { (action, view, nil) in
                print("Done")
                if self.tasks[indexPath.row].doneSwitch == true {
                    self.tasks[indexPath.row].doneSwitch = false
                    self.sortTable()
                    tableView.reloadData()
                }
                else {
                    self.tasks[indexPath.row].doneSwitch = true
                    self.sortTable()
                    tableView.reloadData()
                }
            }
            if self.tasks[indexPath.row].doneSwitch == true {
                doneButton.backgroundColor = UIColor.blue
                
                doneButton.title = "Undo"
            }
            else {
                doneButton.backgroundColor = UIColor.green
            }
            saveTasks()
            return UISwipeActionsConfiguration(actions: [doneButton])
    }
    
    override func tableView(_ tableView: UITableView,
                            leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) ->
        UISwipeActionsConfiguration? {
            let delete = UIContextualAction(style: .destructive, title:
            "Delete") { (action, view, nil) in
                print("Delete")
                self.tasks.remove(at: indexPath.row)
                self.saveTasks()
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            let config = UISwipeActionsConfiguration(actions: [delete])
            config.performsFirstActionWithFullSwipe = false
            return UISwipeActionsConfiguration(actions: [delete])
    }
    
    private func sortTable(){
        //Sort the table by date
        tasks.sort {
            $0.datePicker.compare($1.datePicker) == .orderedAscending
        }
        //Sort the table by done or not done state of tasks
        tasks.sort {
            !$0.doneSwitch && $1.doneSwitch
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new item.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = tasks[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Private Methods
    private func saveTasks() {
        
        let fullPath = getDocumentsDirectory().appendingPathComponent("tasks")
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false)
            try data.write(to: fullPath)
            os_log("tasks successfully saved.", log: OSLog.default, type: .debug)
        } catch {
            os_log("Failed to save tasks...", log: OSLog.default, type: .error)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadTasks() -> [Meal]? {
        let fullPath = getDocumentsDirectory().appendingPathComponent("tasks")
        if let nsData = NSData(contentsOf: fullPath) {
            do {
                
                let data = Data(referencing:nsData)
                
                if let loadedMeals = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? Array<Meal> {
                    return loadedMeals
                }
            } catch {
                print("Couldn't read file.")
                return nil
            }
        }
        return nil
    }
}
