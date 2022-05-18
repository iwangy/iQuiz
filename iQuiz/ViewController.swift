//
//  ViewController.swift
//  iQuiz
//
//  Created by Ian Wang on 5/9/22.
//

import UIKit


struct Subject: Codable {
    var title: String
    var descrip: String
    var questions: [Question] = []
    
    init(subj: String, desc: String, question: [Question]?) {
        title = subj
        descrip = desc
        if (question != nil) {
            questions = question!
        }
    }
}

struct Question: Codable {
    var text: String
    var answer: String
    var answers: [String]
    init(text: String, answer: String, answers: [String]) {
        self.text = text
        self.answer = answer
        self.answers = answers
    }
}

class ViewController: UIViewController {
    var question: QuestionViewController? = nil
    var answer: AnswerViewController? = nil
    var finish: FinishViewController? = nil
    var tableDataAndDelegate = TableDataAndDelegate()
    var score = 0
    var curr = 0
    var urlString = UserDefaults.standard.string(forKey: "quizquestionsurl") ?? "https://tednewardsandbox.site44.com/questions.json"

    
    @IBOutlet weak var SubjectsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        if (SubjectsTableView != nil) {
            tableDataAndDelegate.vc = self
            SubjectsTableView.delegate = tableDataAndDelegate
            SubjectsTableView.dataSource = tableDataAndDelegate
            SubjectsTableView.rowHeight = 70.0
            getQuestions()
        } else {
            score = 0;
            buildQuestion()
            buildAnswer()
            buildFinish()
            switchViewController(nil, to: question)
        }
    }
    
    @IBAction func SettingsAlert(_ sender: Any) {
        let alert = UIAlertController(title: "Settings", message: "iQuiz Settings", preferredStyle: .alert)
        let confirmQuestions = UIAlertAction(title: "Enter", style: .default) { _ in
            self.urlString = (alert.textFields?[0].text)!
            UserDefaults.standard.set(self.urlString, forKey: "quizquestionsurl")
            self.getQuestions()
        }
        let checkQuestions = UIAlertAction(title: "Update Questions", style: .default) { _ in
            self.getQuestions()
            self.SubjectsTableView.reloadData()
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new URL to get questions from"
        }
        let cancelQuestions = UIAlertAction(title: "Cancel", style: .default) { _ in
        }
        alert.addAction(confirmQuestions)
        alert.addAction(checkQuestions)
        alert.addAction(cancelQuestions)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func getQuestions() {
        guard let url = URL.init(string: urlString) else {
            return
        }
        let session = URLSession.shared.dataTask(with: url) {data, response, error in
            if response != nil {
                if (response! as! HTTPURLResponse).statusCode != 200 {
                    let archiveURL = URL(fileURLWithPath: NSHomeDirectory() + "/Documents/scores.archive")
                    let readScores = NSArray(contentsOf: archiveURL)
                    TableDataAndDelegate.data = readScores as! [Subject]
                } else {
                    do {
                        TableDataAndDelegate.data = []
                        let questions =  try JSONSerialization.jsonObject(with: data!) as! NSArray
                        DispatchQueue.main.async {
                            for i in 0..<questions.count {
                                let object = questions[i] as! NSDictionary
                                let objectQuestions = object["questions"]! as! NSArray
                                var QuestionArray : [Question] = []
                                for i in 0..<objectQuestions.count {
                                    let oneQuestion = objectQuestions[i] as! NSDictionary
                                    QuestionArray.append(
                                        Question(
                                            text: oneQuestion["text"] as! String,
                                            answer: oneQuestion["answer"] as! String,
                                            answers: oneQuestion["answers"] as! [String]
                                        )
                                    )
                                }
                                TableDataAndDelegate.data.append(Subject(
                                    subj: object["title"]! as! String,
                                    desc: object["desc"]! as! String,
                                    question: QuestionArray
                                ))
                            }
                            self.SubjectsTableView.reloadData()
                            print(TableDataAndDelegate.data)
                            print(self.urlString)
                            
                            // UNSURE IF DATA ACTUALLY SAVES
                            let archivePath = NSHomeDirectory() + "/Documents/quizzes.archive"
                            print(archivePath)
                            let quizArchive = TableDataAndDelegate.data as NSArray
                            print(quizArchive)
                            quizArchive.write(toFile: archivePath, atomically: true)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            print("something went wrong")
                            self.showError()
                        }
                    }
                }
            }
        }
        session.resume()
    }
   
    fileprivate func showError() {
        let alertController = UIAlertController(title: "Uh-Oh! Something went wrong", message: "Please check your url and make sure your network is available", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
        }
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
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
            if (question?.selectedAnswer?.titleLabel?.text == TableDataAndDelegate.selected![curr - 1].answers[Int(TableDataAndDelegate.selected![curr - 1].answer)! - 1]) {
                score += 1
                NSLog("score");
                answer!.changeData("Correct!")
            } else {
                answer!.changeData("Incorrect. \n The correct answer is \(TableDataAndDelegate.selected![curr - 1].answers[Int(TableDataAndDelegate.selected![curr - 1].answer)! - 1])")
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
    static var data: [Subject] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableDataAndDelegate.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.item = \(indexPath.item)", "indexPath.row = \(indexPath.row)")
        //BUG HERE
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "subjects", for: indexPath)
        cell.textLabel?.text = TableDataAndDelegate.data[indexPath.row].title
        cell.detailTextLabel?.text = TableDataAndDelegate.data[indexPath.row].descrip
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        TableDataAndDelegate.selected = TableDataAndDelegate.data[indexPath.row].questions
        return indexPath
    }

}

