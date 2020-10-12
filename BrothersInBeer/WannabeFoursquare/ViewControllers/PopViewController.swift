//
//  PopViewController.swift
//  WannabeFoursquare
//
//  Created by Cenda on 14/02/2020.
//  Copyright © 2020 CVUT. All rights reserved.
//

import UIKit
import FirebaseDatabase
import MapKit
import Firebase

class PopViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var pubTypeField: UITextField!
    @IBOutlet weak var successMessage: UILabel!
    
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    
    var location: CLLocationCoordinate2D?
    
    @IBAction func confirmButtonClicked(_ sender: UIButton) {
        if location == nil {
            return
        }
        guard let name = usernameField.text else {
            return
        }
        guard let pubType = pubTypeField.text else {
            return
        }
        guard let lat = location?.latitude else {
            return
        }
        guard let lon = location?.longitude else {
            return
        }
        let newCheckinReference = Database.database().reference(withPath: "pubs").child(name)

        let dict:NSDictionary = [
            "lat": lat,
            "lon": lon,
            "type": pubType
        ]
        newCheckinReference.setValue(dict)
        successMessage.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        successMessage.isHidden = true
        if location != nil{
            if let lat = location?.latitude{
                latLabel.text = "lat: " + String(lat)
            }
            if let lon = location?.longitude{
                lonLabel.text = "lat: " + String(lon)
            }
        } else {
            latLabel.text = "lat: unknown"
            lonLabel.text = "lon: unknown"
        }
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
