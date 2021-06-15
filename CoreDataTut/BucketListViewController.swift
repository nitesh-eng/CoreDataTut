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
    private var addActionEnabled: Bool = false
    
    //TEMP
    private var tempItems = [String]()
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    
    //MARK: - Helper
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tempItems = ["Skydive", "Snorkel", "Bungie Jump", "Paris", "Houson BBQ", "Salt Flats", "Finish a song"]
    }
    
    private func addItem(withName name: String) {
        tempItems.append(name)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: tempItems.count-1, section: 0)], with: .automatic)
        tableView.endUpdates()
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
        return tempItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listItem") as? BucketListItemTableViewCell {
            cell.itemName.text = tempItems[indexPath.row]
            return cell
        }
        
        fatalError("Unable to dequeueReusableCell")
    }
    
    
    // Delete row - Using trailingSwipeActionsConfigurationForRowAt instead of commit editingStyle to change the delete action background color.
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, completion) in
                
            tempItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
                
            completion(true)
        }
            
        delete.backgroundColor = UIColor(named: "024025026")
     
        let config = UISwipeActionsConfiguration(actions: [delete])
        config.performsFirstActionWithFullSwipe = false
     
        return config
    }
    
}
