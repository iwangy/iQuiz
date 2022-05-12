//
//  ViewController.swift
//  iQuiz
//
//  Created by Ian Wang on 5/9/22.
//

import UIKit


class Subject {
    var title: String
    var descrip: String
    var image: String
    var questions: [Question] = []
    
    
    init(subj: String, desc: String, img: String, question: [Question]?) {
        title = subj
        descrip = desc
        image = img
        
        if (question != nil) {
            questions = question!
        }
    }
}

class Question {
    var q: String
    var c1: String
    var c2: String
    var c3: String
    var achoice: String
    
    init(question: String, answer: String, option1: String, option2: String, option3: String) {
        q = question
        achoice = answer
        c1 = option1
        c2 = option2
        c3 = option3
    }
}

class ViewController: UIViewController {
    var question: QuestionViewController? = nil
    var answer: AnswerViewController? = nil
    var finish: FinishViewController? = nil
    var tableDataAndDelegate = TableDataAndDelegate()
    var score = 0
    var curr = 0
   
    @IBOutlet weak var SubjectsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (SubjectsTableView != nil) {
            tableDataAndDelegate.vc = self
            SubjectsTableView.delegate = tableDataAndDelegate
            SubjectsTableView.dataSource = tableDataAndDelegate
            SubjectsTableView.rowHeight = 70.0
        } else {
            score = 0;
            buildQuestion()
            buildAnswer()
            buildFinish()
            switchViewController(nil, to: question)
        }
        
    }
    
    @IBAction func SettingsAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "Settings Go Here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    @IBOutlet weak var SubmitButton: UIButton!
    @IBAction func nextSwitch(_ sender: Any) {
        buildQuestion()
        buildAnswer()
        buildFinish()
        
        UIView.beginAnimations("View Flip", context: nil)
        UIView.setAnimationDuration(0.4)
        UIView.setAnimationCurve(.easeInOut)
        
        
        if question != nil &&
            question!.view.superview != nil {
            UIView.setAnimationTransition(.flipFromRight, for: view, cache: true)
            answer!.view.frame = view.frame
            SubmitButton.setTitle("Next", for: .normal)
            switchViewController(question, to: answer)
            if (question?.selectedAnswer?.titleLabel?.text == TableDataAndDelegate.selected![curr - 1].achoice) {
                score += 1
                NSLog("score");
                answer!.changeData("Correct!")
            } else {
                answer!.changeData("Incorrect. The correct answer is \(TableDataAndDelegate.selected![curr - 1].achoice)")
            }
        }
        else {
            UIView.setAnimationTransition(.flipFromLeft, for: view, cache: true)
            if (TableDataAndDelegate.selected!.count == curr) {
                finish!.view.frame = view.frame
                SubmitButton.isHidden = true;
                switchViewController(answer, to: finish)
                curr = 0
            } else {
                question!.view.frame = view.frame
                SubmitButton.setTitle("Submit", for: .normal)
                switchViewController(answer, to: question)
            }
        }
        UIView.commitAnimations()
    }
    
    fileprivate func switchViewController(_ from: UIViewController?, to: UIViewController?) {
            if from != nil {
                from!.willMove(toParent: nil)
                from!.view.removeFromSuperview()
                from!.removeFromParent()
            }
            
            if to != nil {
                self.addChild(to!)
                self.view.insertSubview(to!.view, at: 0)
                to!.didMove(toParent: self)
                if (to == question) {
                    question!.changeData(TableDataAndDelegate.selected![curr])
                    curr += 1
                } else if (to == finish && finish != nil) {
                        finish!.changeData("\(String(score)) out of \(String(TableDataAndDelegate.selected!.count))")
                }
            }
        }
     
    fileprivate func buildAnswer() {
        if answer == nil {
            answer = storyboard?.instantiateViewController(identifier: "answer") as? AnswerViewController
            answer!.data = "Incorrect!"
        }
    }
    
    fileprivate func buildQuestion() {
        if question == nil {
            question = storyboard?.instantiateViewController(identifier: "question") as? QuestionViewController
            question!.data = TableDataAndDelegate.selected![curr]
        }
    }
    
    fileprivate func buildFinish() {
        if finish == nil {
            finish = storyboard?.instantiateViewController(identifier: "finish") as? FinishViewController
            finish!.data = "\(String(score)) out of \(String(TableDataAndDelegate.selected!.count))"
        }
    }
}




class TableDataAndDelegate : NSObject, UITableViewDataSource, UITableViewDelegate {
    weak var vc : ViewController?
    static var selected: [Question]? = nil

    static let data: [Subject] = [
        Subject(subj: "Mathematics", desc: "Test your math skills!", img: "brain", question: [Question(question: "Math Test", answer: "One", option1: "Two", option2: "Three", option3: "Four")]),
        Subject(subj: "Marvel Super Heroes", desc: "Test your Marvel Super Hero Knowledge!", img: "person", question: [Question(question: "Marvel Test", answer: "One", option1: "Two", option2: "Three", option3: "Four")]),
        Subject(subj: "Science", desc: "Test your Science skills", img: "magnifyingglass", question: [Question(question: "Science Test", answer: "One", option1: "Two", option2: "Three", option3: "Four"), Question(question: "SECOND TEST", answer: "TWO", option1: "THREE", option2: "ONE", option3: "FOUR")])
    ]


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableDataAndDelegate.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.item = \(indexPath.item)", "indexPath.row = \(indexPath.row)")
        
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "subjects", for: indexPath)
        cell.textLabel?.text = TableDataAndDelegate.data[indexPath.row].title
        cell.detailTextLabel?.text = TableDataAndDelegate.data[indexPath.row].descrip
        cell.imageView?.image = UIImage(systemName: "\(TableDataAndDelegate.data[indexPath.row].image)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        let alert = UIAlertController(title: "Selected!", message: "You selected \(TableDataAndDelegate.data[indexPath.row].title)!", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
//        vc!.present(alert, animated: true, completion: nil)
        
        TableDataAndDelegate.selected = TableDataAndDelegate.data[indexPath.row].questions
        
        return indexPath
    }

}

