//
//  AboutViewController.swift
//  PokerStreakChamps
//
//  Created by PokerStreakChamps on 2025/3/7.
//


import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        //        dismiss(animated: true)
    }

}
