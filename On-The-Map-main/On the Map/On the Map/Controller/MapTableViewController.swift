//
//  MapTableViewController.swift
//  On the Map
//
//  Created by YoYo on 2021-06-12.
//

import Foundation
import UIKit
class MapTableViewController: UITableViewController {
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var cellReuse = "reuseCell"
    var studentLocation = [StudentLocation]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        Client.getStudentLocation(completionHandler: { (StudentData, error)
        in
            self.studentLocation = StudentData
            self.tableViewOutlet.reloadData()
        })
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = studentLocation[indexPath.row]
        
        let url = student.mediaURL
        UIApplication.shared.open(URL(string: url)!, completionHandler: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(studentLocation.count)
        return studentLocation.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuse, for: indexPath)
        let student = studentLocation[indexPath.row]
        cell.textLabel?.text = student.firstName + student.lastName
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
        
    }
    @IBAction func logout(){
        Client.logout{
            print("successfully logout")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
  

}
