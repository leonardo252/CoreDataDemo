//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Leonardo Gomes on 14/10/20.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Data for the table
    var items:[Person]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        fetchPeople()
    }

    func relationshipDemo() {
        //Create a new family
        let family = Family(context: context)
        family.name = "New Family"
        
        // Create a person
        let person = Person(context: context)
        person.name = "Maggie"
        
        // Create a relatioship
//        person.family = family
        family.addToPeople(person)
        
        // Save context
        try! context.save()
        
        
    }
    func fetchPeople() {
        
        //fetch the date from core data to display in the tableview
        do {
            let request = Person.fetchRequest() as NSFetchRequest<Person>
            
            //Set filtering and sorting on the request
//            let pred = NSPredicate(format: "name CONTAINS %@", "Ted")
//            request.predicate = pred
            
            // Sort Descriptor
            let sort = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sort]
            
            self.items = try context.fetch(request)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        //Create ALERT
        let alert = UIAlertController(title: "Add Person", message: "What is their Name?", preferredStyle: .alert)
        alert.addTextField()
        
        // Configrue button handler
        let submitButton = UIAlertAction(title: "Add", style: .default) {
            (action) in
            
            // Get textfield for the alert
            let textField = alert.textFields![0]
            
            // Create a person object
            let newPerson = Person(context: self.context)
            newPerson.name = textField.text
            newPerson.age = 26
            newPerson.gender = "Male"
            
            // Save the data
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            // Re-fresh the data
            self.fetchPeople()
        }
        
        //Add Button
        alert.addAction(submitButton)
        
        //Show Alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let theItems = items else {
            return 0
        }
        return theItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        
        // get person from attay and set label
        let person = self.items![indexPath.row]
        
        cell.textLabel?.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Selected Person
        let person = self.items![indexPath.row]
        
        print(person.newFamily?.name)
        // Create Alert
        let alert = UIAlertController(title: "Edit Person", message: "Edit Name", preferredStyle: .alert)
        alert.addTextField()
        
        let textField = alert.textFields![0]
        textField.text = person.name
        
        let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
            
            // get new name
            let textField = alert.textFields![0]
            
            // Change name in person properties
            person.name = textField.text
            
            // save data
            
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            // update data
            
            self.fetchPeople()
        }
        
        alert.addAction(saveButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Create Swipe action
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            // Wich person to reomve
            let personToRemove = self.items![indexPath.row]
            
            // remove person
            self.context.delete(personToRemove)
            
            //save the data
            do {
                try self.context.save()
            }
            catch {
                
            }
            
            // Re-fresh the data
            self.fetchPeople()
        }
        
        // Update Swipe action
        let upAction = UIContextualAction(style: .normal, title: "Update") { (action, view, completionHandler) in
            
            // Selected Person
            let person = self.items![indexPath.row]
            
            // Create Alert
            let alert = UIAlertController(title: "Edit Person", message: "Edit Name", preferredStyle: .alert)
            alert.addTextField()
            
            let textField = alert.textFields![0]
            textField.text = person.name
            
            let saveButton = UIAlertAction(title: "Save", style: .default) { (action) in
                
                // get new name
                let textField = alert.textFields![0]
                
                // Change name in person properties
                person.name = textField.text
                
                // save data
                
                do {
                    try self.context.save()
                }
                catch {
                    
                }
                
                // update data
                
                self.fetchPeople()
            }
            
            alert.addAction(saveButton)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        return UISwipeActionsConfiguration(actions: [action,upAction])
    }
    
}
