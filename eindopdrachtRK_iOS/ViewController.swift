//
//  ViewController.swift
//  eindopdrachtRK_iOS
//
//  Created by Macbook 14 on 24/02/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import UIKit
import CoreData

class ViewController : UITableViewController
{
    private var series = [String]()
    private var pokemonLocation = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData();
    }

    func loadData(){
        if let url = URL(string: "https://pokeapi.co/api/v2/pokemon") {
            //URLSession coördineert groepen netwerktaken
             let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let receivedData = data {

                    var pokemonDataOptional : AllPokemon?
                    // Try decoding the JSON-formatted Pokemon
                    do {
                        pokemonDataOptional = try JSONDecoder().decode(AllPokemon.self, from: receivedData)
                    }
                    // Print error if decoding JSON failed
                    catch {
                        print("Parsing of Pokémon failed!")
                    }
                    if let pokemonData = pokemonDataOptional {
                        DispatchQueue.main.async {
                            pokemonData.results.forEach{ d in
                                let name = String(d.name)
                                self.series.append(name)
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
            // start de task, omdat task standaard suspended is
            task.resume();
        }
    }
    
    // methode returned hoeveelheid elements in de series string[]
    // UITableView representeerd data in rows & columns
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return series.count
    }
    //methode returned de cellen
    //UITableViewCell visuele representatie van een enkele row
    //dequeueReusableCell returned een cell object om te gebruiken / laten zien
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for:indexPath)
        cell.textLabel?.text = series[indexPath.row]
        return cell
    }

    // methode override de actie die moet gebeuren als je een table row swiped
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        -> UISwipeActionsConfiguration? {
            let add = UIContextualAction(style: .normal, title: "Add") {(action, view, nil) in
                
                //Container is stored in the appdelegate
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
                
                // Create context for container
                let managedContext = appDelegate.persistentContainer.viewContext
               
                // Create entity for new objects
                let favouriteEntity = NSEntityDescription.entity(forEntityName: "FavoritePokemon", in: managedContext)
                
                // Get rows that were swiped
                let selectedCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
                
                // Create object for saving the value of the swiped row
                let object = NSManagedObject(entity: favouriteEntity!, insertInto: managedContext)
                
                object.setValue(selectedCell.textLabel!.text, forKey: "name")
                
                do{
                    try managedContext.save()
                }
                catch let error as NSError{
                    print("Could not save Pokémon. \(error), \(error.userInfo)")
                }
            }
            return UISwipeActionsConfiguration (actions:[add])
           }
    
    //set pokémon name for detailscontroller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let details = segue.destination as? DetailController {
            let indexPath = tableView.indexPathForSelectedRow!
            let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
            details.pokemonName = (currentCell.textLabel!.text ?? "def")
        }
    }
}
