//
//  CategoryTableView.swift
//  ToDoDoTo
//
//  Created by Admin on 18.08.2018.
//  Copyright © 2018 MaximMasov. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableView: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories added!"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainScreen
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - DATA Manipulate data
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Creating UIAlert action with TextField
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo Categories!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once User hits add item
            let newCategory = Category()
            newCategory.name = textField.text!
            //Saving this Text to nameOfItem in ItemToDo class
            self.save(category: newCategory)
        }
        alert.addTextField { (alertTexField) in
            alertTexField.placeholder = "Create new item"
            textField = alertTexField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Saving Data with core data
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        } catch{
            print("Error saving \(error)")
        }
        self.tableView.reloadData()
    }
    
    //We can use input parametr, or srick to the default, which is All the items insine this request
    func loadCategories(){
        categoryArray = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    
    
    
}
