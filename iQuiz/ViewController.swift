//
//  ViewController.swift
//  iQuiz
//
//  Created by Ian Wang on 5/9/22.
//

import UIKit

class ViewController: UIViewController {
    
    var tableDataAndDelegate = TableDataAndDelegate()
    @IBOutlet weak var SubjectsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableDataAndDelegate.vc = self
        SubjectsTableView.delegate = tableDataAndDelegate
        SubjectsTableView.dataSource = tableDataAndDelegate
        SubjectsTableView.rowHeight = 70.0
    }
    
    @IBAction func SettingsAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings Go Here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

class TableDataAndDelegate : NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var vc : ViewController?
    
    let subjects : [String] = ["Mathematics", "Marvel Super Heroes", "Science"]
    let subtitles : [String] = ["Test your math skills!", "Test your Marvel Super Hero Knowledge!", "Test your Science skills!"]
    let imagestest : [String] = ["brain", "person", "magnifyingglass"]

    /*
     UITableViewDataSource methods
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjects.count
    }

    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.item = \(indexPath.item)", "indexPath.row = \(indexPath.row)")
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "subjects", for: indexPath)
        cell.textLabel?.text = subjects[indexPath.row]
        cell.detailTextLabel?.text = subtitles[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "\(imagestest[indexPath.row])")
        
        return cell
    }
    
    /*
     UITableViewDelegate methods
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let alert = UIAlertController(title: "Selected!", message: "You selected \(subjects[indexPath.row])!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        vc!.present(alert, animated: true, completion: nil)
    }

}

