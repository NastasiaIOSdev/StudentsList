//
//  AddStudentsViewController.swift
//  StudentsList
//
//  Created by Анастасия Ларина on 07.05.2021.
//

import UIKit
import CoreData

class AddStudentsViewController: UIViewController {
    // MARK: - Properties
    var managedContext: NSManagedObjectContext!
    var list: List?
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(with:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        nameTextField.becomeFirstResponder()
        surnameTextField.becomeFirstResponder()
        scoreTextField.becomeFirstResponder()
        
        if let list = list {
            nameTextField.text = list.name
            nameTextField.text = list.name
            surnameTextField.text = list.surname
            surnameTextField.text = list.surname
            scoreTextField.text = list.score
            scoreTextField.text = list.score
        }
    }
    
    
    
    // MARK - Function
    
    @objc func keyboardWillShow(with notification: Notification) {
        let key = "UIKeyboardFrameEndUserInfoKey"
        guard let keyboardFrame = notification.userInfo?[key] as? NSValue else { return }
        
        let keyboardHeight = keyboardFrame.cgRectValue.height + 16
        
        bottonConstraint.constant = keyboardHeight
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
  
    fileprivate func dismissAndResign() {
        dismiss(animated: true)
        nameTextField.becomeFirstResponder()
        surnameTextField.becomeFirstResponder()
        scoreTextField.becomeFirstResponder()
    }
    
    // MARK: - IBActions
    
    @IBAction func name_act(_ sender: Any) {
        let text = nameTextField.text ?? ""
        if text.isValidName() {
            nameTextField.textColor = UIColor.black
            
        } else {
            
            let alertController = UIAlertController(title: "Ошибка в Имени!", message: "Имя содердить eng буквы без пробелов", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                print("")
            }
            alertController.addAction(yesAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func surname_act(_ sender: Any) {
        
        let text = surnameTextField.text ?? ""
        if text.isValidSurname() {
            scoreTextField.textColor = UIColor.black
        } else {
            
            let alertController = UIAlertController(title: "Ошибка в Фамилии!", message: "Фамилия содердить eng буквы без пробелов", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                print("")
            }
            alertController.addAction(yesAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func score_act(_ sender: Any) {
        let text = scoreTextField.text ?? ""
        
        if text.isValidScore() {
            scoreTextField.textColor = UIColor.black
            
        } else {
            
            let alertController = UIAlertController(title: "Ошибка в Среднем балле!", message: "Средний балл ученика - числа от 1 до 5", preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
                print("")
            }
            alertController.addAction(yesAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func cancel(_ sender: UIButton) {
        dismissAndResign()
    }
    
    @IBAction func done(_ sender: UIButton) {
       
        guard let name = nameTextField.text, !name.isEmpty else {
            return
        }
        guard let surname = surnameTextField.text, !surname.isEmpty else {
            return
        }
        guard let score = scoreTextField.text, !score.isEmpty else {
            return
        }
        
        if let list = self.list {
            list.name = name
            list.surname = surname
            list.score = score
        } else {
            let list = List(context: managedContext)
            list.name = name
            list.surname = surname
            list.score = score
            list.date = Date()
        }
        
        do {
            try managedContext.save()
            dismissAndResign()
        } catch {
            print("Error saving list: \(error)")
        }
    }
    
}

// MARK: - Extention

extension AddStudentsViewController: UITextViewDelegate {
    func textViewDidChangeSelection(_ textView: UITextView) {
        if doneButton.isHidden {
            nameTextField.text?.removeAll()
            surnameTextField.text?.removeAll()
            scoreTextField.text?.removeAll()
            // nameTextView.text.removeAll()
            nameTextField.textColor = .white
            surnameTextField.textColor = .white
            scoreTextField.textColor = .white
            
            doneButton.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension String {
    func isValidName() -> Bool {
        let inputRegEx = "^[a-zA-Z\\-_]{2,25}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@",  inputRegEx)
        return inputpred.evaluate(with: self)
    }
    func isValidSurname() -> Bool {
        
        let inputRegEx = "^[a-zA-Z\\-_]{2,25}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@",  inputRegEx)
        return inputpred.evaluate(with: self)
    }
    func isValidScore() -> Bool {
        let inputRegEx = "^[1-5]{1,1}$"
        let inputpred = NSPredicate(format: "SELF MATCHES %@",  inputRegEx)
        return inputpred.evaluate(with: self)
    }
}
