//
//  BucketListViewController.swift
//  CoreDataTut
//
//  Created by Nitesh Mainaly on 6/14/21.
//

import Foundation
import UIKit


final class BucketListViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var items: [BucketListItem]?
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    
    //MARK: - Helper
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        fetchItems()
    }
    
    private func fetchItems() {
        //MARK: Retrieving data
        do {
            self.items = try context.fetch(BucketListItem.fetchRequest())
            
            // Always do UI work in the main thread.
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error, unable to fetch BucketListItem.")
        }
    }
    
    private func addItem(withName name: String) {
        //MARK: Creating new item
        // Create a new BucketListItem object
        let newItem = BucketListItem(context: context)
        newItem.name = name
        newItem.dateAdded = Date()
        
        // Save the data
        do {
            try self.context.save()
        } catch {
            print("Error saving context.")
        }
        
        // Refresh table view
        fetchItems()
    }
    
    //MARK: - Actions
    @IBAction func addButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default, handler: { [weak alertController] (action) in
            if let text = alertController?.textFields?.first?.text, !text.isEmpty {
                self.addItem(withName: text)
            }
        })
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "New Item"
            textfield.addAction(UIAction(title: "", handler: { _ in
                addAction.isEnabled = !(textfield.text ?? "").isEmpty
            }), for: .editingChanged)
        }
        
        addAction.isEnabled = false
        alertController.addAction(addAction)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}


//MARK: - UITableViewDataSource, UITableViewDelegate
extension BucketListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let items = items else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "listItem") as! BucketListItemTableViewCell
            
        if let item = items?[indexPath.row] {
            cell.itemName.text = item.name
        }
        
        return cell
    }
    
    
    // Delete row - Using trailingSwipeActionsConfigurationForRowAt instead of commit editingStyle to change the delete action background color.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
            
            //MARK: Deleting CoreData objects
            if let itemToRemove = self.items?[indexPath.row] {
                self.context.delete(itemToRemove)
                
                do {
                    try self.context.save()
                } catch {
                    print("Error saving context.")
                }
            }
            
            self.fetchItems()
            
            completion(true)
        }
            
        delete.backgroundColor = UIColor(named: "024025026")
     
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
     
        return config
    }
    
}
