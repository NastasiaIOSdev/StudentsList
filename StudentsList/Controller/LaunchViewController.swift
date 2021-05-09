//
//  LaunchViewController.swift
//  StudentsList
//
//  Created by Анастасия Ларина on 08.05.2021.
//

import UIKit

class LaunchViewController: UIViewController {

        @IBOutlet weak var label: UILabel!
        @IBOutlet weak var bg: UIImageView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        bg.loadGif(name: "gif")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }
   
    private func animate() {
        let duration = 0.75
        label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(
            withDuration: duration * 7,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 0,
            options: [],
            animations: {
                self.label.transform = .identity
            },
            completion: { finished in
                guard finished else { return }
                self.home()

            })
    }
    
    private func home() {
        performSegue(withIdentifier: "Home", sender: nil)
    }
    
  
}
