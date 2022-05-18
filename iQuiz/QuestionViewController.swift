//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Ian Wang on 5/11/22.
//

import UIKit

class QuestionViewController: UIViewController {

    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerOptions: [UIButton]!
    var selectedAnswer: UIButton? = nil
    
    var _data : Question? = nil
          open var data : Question? {
            get { return self._data }
            set(value) {
                self._data = value
            }
          }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedAnswer = nil
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectedButton(_ sender: UIButton) {
        sender.backgroundColor = UIColor.lightGray
        if (selectedAnswer != nil) {
            selectedAnswer!.backgroundColor = UIColor.white
        }
        selectedAnswer = sender
    }
    
    func changeLabel() {
        questionLabel.text = data!.text
        for i in 0...data!.answers.count - 1 {
            answerOptions[i].setTitle(data?.answers[i], for: .normal)
        }

    }
    
    func changeData(_ new: Question) {
            for op in answerOptions {
                op.backgroundColor = UIColor.white
            }
            selectedAnswer = nil
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
