//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Ian Wang on 5/11/22.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var answerLabel: UILabel!
    
    var _data : String? = nil
              open var data : String? {
                get { return self._data }
                set(value) {
                    self._data = value
                }
              }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func changeLabel() {
            answerLabel.text = data!
    }
        
    func changeData(_ new: String) {
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
