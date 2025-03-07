//
//  GameViewController.swift
//  PokerStreakChamps
//
//  Created by PokerStreakChamps on 2025/3/7.
//


import UIKit

class GameViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var gridView: UIView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var movesLabel: UILabel!

    // MARK: - Properties
    private let gridSize = 8
    private var cellSize: CGFloat = 60
    private var cells: [[UILabel]] = []
    private let suits = ["♠️", "♣️", "♥️", "♦️"]
    private var score = 0
    private var movesLeft = 30 // Game over after 30 moves

    override func viewDidLoad() {
        super.viewDidLoad()

        setupGrid()
        setupInitialLabels()
        populateGrid()
        addSwipeGestures()
    }

    private func setupGrid() {
        let availableWidth = gridView.bounds.width
        let availableHeight = gridView.bounds.height
        
        // Use the smaller dimension to ensure square cells and proper fit
        cellSize = min(availableWidth, availableHeight) / CGFloat(gridSize)
        
        // Center the grid view itself if needed
        gridView.layer.cornerRadius = 10
        gridView.clipsToBounds = true
        gridView.backgroundColor = .clear
    }

    private func setupInitialLabels() {
        scoreLabel.text = "0"


        movesLabel.text = "\(movesLeft)"
    }

    private func populateGrid() {
        // Calculate total grid dimensions
        let totalWidth = CGFloat(gridSize) * cellSize
        let totalHeight = CGFloat(gridSize) * cellSize
        
        // Calculate starting points to center the grid
        let startX = (gridView.bounds.width - totalWidth) / 2
        let startY = (gridView.bounds.height - totalHeight) / 2
        
        // Clear existing cells if any
        cells.forEach { row in
            row.forEach { $0.removeFromSuperview() }
        }
        cells.removeAll()
        
        for row in 0..<gridSize {
            var rowCells: [UILabel] = []
            for col in 0..<gridSize {
                let cell = createCell()
                
                // Position each cell with proper centering
                let x = startX + CGFloat(col) * cellSize+15
                let y = startY + CGFloat(row) * cellSize+20
                
                cell.frame = CGRect(x: x, y: y, width: cellSize, height: cellSize)
                cell.text = suits.randomElement()
                gridView.addSubview(cell)
                rowCells.append(cell)
            }
            cells.append(rowCells)
        }
        
        // Add a container view to help with visual centering
        let containerView = UIView(frame: CGRect(x: startX, y: startY, width: totalWidth, height: totalHeight))
        containerView.backgroundColor = .clear
     //   containerView.layer.borderWidth = 2
      //  containerView.layer.borderColor = UIColor.purple.cgColor
        containerView.layer.cornerRadius = 10
        gridView.insertSubview(containerView, at: 0)
    }

    private func createCell() -> UILabel {
        let cell = UILabel()
        cell.backgroundColor = .white
        cell.textAlignment = .center
        cell.font = .systemFont(ofSize: 20)
        cell.isUserInteractionEnabled = true
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.clipsToBounds = true
        return cell
    }

    private func addSwipeGestures() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]

        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
            gesture.direction = direction
            gridView.addGestureRecognizer(gesture)
        }
    }

    @objc private func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        let location = gesture.location(in: gridView)
        let row = Int(location.y / cellSize)
        let col = Int(location.x / cellSize)

        guard row >= 0 && row < gridSize && col >= 0 && col < gridSize else { return }

        var newRow = row
        var newCol = col

        switch gesture.direction {
        case .right: newCol = min(col + 1, gridSize - 1)
        case .left: newCol = max(col - 1, 0)
        case .down: newRow = min(row + 1, gridSize - 1)
        case .up: newRow = max(row - 1, 0)
        default: break
        }

        swapCells(row1: row, col1: col, row2: newRow, col2: newCol)
        checkMatches()
    }

    private func swapCells(row1: Int, col1: Int, row2: Int, col2: Int) {
        let cell1 = cells[row1][col1]
        let cell2 = cells[row2][col2]

        // Only swap if cells are different
        guard cell1 !== cell2 else { return }

        // Store original positions
        let cell1Frame = cell1.frame
        let cell2Frame = cell2.frame

        UIView.animate(withDuration: 0.3) {
            // Only animate position, not the content
            cell1.frame = cell2Frame
            cell2.frame = cell1Frame
        }

        // Update the cells array
        cells[row1][col1] = cell2
        cells[row2][col2] = cell1

        movesLeft -= 1
        movesLabel.text = "\(movesLeft)"

        if movesLeft <= 0 {
            gameOver()
        }
    }

    private func checkMatches() {
        var matchFound = false

        // Check horizontal matches
        for row in 0..<gridSize {
            for col in 0..<(gridSize - 3) {
                let suit = cells[row][col].text
                if suit == cells[row][col + 1].text &&
                    suit == cells[row][col + 2].text &&
                    suit == cells[row][col + 3].text {
                    matchFound = true
                    // Animate and remove matched suits
                    animateMatch(row: row, col: col, isHorizontal: true)
                }
            }
        }

        // Check vertical matches
        for col in 0..<gridSize {
            for row in 0..<(gridSize - 3) {
                let suit = cells[row][col].text
                if suit == cells[row + 1][col].text &&
                    suit == cells[row + 2][col].text &&
                    suit == cells[row + 3][col].text {
                    matchFound = true
                    // Animate and remove matched suits
                    animateMatch(row: row, col: col, isHorizontal: false)
                }
            }
        }

        if matchFound {
            score += 100
            scoreLabel.text = "\(score)"

            // Add bonus moves when score exceeds 1500
            if score >= 1500 && score - 100 < 1500 {  // Check if we just crossed 1500
                movesLeft += 10
                movesLabel.text = "\(movesLeft)"

                // Show bonus moves notification
                let alert = UIAlertController(title: "Bonus!",
                                            message: "You've earned 10 extra moves!",
                                            preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.applyGravity()
            }
        }
    }

    private func animateMatch(row: Int, col: Int, isHorizontal: Bool) {
        for i in 0...3 {
            let cell = isHorizontal ? cells[row][col + i] : cells[row + i][col]

            // First scale up and highlight
            UIView.animate(withDuration: 0.2, animations: {
                cell.backgroundColor = .yellow
                cell.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                // Then scale down and fade out
                UIView.animate(withDuration: 0.3, animations: {
                    cell.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
                    cell.alpha = 0
                }) { _ in
                    // Reset the cell with new suit
                    cell.transform = .identity
                    cell.alpha = 1
                    cell.backgroundColor = .white
                    cell.text = self.suits.randomElement()
                }
            }
        }
    }

    private func applyGravity() {
        for col in 0..<gridSize {
            for row in (0..<gridSize).reversed() {
                if cells[row][col].text == nil {
                    // Find the first non-empty cell above
                    var sourceRow = row - 1
                    while sourceRow >= 0 && cells[sourceRow][col].text == nil {
                        sourceRow -= 1
                    }

                    if sourceRow >= 0 {
                        let fallingCell = cells[sourceRow][col]
                        let targetCell = cells[row][col]

                        // Animate falling with bounce effect
                        UIView.animate(withDuration: 0.5,
                                     delay: 0,
                                     usingSpringWithDamping: 0.7,
                                     initialSpringVelocity: 0.7) {
                            fallingCell.frame = targetCell.frame
                        }

                        // Update the cells array
                        cells[row][col] = fallingCell

                        // Animate new cell dropping from top
                        cells[sourceRow][col].text = suits.randomElement()
                        cells[sourceRow][col].alpha = 0
                        UIView.animate(withDuration: 0.3) { [self] in
                            cells[sourceRow][col].alpha = 1
                        }
                    }
                }
            }
        }

        // Check for new matches after gravity
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.checkMatches()
        }
    }

    private func gameOver() {
        let alert = UIAlertController(title: "Game Over!",
                                    message: "Final Score: \(score)",
                                    preferredStyle: .alert)

        let restartAction = UIAlertAction(title: "Play Again", style: .default) { [weak self] _ in
            self?.resetGame()
        }

        alert.addAction(restartAction)
        present(alert, animated: true)
    }


    private func resetGame() {
        score = 0
        movesLeft = 30
        scoreLabel.text = "0"
        movesLabel.text = "\(movesLeft)"

        // Clear and repopulate the grid
        for row in cells {
            for cell in row {
                cell.removeFromSuperview()
            }
        }
        cells.removeAll()
        populateGrid()
    }

    @IBAction func backbtn( _ : UIButton)
    {
        navigationController?.popViewController(animated: true)
    }
}
