//
//  ViewController.swift
//  mathduel
//
//  Created by Clement Gan on 30/12/2024.
//

import UIKit

class ViewController: UIViewController {
    
    // UI Elements
    var questionLabel: UILabel!
    var player1ScoreLabel: UILabel!
    var player2ScoreLabel: UILabel!
    var answerTextField: UITextField!
    var submitButton: UIButton!
    var timerLabel: UILabel!
    
    let quitButton = UIButton()
    
    // Game Variables
    var player1Score = 0
    var player2Score = 0
    var currentPlayer = 1  // 1 for Player 1, 2 for Player 2
    var timer: Timer?
    var timeLeft = 20
    var currentQuestion: (question: String, answer: Int)?
    var isPlayer1Finished = false
    var isPlayer2Finished = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        setupUI()
        startNewRound()
    }
    
    func setupUI() {
        // Setup background image
        let backgroundImage = UIImage(named: "image_bg") // Add a background image to Assets
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = backgroundImage
        backgroundImageView.alpha = 0.2
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        // Top section container (question + score labels)
        let topSectionView = UIView()
        topSectionView.frame = CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: 140)
        topSectionView.backgroundColor = .white
        topSectionView.layer.cornerRadius = 10
        topSectionView.layer.shadowColor = UIColor.black.cgColor
        topSectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        topSectionView.layer.shadowOpacity = 0.1
        topSectionView.layer.shadowRadius = 5
        self.view.addSubview(topSectionView)
        
        // Set up question label inside the top section
        questionLabel = UILabel()
        questionLabel.frame = CGRect(x: 20, y: 10, width: topSectionView.frame.width - 40, height: 40)
        questionLabel.textAlignment = .center
        questionLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        topSectionView.addSubview(questionLabel)
        
        // Set up player 1 score label
        player1ScoreLabel = UILabel()
        player1ScoreLabel.frame = CGRect(x: 20, y: 60, width: 110, height: 40)
        player1ScoreLabel.text = "Player 1: 0"
        player1ScoreLabel.font = UIFont.systemFont(ofSize: 21)
        topSectionView.addSubview(player1ScoreLabel)
        
        // Set up player 2 score label
        player2ScoreLabel = UILabel()
        player2ScoreLabel.frame = CGRect(x: topSectionView.frame.width - 120, y: 60, width: 110, height: 40)
        player2ScoreLabel.text = "Player 2: 0"
        player2ScoreLabel.font = UIFont.systemFont(ofSize: 21)
        topSectionView.addSubview(player2ScoreLabel)
        
        // Center section container (answer textfield + submit button)
        let centerSectionView = UIView()
        centerSectionView.frame = CGRect(x: 20, y: 260, width: self.view.frame.width - 40, height: 160)
        centerSectionView.backgroundColor = .white
        centerSectionView.layer.cornerRadius = 10
        centerSectionView.layer.shadowColor = UIColor.black.cgColor
        centerSectionView.layer.shadowOffset = CGSize(width: 0, height: 2)
        centerSectionView.layer.shadowOpacity = 0.1
        centerSectionView.layer.shadowRadius = 5
        self.view.addSubview(centerSectionView)
        
        // Set up answer text field
        answerTextField = UITextField()
        answerTextField.frame = CGRect(x: 20, y: 20, width: centerSectionView.frame.width - 40, height: 40)
        answerTextField.placeholder = "Enter your answer"
        answerTextField.keyboardType = .numberPad
        answerTextField.borderStyle = .roundedRect
        centerSectionView.addSubview(answerTextField)
        
        // Set up submit button
        submitButton = UIButton(type: .system)
        submitButton.frame = CGRect(x: centerSectionView.frame.width / 2 - 50, y: 80, width: 100, height: 40)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.layer.cornerRadius = 20
        submitButton.layer.borderWidth = 2
        submitButton.layer.borderColor = UIColor.systemBlue.cgColor
        submitButton.setTitleColor(.systemOrange, for: .normal)
        styleButton(submitButton)
        submitButton.clipsToBounds = true
        submitButton.addTarget(self, action: #selector(submitAnswer), for: .touchUpInside)
        centerSectionView.addSubview(submitButton)
        
        // Set up timer label
        timerLabel = UILabel()
        timerLabel.frame = CGRect(x: self.view.frame.width / 2 - 50, y: 200, width: 100, height: 40)
        timerLabel.text = "Time: 20"
        timerLabel.textAlignment = .center
        self.view.addSubview(timerLabel)
        
        // Set up background color
        self.view.backgroundColor = .white
        
        // Quit Button (centered at bottom)
        quitButton.frame = CGRect(x: (view.frame.width - 100) / 2, y: view.frame.height - 100, width: 100, height: 50)
        quitButton.setTitle("Quit", for: .normal)
        styleButton(quitButton)
        quitButton.layer.cornerRadius = 25
        quitButton.clipsToBounds = true
        quitButton.addTarget(self, action: #selector(quitGame), for: .touchUpInside)
        view.addSubview(quitButton)
    }
    
    func styleButton(_ button: UIButton) {
        // Apply gradient background and white bold title to all buttons
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        
        // Apply gradient background
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [UIColor.blue.cgColor, UIColor.purple.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        button.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func startNewRound() {
        generateQuestion()
        timeLeft = 20
        updateTimerLabel()
        
        // Start the timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func generateQuestion() {
        // Generate a random math question
        let num1 = Int.random(in: 1...20)
        let num2 = Int.random(in: 1...20)
        let operation = Int.random(in: 0...20)
        
        if operation == 0 {
            // Addition
            currentQuestion = ("\(num1) + \(num2)", num1 + num2)
        } else {
            // Subtraction
            currentQuestion = ("\(num1) - \(num2)", num1 - num2)
        }
        print("\ncurrentQuestion:")
        print(currentQuestion)
        questionLabel.text = currentQuestion?.question
    }
    
    @objc func updateTimer() {
        timeLeft -= 1
        updateTimerLabel()
        
        if timeLeft <= 0 {
            if currentPlayer == 1 {
                // Time's up for Player 1, finish their turn and switch to Player 2
                isPlayer1Finished = true
                nextRound()
            } else if currentPlayer == 2 {
                // Time's up for Player 2, finish the game
                finishGame()
            }
        }
    }
    
    func updateTimerLabel() {
        timerLabel.text = "Time: \(timeLeft)"
    }
    
    @objc func submitAnswer() {
        guard let userAnswer = answerTextField.text, let answer = Int(userAnswer) else { return }
        print(answer)
        if answer == currentQuestion!.answer {
            // Correct answer
            if currentPlayer == 1 {
                player1Score += 1
                player1ScoreLabel.text = "Player 1: \(player1Score)"
            } else {
                player2Score += 1
                player2ScoreLabel.text = "Player 2: \(player2Score)"
            }
        }
        
        // Proceed to next round after submitting answer, only for Player 1
        if currentPlayer == 1 {
            // Player 1 finishes answering
            isPlayer1Finished = timeLeft <= 0 ? true : false
        }
        else {
            isPlayer2Finished = timeLeft <= 0 ? true : false
        }
        
        nextRound()
    }
    
    func nextRound() {
        // Switch to Player 2's round after Player 1 finishes
        if currentPlayer == 1 {
            if isPlayer1Finished == true {
                currentPlayer = 2
                isPlayer1Finished = false
                timeLeft = 20
                
                updateTimerLabel()
                generateQuestion()
                
                timer?.invalidate() // Invalidate Player 1's timer
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            }
            else {
                // proceed next question
                answerTextField.text = ""
                
                updateTimerLabel()
                generateQuestion()
            }
        }
        else if currentPlayer == 2 {
            // After Player 2 finishes, show the results
            if isPlayer2Finished == true {
                finishGame()
            }
            else {
                // proceed next question
                answerTextField.text = ""
                
                updateTimerLabel()
                generateQuestion()
            }
        }
    }
    
    @objc func quitGame() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // Save the score and current time into UserDefaults
            saveGameData()

            // Navigate back to the menu
            navigationController?.popToRootViewController(animated: true)
            
        }
    }
    
    func finishGame() {
        timer?.invalidate()
        
        let winner: String
        if player1Score > player2Score {
            winner = "Player 1 Wins!"
        } else if player2Score > player1Score {
            winner = "Player 2 Wins!"
        } else {
            winner = "It's a tie!"
        }
        
        // Save player scores and times to UserDefaults
        saveGameData()
        
        let alert = UIAlertController(title: "Game Over", message: winner, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart", style: .default, handler: { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                resetGame()
            }
        }))
        alert.addAction(UIAlertAction(title: "Exit", style: .cancel, handler: { _ in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                dismiss(animated: false)
                quitGame()
            }
        }))
        present(alert, animated: true)
    }
    
    func resetGame() {
        player1Score = 0
        player2Score = 0
        player1ScoreLabel.text = "Player 1: 0"
        player2ScoreLabel.text = "Player 2: 0"
        startNewRound()
    }

    func saveGameData() {
        UserDefaults.standard.set(player1Score, forKey: "Player1Score")
        UserDefaults.standard.set(player2Score, forKey: "Player2Score")
        UserDefaults.standard.set(timeLeft, forKey: "Player1Time")
        UserDefaults.standard.set(timeLeft, forKey: "Player2Time")
        
        // Save score history to UserDefaults
        saveScoreHistory()
    }
    
    func saveScoreHistory() {
        // Create a dictionary to store round, scores, and times
        let roundData: [String: Any] = [
            "round": (UserDefaults.standard.array(forKey: "ScoreHistory")?.count ?? 0) + 1,
            "player1Score": player1Score,
            "player2Score": player2Score,
            "player1Time": 20 - timeLeft,  // assuming timeLeft is the remaining time
            "player2Time": 20 - timeLeft   // assuming same for Player 2
        ]
        
        // Retrieve the existing score history from UserDefaults
        var currentHistory = UserDefaults.standard.array(forKey: "ScoreHistory") as? [[String: Any]] ?? []
        
        // Add the new round's data
        currentHistory.append(roundData)
        
        // Save it back to UserDefaults
        UserDefaults.standard.set(currentHistory, forKey: "ScoreHistory")
    }
    
}
