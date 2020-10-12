//
//  SessionsTableViewController.swift
//  WannabeFoursquare
//
//  Created by Cenda on 12/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class SessionsTableViewController: UITableViewController {
    var sessionTableVM = SessionTableViewModel()
    var drinkingSessions = [Session]()
    let defaults = UserDefaults.standard
    
    struct Keys {
        static let userId = "userIdentifier"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = self.checkForUserId()
        self.drinkingSessions = self.sessionTableVM.loadSessions()
        Database.database().reference(withPath: "sessions").observe(.value) { snapshot in
            self.drinkingSessions.removeAll()
            for ses in snapshot.children.allObjects as![DataSnapshot] {
                // parsing the data
                if let dictionary = ses.value as? [String: AnyObject] {
                    if (dictionary["pub"] == nil || dictionary["user"] == nil){
                        continue
                    }
                    if dictionary["user"] as! String != userID{
                        continue
                    }
                    let ses = Session(pub: dictionary["pub"] as! String, timestamp: 1839147914.6, user: dictionary["user"] as! String, key: ses.key)
                    // takes care of drinks
                    if let drinks = dictionary["drinks"] as? [String: AnyObject]{
                        for drink in drinks{
                            guard let count = drink.value["count"] as? Int else {
                                continue
                            }
                            guard let price = drink.value["price"] as? Int else {
                                continue
                            }
                            ses.drinks.append(Drink(name: drink.key, count: count, price: price))
                        }
                    }
                    
                    self.drinkingSessions.append(ses)
                }
            }
            self.sessionTableVM.drinkingSessions = self.drinkingSessions
            self.tableView.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drinkingSessions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell", for: indexPath) as! SessionTableViewCell
        if indexPath.item % 2 == 0{
            cell.backgroundColor = UIColor.systemOrange
        } else {
            cell.backgroundColor = UIColor.systemRed
        }
        cell.cellVM = self.sessionTableVM.fillCell(indexPath: indexPath.item)
        cell.pubName.text = cell.cellVM?.getPubName()
        return cell
    }

    @IBAction func addDrinkingSession(_ sender: Any) {
        let alertController = UIAlertController(title: "New Drinking Session", message: "Write the name of tonight`s drinking", preferredStyle: .alert)
        
        let updateAction = UIAlertAction(title: "New", style: .default){(_) in
            if let name = alertController.textFields?[0].text{
                self.sessionTableVM.addDrinkingSession(name: name, userID: self.checkForUserId())
            }
        }
        alertController.addTextField{(textField) in
            textField.text = ""
        }
        alertController.addAction(updateAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailViewController
        vc!.detailVM = self.sessionTableVM.getDetailVM(indexPath: indexPath.item)
        vc!.index = indexPath.item
        
        navigationController?.present(vc!, animated: true, completion: nil)
    }
    
    func saveUserId(userID: String){
        defaults.set(userID, forKey: Keys.userId)
    }
    
    func checkForUserId() -> String {
        var name = defaults.value(forKey: Keys.userId) as? String ?? ""
        if ( name == "" ){
            let rand = NSUUID().uuidString  // todo
            saveUserId(userID: rand)
            name = rand
        }
        return name
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
