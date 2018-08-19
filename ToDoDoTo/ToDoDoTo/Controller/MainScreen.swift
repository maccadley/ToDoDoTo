//
//  ViewController.swift
//  ToDoDoTo
//
//  Created by Admin on 15.08.2018.
//  Copyright © 2018 MaximMasov. All rights reserved.
//

import UIKit
import CoreData

class MainScreen: UITableViewController, UISearchBarDelegate {
    
    //Singleton of Item class.
    var itemArray = [Item]()
    //We selecting certain categiry and jump in it.
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    //URL to Docements directory, and creating new file which will contains new Arrays of objects
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //Mark: - TableView DataSorceMethods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.itemName
        //Check if Item has doneOrNot boolean and marks it with checkmark
        cell.accessoryType = item.doneOrNot ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Switching BOOlean in Items and imediatly reloads the tableView
        itemArray[indexPath.row].doneOrNot = !itemArray[indexPath.row].doneOrNot
//        contex.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        saveDataAction()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        //Creating UIAlert action with TextField
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once User hits add item
            let newItem = Item(context: self.contex)
            newItem.itemName = textField.text!
            newItem.doneOrNot = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            //Saving this Text to nameOfItem in ItemToDo class
            self.saveDataAction()
        }
        alert.addTextField { (alertTexField) in
            alertTexField.placeholder = "Create new item"
            textField = alertTexField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Saving Data with core data
    func saveDataAction(){
        do{
          try contex.save()
        } catch{
          print("Error saving \(error)")
        }
        self.tableView.reloadData()
    }
    
    //We can use input parametr, or srick to the default, which is All the items insine this request
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate, additionalPredicate])
        } else {
            request.predicate = categorypredicate
        }
        do{
        itemArray = try contex.fetch(request)
        } catch {
            print("Something wrong: \(error)")
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "itemName CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
    
}

