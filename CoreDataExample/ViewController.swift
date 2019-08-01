//
//  ViewController.swift
//  CoreDataExample
//
//  Created by Amsaraj Mariappan on 1/8/2562 BE.
//  Copyright © 2562 Amsaraj Mariyappan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var employee: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.setupNavigationTitle()
    }
    
    func setupNavigationTitle() {
        self.title = "Core Data"
    }

    func setUpView() {
        self.setupNavigationTitle()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        self.fetchCoreData(managedContext)
    }

    func fetchCoreData(_ managedContext: NSManagedObjectContext) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
        
        do {
            let results =
                try managedContext.fetch(fetchRequest)
            employee = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    

   
    
    @IBAction func AddNames(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add New Emp", message: "enter employee name", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(action: UIAlertAction) -> Void in
            let textField = alert.textFields!.first
            self.saveName(textField!.text!)
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {(action: UIAlertAction) -> Void in
        })
        
        alert.addTextField {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK - CoreData func
    func saveName(_ name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "Employee",
                                                 in:managedContext)
        let person = NSManagedObject(entity: entity!,
                                     insertInto: managedContext)
        
        person.setValue(name, forKey: "name")
        
        do {
            try managedContext.save()
            employee.append(person)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }


}

// MARK - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employee.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        let employees = employee[indexPath.row]
        cell.textLabel!.text = employees.value(forKey: "name") as? String
        
        return cell
    }
    
    //Mark - Delete core data items
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        switch editingStyle {
        case .delete:
            // remove the deleted item from the model
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            managedContext.delete(employee[indexPath.row] as NSManagedObject)
            do {
                try managedContext.save()
                employee.remove(at: indexPath.row)
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            return
            
        }
    }
}

