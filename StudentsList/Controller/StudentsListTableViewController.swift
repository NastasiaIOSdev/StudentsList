//
//  StudentsListTableViewController.swift
//  StudentsList
//
//  Created by Анастасия Ларина on 07.05.2021.
//

import UIKit
import CoreData

class StudentsListTableViewController: UITableViewController {
    
    // MARK: - Properties
    var resultsController: NSFetchedResultsController<List>!
    let coreDataStack = CoreDataStack()
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        tableView.register (UINib.init (nibName: "UITableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")      
        
        // Request
        let request: NSFetchRequest<List> = List.fetchRequest()
        let sortDescriptors = NSSortDescriptor(key: "date", ascending: true)
        //Init
        request.sortDescriptors = [sortDescriptors]
        resultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: coreDataStack.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultsController.delegate = self
        
        //Fetch
        do {
            try resultsController.performFetch()
        } catch {
            print("Perform fetch error: \(error)")
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! StudentTableViewCell
        
        let list = resultsController.object(at: indexPath)
        cell.nameLabel.text = list.name
        cell.surnameLabel.text = list.surname
        cell.scoreLabel.text = list.score
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Удалить") { (action, view, completion) in
            let list = self.resultsController.object(at: indexPath)
            self.resultsController.managedObjectContext.delete(list)
            do {
                try self.resultsController.managedObjectContext.save()
                completion(true)
            } catch {
                print("delete failed: \(error)")
                completion(false)
            }
            
        }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowAddList", sender: tableView.cellForRow(at: indexPath))
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = sender as? UIBarButtonItem, let vc = segue.destination as? AddStudentsViewController {
            vc.managedContext = resultsController.managedObjectContext
        }
        if let cell = sender as? UITableViewCell, let vc = segue.destination as? AddStudentsViewController {
            vc.managedContext = resultsController.managedObjectContext
            if let indexPath = tableView.indexPath(for: cell) {
                let list = resultsController.object(at: indexPath)
                vc.list = list
            }
        }
    }
}

extension StudentsListTableViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
                let list = resultsController.object(at: indexPath)
                cell.textLabel?.text = list.name
                cell.textLabel?.text = list.surname
                cell.textLabel?.text = list.score
//                cell.nameLabel.text = list.name
//                cell.surnameLabel.text = list.surname
//                cell.scoreLabel.text = list.score
            }
        default:
            break
        }
    }
}
