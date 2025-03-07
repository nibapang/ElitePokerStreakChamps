//
//  SplashViewController.swift
//  PokerStreakChamps
//
//  Created by PokerStreakChamps on 2025/3/7.
//


import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var loadingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initial setup for progress view
        progressView.progress = 0.0
        progressView.trackTintColor = .lightGray
        progressView.progressTintColor = .red
        
        // Set progress view height
       // progressView.transform = progressView.transform.scaledBy(x: 1.0, y: 1.0) // Makes it 4 times taller (default height is 2-3 points)
        progressView.progressImage = UIImage(named: "loading")
        progressView.frame.size.height = 20
        // OR
      
        // Start the loading simulation
        simulateLoading()
    }

    private func simulateLoading() {
        var progress: Float = 0.0
        
        // Timer to simulate progress
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            progress += 0.01
            self.progressView.setProgress(progress, animated: true)
            
            if progress >= 1.0 {
                timer.invalidate()
                self.navigateToHome()
            }
        }
    }

    private func navigateToHome() {
        // Navigate to HomeViewController
//        let homeVC = (self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController)!
//             navigationController?.pushViewController(homeVC, animated: true)
    }
}
