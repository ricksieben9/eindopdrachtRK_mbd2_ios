//
//  DetailController.swift
//  eindopdrachtRK_iOS
//
//  Created by Macbook 14 on 24/02/2020.
//  Copyright © 2020 RK. All rights reserved.
//

import UIKit

class DetailController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var abilities = [String]()
  
   @IBOutlet weak var experienceLabel: UILabel!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var weightLabel: UILabel!
   @IBOutlet weak var heightLabel: UILabel!
   
   var pokemonName: String = " "

   @IBOutlet weak var pokemonImage: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        nameLabel.text = pokemonName
        nameLabel.adjustsFontSizeToFitWidth = true;
        loadData();
    }
       
    func loadData(){
        if let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonName)") {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, err in
                DispatchQueue.main.async {
                    
                    if let err  = err {
                        print("failed to get data from url:" ,err)
                        return
                    }
                    
                    if let receivedData = data{
                        
                        do{
                            
                            let pokemonData = try JSONDecoder().decode(pokemonDetail.self, from: receivedData)
                            
                            if let sprite = pokemonData.sprites?.front_default{
                                
                                let url = URL(string: sprite)
                                let data = try Data(contentsOf: url!)
                                
                                let i = UIImage(data: data)
                                
                                if let loadedImage = i {
                                    
                                    self.pokemonImage.image = loadedImage
                                }
                            }
                            if let abilities = pokemonData.abilities{
                                abilities.forEach{ res in
                                    self.abilities.append(res.ability.name)
                            
                                }
                                
                            }
                            
                            
                            if let height = pokemonData.height{
                                self.heightLabel.text = String(height)
                            }
                            
                            if let weight = pokemonData.weight{
                                self.weightLabel.text = String(weight)
                            }
                            
                            if let base_experience = pokemonData.base_experience{
                                self.experienceLabel.text = String(base_experience)
                            }
                            
                            self.tableView.reloadData();
                            
                        }catch{
                            
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abilities.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "abilityCell", for:indexPath)
        cell.textLabel?.text = abilities[indexPath.row]
        return cell
    }
}
