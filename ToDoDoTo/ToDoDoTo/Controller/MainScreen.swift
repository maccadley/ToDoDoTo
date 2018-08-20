//
//  ViewController.swift
//  ToDoDoTo
//
//  Created by Admin on 15.08.2018.
//  Copyright © 2018 MaximMasov. All rights reserved.
//

import UIKit
import RealmSwift

class MainScreen: UITableViewController, UISearchBarDelegate {
    
    //Singleton of Item class.
    var toDoItem: Results<Item>?
    let realm = try! Realm()
    //We selecting certain categiry and jump in it.
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    //URL to Docements directory, and creating new file which will contains new Arrays of objects
  //  let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //Mark: - TableView DataSorceMethods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItem?[indexPath.row]{
        cell.textLabel?.text = item.title
            //Check if Item has doneOrNot boolean and marks it with checkmark
        cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItem?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Switching BOOlean in Items and imediatly reloads the tableView
        if let item = toDoItem?[indexPath.row] {
            do{
            try realm.write{
                //Delete the item from realm
                //realm.delete(item)
                item.done = !item.done
            }
            }catch{
                print("Error with updating the data: \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        //Creating UIAlert action with TextField
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once User hits add item
            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                }catch{
                    print("Error with realm: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTexField) in
            alertTexField.placeholder = "Create new item"
            textField = alertTexField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //We can use input parametr, or stick to the default, which is All the items insine this request
    func loadItems(){
        toDoItem = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItem = toDoItem?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
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

