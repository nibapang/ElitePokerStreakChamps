//
//  BijiViewController.swift
//  PokerStreakChamps
//
//  Created by PokerStreakChamps on 2025/3/7.
//


import UIKit

@available(iOS 13.0, *)
class BijiViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var targetLabel: UILabel!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var attemptsLabel: UILabel!
    
    // Add button outlets (connect these in storyboard)
    @IBOutlet private var numberButtons: [UIButton]! // Connect all 10 buttons to this outlet collection
    
    // MARK: - Properties
    private var targetNumber: Int = 0
    private var selectedNumbers: [Int] = []
    private var score: Int = 0
    private var attempts: Int = 0
    private let maxAttempts: Int = 3
    private var timer: Timer?
    private var timeRemaining: Int = 30
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        scoreLabel.text = "0"
        startNewGame()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        setupButtons()
        setupInitialUI()
    }
    
    private func setupInitialUI() {
        updateAttemptsLabel()
    }
    
    private func setupButtons() {
        // Configure each button
        for (index, button) in numberButtons.enumerated() {
            let number = index + 1
            
            // Set card image
            let cardImage = UIImage(named: "\(number)")
            button.setImage(cardImage, for: .normal)
            
//            // Button styling
//            button.backgroundColor = .white
//            button.layer.cornerRadius = 8
//            button.layer.borderWidth = 2
//            button.layer.borderColor = UIColor.systemGray5.cgColor
//            button.imageView?.contentMode = .scaleAspectFit
//            button.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            
//            // Shadow effect
//            button.layer.shadowColor = UIColor.black.cgColor
//            button.layer.shadowOffset = CGSize(width: 0, height: 2)
//            button.layer.shadowRadius = 4
//            button.layer.shadowOpacity = 0.2
            
            button.tag = number // Store the number in the button's tag
            button.addTarget(self, action: #selector(numberButtonTapped(_:)), for: .touchUpInside)
        }
    }
    
    // MARK: - Button Actions
    @objc private func numberButtonTapped(_ sender: UIButton) {
        let number = sender.tag
        
        if sender.isSelected {
            // Deselect the button
            sender.isSelected = false
            sender.alpha = 1.0  // Reset opacity
            if let index = selectedNumbers.firstIndex(of: number) {
                selectedNumbers.remove(at: index)
            }
        } else {
            // Select the button
            sender.isSelected = true
            sender.alpha = 0.5  // Make semi-transparent when selected
            
            selectedNumbers.append(number)
            checkFactors(for: number)
        }
    }
    
    // MARK: - Game Logic
    private func startNewGame() {
        attempts = 0
        score = 0
        scoreLabel.text = "0"
        targetNumber = Int.random(in: 12...60)
        targetLabel.text = "\(targetNumber)"
        selectedNumbers.removeAll()
        resetButtons()
        startTimer()
        updateAttemptsLabel()
    }
    
    private func startNewRound() {
        attempts = 0
        targetNumber = Int.random(in: 12...60)
        targetLabel.text = "\(targetNumber)"
        selectedNumbers.removeAll()
        resetButtons()
        startTimer()
        updateAttemptsLabel()
    }
    
    private func resetButtons() {
        for button in numberButtons {
            button.isSelected = false
            button.alpha = 1.0  // Reset opacity
        }
    }
    
    private func checkFactors(for number: Int) {
        let isCorrectFactor = targetNumber % number == 0
        
        if !isCorrectFactor {
            attempts += 1
            updateAttemptsLabel()
            
            // Deselect only the wrong button
            if let button = numberButtons.first(where: { $0.tag == number }) {
                button.isSelected = false
                button.alpha = 1.0  // Reset opacity
            }
            selectedNumbers.removeAll { $0 == number }
            
            if attempts >= maxAttempts {
                showLoseAlert()
            }
        } else {
            score += 10
            scoreLabel.text = "\(score)"
            
            let allFactors = (1...10).filter { targetNumber % $0 == 0 }
            let foundAllFactors = Set(selectedNumbers).isSuperset(of: Set(allFactors))
            
            if foundAllFactors {
                showWinAlert()
            }
        }
    }
    
    // MARK: - Timer Methods
    private func startTimer() {
        timer?.invalidate()
        timeRemaining = 30
        updateTimerUI()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.updateTimerUI()
        }
    }
    
    private func updateTimerUI() {
        timerLabel.text = "⏱ \(timeRemaining)s"
        
        if timeRemaining <= 10 {
            timerLabel.textColor = .systemRed
        } else if timeRemaining <= 20 {
            timerLabel.textColor = .systemOrange
        } else {
            timerLabel.textColor = .systemGreen
        }
        
        if timeRemaining <= 0 {
            timer?.invalidate()
            showTimeOverAlert()
        }
    }
    
    private func updateAttemptsLabel() {
        let remainingAttempts = maxAttempts - attempts
        attemptsLabel.text = "\(remainingAttempts)"
        
        if remainingAttempts == 1 {
            attemptsLabel.textColor = .white
        } else if remainingAttempts == 2 {
            attemptsLabel.textColor = .white
        } else {
            attemptsLabel.textColor = .white
        }
    }
    
    // MARK: - Alert Methods
    private func showWinAlert() {
        timer?.invalidate()
        let alert = CustomAlertViewController(title: "Congratulations! 🎉",
                                              message: "You found all factors!\nScore: \(score)") { [weak self] in
        
       // alert.addAction(UIAlertAction(title: "Next Round", style: .default) { [weak self] _ in
            self?.startNewRound()
        }
        
        present(alert, animated: true)
    }
    
    private func showLoseAlert() {
        timer?.invalidate()
        let allFactors = (1...10).filter { targetNumber % $0 == 0 }
        let alert = UIAlertController(title: "Game Over 😢",
                                    message: "You've run out of attempts!\nThe factors were: \(allFactors.sorted())\nFinal Score: \(score)",
                                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "New Game", style: .default) { [weak self] _ in
            self?.startNewGame()
        })
        
        present(alert, animated: true)
    }
    
    private func showTimeOverAlert() {
        let allFactors = (1...10).filter { targetNumber % $0 == 0 }
        let alert = UIAlertController(title: "Time's Up! ⏰",
                                    message: "You ran out of time!\nThe factors were: \(allFactors.sorted())\nFinal Score: \(score)",
                                    preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
            self?.startNewGame()
        })
        
        alert.addAction(UIAlertAction(title: "Share Score", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.shareScore()
        })
        
        present(alert, animated: true)
    }
    
    private func shareScore() {
        let scoreText = "I scored \(score) points in Factor Poker! Can you beat my score? 🎮"
        let activityViewController = UIActivityViewController(activityItems: [scoreText], applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(activityViewController, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
       
    }
}
