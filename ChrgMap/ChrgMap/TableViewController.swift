//
//  TableViewController.swift
//  ChrgMap
//
//  Created by Дмитрий Червяков on 23/11/2018.
//  Copyright © 2018 Дмитрий Червяков. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var toDoItems: [Task] = []
    
    lazy var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            toDoItems = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for:indexPath)
        
        cell.textLabel?.text = toDoItems[indexPath.row].taskToDo
        
        return cell
    }


    @IBAction func addTaskButtonTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add task", message: "add new task", preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "Ok", style: .default) { action in
            let textField = alertController.textFields?[0]
            
            self.saveTask(taskToDo: (textField?.text)!)
            
            self.tableView.reloadData()
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addTextField { textField in }
        alertController.addAction(okButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func saveTask(taskToDo:String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let taskObject = NSManagedObject(entity: entity!, insertInto: context) as! Task

        taskObject.taskToDo = taskToDo;
        
        do {
            try context.save()
            toDoItems.append(taskObject)
            print("saved")
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

