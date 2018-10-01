//
//  TableViewController.swift
//  DogBreedClassifier
//
//  Created by Chris Saad on 9/29/18.
//  Copyright © 2018 Chris Saad. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    //var breed: String?
    var pets: [Pet]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.pets?.count)!
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell", for: indexPath) as? PetTableViewCell else {
            fatalError("The dequeued cell is not an instance of PetTableViewCell.")
        }
        
        
        let p = pets![indexPath.row]
        cell.nameLabel.text = p.name!["$t"]
        cell.ageLabel.text = "Age: " + p.age!["$t"]!
        cell.sexLabel.text = "Sex: " + p.sex!["$t"]!
        
        let picUrl = URL(string: (p.media?.photos?.photo![1]["$t"])!)
        let imageData = try! Data(contentsOf: picUrl!)
        let image = UIImage(data: imageData)
        cell.imageView?.image = image

        
        //cell.imageView?.image = p.media?.photos?.photo![0]["$t"]
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PetInfoViewController") as? PetInfoViewController
        vc?.petDescription = pets![indexPath.row].description!["$t"]
        vc?.email = pets![indexPath.row].contact?.email!["$t"]
        vc?.petName = pets![indexPath.row].name!["$t"]
        vc?.phone = pets![indexPath.row].contact?.phone!["$t"]
        vc?.petSex = pets![indexPath.row].sex!["$t"]
        let imgURL = URL(string: ((pets![indexPath.row].media?.photos?.photo![3]["$t"])!))
        let imageData = try! Data(contentsOf: imgURL!)
        let image = UIImage(data: imageData)
        vc?.petImage = image
        vc?.zip = pets![indexPath.row].contact?.zip!["$t"]
        
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
