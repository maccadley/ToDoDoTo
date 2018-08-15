//
//  ViewController.swift
//  ToDoDoTo
//
//  Created by Admin on 15.08.2018.
//  Copyright © 2018 MaximMasov. All rights reserved.
//

import UIKit

class MainScreen: UITableViewController {
    
    let itemArray = ["Find me", "Buy balls", "Destroy Moscow"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    //Mark: - TableView DataSorceMethods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

}

