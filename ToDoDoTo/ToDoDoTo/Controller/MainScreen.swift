//
//  ViewController.swift
//  ToDoDoTo
//
//  Created by Admin on 15.08.2018.
//  Copyright © 2018 MaximMasov. All rights reserved.
//

import UIKit

class MainScreen: UITableViewController {
    //Singleton of Item class.
    var itemArray = [Items]()
    //URL to Docements directory, and creating new file which will contains new Arrays of objects
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
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
        saveDataAction()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addNewItems(_ sender: UIBarButtonItem) {
        //Creating UIAlert action with TextField
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new ToDo!", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once User hits add item
            let newItem = Items()
            newItem.itemName = textField.text!
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
    //MARK: - Decode and Encode the data.
    // Need to use Encodable, Decodable or both - Codable protocol in certain class
    func saveDataAction(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch{
            print("error encondoing: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Items].self, from: data)
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    
}

