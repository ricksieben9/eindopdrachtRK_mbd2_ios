//
//  FavouritesController.swift
//  eindopdrachtRK_iOS
//
//  Created by Macbook 14 on 27/02/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import UIKit
import CoreData

class FavouritesController: UITableViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        retrieveData()
    }
    
    public var favoriteList:[String] = []

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCel", for:indexPath)
        cell.textLabel?.text = favoriteList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        ->   UISwipeActionsConfiguration? {
            
            //setUp delete from favorites
            let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view , nil) in
                //Container is stored in the app delegate
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                //setup context for the container
                let managedContext = appDelegate.persistentContainer.viewContext
                //get current row
                let currentCell = tableView.cellForRow(at: indexPath )! as UITableViewCell
                //setup the fetch request
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritePokemon")
                fetchRequest.predicate = NSPredicate(format: "name = %@", currentCell.textLabel!.text!)
                
                do{
                    //try deleting the object
                    let object = try managedContext.fetch(fetchRequest)
                    let objectToDelete = object[0] as! NSManagedObject
                    managedContext.delete(objectToDelete)
                    
                    do{
                        try managedContext.save()
                        //Remove the pokemon from the favoritelist
                        if let index = self.favoriteList.firstIndex(of: currentCell.textLabel!.text!) {
                            self.favoriteList.remove(at: index)
                        }
                        //reload tableview
                        self.tableView.reloadData();
                    }catch{
                        print(error)
                    }
                }catch{
                    print(error)
                }
                
                
            }
            return UISwipeActionsConfiguration (actions: [delete])
    }
    
    
    
    func retrieveData(){
        //setup retrieve call
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoritePokemon")
        
        do {
            //add all of the results to the favoritelist
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                favoriteList.append(data.value(forKey: "name") as! String)
            }
        }catch{
            print("Failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //prepare if the destination is detailscontroller send pokemon name
        if let details = segue.destination as? DetailController {
            
            let indexPath = tableView.indexPathForSelectedRow!
            let currentCell = tableView.cellForRow(at: indexPath )! as UITableViewCell
            details.pokemonName = (currentCell.textLabel!.text ?? "def")
            
        }
        
    }
    
}

