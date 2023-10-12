//
//  WelcomeViewController.swift
//  Only Transfer
//
//  Created by Rohit Singh Dhakad on 12/01/23.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    var counter = 3
    var timer:Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateCounter() {
        //example functionality
        if counter > 0 {
            print("\(counter) seconds to the end of the world")
            counter -= 1
        }else{
            self.timer?.invalidate()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

}
