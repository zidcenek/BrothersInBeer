//
//  DetailViewController.swift
//  WannabeFoursquare
//
//  Created by Cenda on 13/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var pubLabel: UILabel!
    @IBOutlet weak var beerNameField: UITextField!
    @IBOutlet weak var priceField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var index: Int?
    var detailVM: DetailVM?
    var editInProgress: Int?
    var count: Int?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailVM?.getDrinks().count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailTableViewCell
        let drink: Drink
        drink = (detailVM?.getDrinks()[indexPath.item])!
        cell?.beerNameLabel.text = "  " + drink.getName()
        cell?.PriceLabel.text = String(drink.getPrice())
        cell?.countLabel.text = String(drink.getCount())
        stepper.value = Double(drink.getCount())
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        beerNameField.text = self.detailVM?.getDrinks()[indexPath.item].getName()
        let price = self.detailVM?.getDrinks()[indexPath.item].getPrice()
        let count = self.detailVM?.getDrinks()[indexPath.item].getCount()
        priceField.text = String(price!)
        countLabel.text = String(count!)
        stepper.value = Double(count!)
        self.editInProgress = indexPath.item
    }
    @IBAction func deleteDrink(_ sender: Any) {
        if self.editInProgress != nil {
            guard let drinkName = beerNameField.text else {
                return
            }
            let price = Int(priceField.text!) ?? 40
            let drink = Drink(name: drinkName, count: 1, price: price)
            detailVM?.deleteDrink(drink: drink, index: self.editInProgress!)
        }
        tableView.reloadData()
        self.editInProgress = nil
        self.clearTextFields()
    }
    @IBAction func addDrink(_ sender: Any) {
        guard let drinkName = beerNameField.text else {
            self.clearTextFields()
            return
        }
        if drinkName == "" {
            self.clearTextFields()
            return
        }
        let price = Int(priceField.text!) ?? 40
        let count = Int(countLabel.text!) ?? 1
        let drink = Drink(name: drinkName, count: count, price: price)
        print(drink.getName())
        print(drink.getPrice())
        print(drink.getCount())
        if self.editInProgress == nil{
            detailVM?.addDrink(drink: drink)
        } else {
            detailVM?.editDrink(drink: drink, index: self.editInProgress!)
        }
        tableView.reloadData()
        self.editInProgress = nil
        self.clearTextFields()
    }
    
    @IBAction func stepperClicked(_ sender: UIStepper) {
        countLabel.text = String(Int(sender.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.editInProgress = nil
        self.priceField.delegate = self
        stepper.value = Double(0)
        if detailVM == nil{
            return
        }
        pubLabel.text = detailVM?.getPubName()
        self.tableView.reloadData()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

    func clearTextFields(){
        priceField.text = ""
        beerNameField.text = ""
        countLabel.text = String(0)
        stepper.value = Double(0)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
