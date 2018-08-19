//
//  CategoryTableView.swift
//  ToDoDoTo
//
//  Created by Admin on 18.08.2018.
//  Copyright © 2018 MaximMasov. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableView: UITableViewController {

    var categoryArray = [Category]()
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }

    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! MainScreen
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK: - DATA Manipulate data
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //Creating UIAlert action with TextField
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo Categories!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen once User hits add item
            let newCategory = Category(context: self.contex)
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
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
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            categoryArray = try contex.fetch(request)
        } catch {
            print("Something wrong: \(error)")
        }
        tableView.reloadData()
    }
    
    
    
    
}
