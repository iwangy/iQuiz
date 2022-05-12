//
//  FinishViewController.swift
//  iQuiz
//
//  Created by Ian Wang on 5/11/22.
//

import UIKit

class FinishViewController: UIViewController {

    @IBOutlet weak var resultsLabel: UILabel!
    var _data : String? = nil
    open var data : String? {
       get {
           return self._data
       }
       set(value) {
           self._data = value
       }
     }
    
    
    @IBAction func unwindSegue(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func changeLabel() {
        resultsLabel.text = "Cool! You got \(data!)"
    }
    
    func changeData(_ new: String){
        data = new
        changeLabel()
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
