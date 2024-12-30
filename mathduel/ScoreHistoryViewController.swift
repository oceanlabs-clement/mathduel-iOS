//
//  ScoreHistoryViewController.swift
//  mathduel
//
//  Created by Clement Gan on 30/12/2024.
//

import UIKit

class ScoreHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Table view to display score history
    var tableView: UITableView!
    
    // History data model to hold scores and times
    var scoreHistory: [(round: Int, player1Score: Int, player2Score: Int, player1Time: Int, player2Time: Int)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Score History"
        view.backgroundColor = .white
        
        // Load score history data from UserDefaults
        loadScoreHistory()
        
        // Set up the table view
        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
    }
    
    // Load score history from UserDefaults
    func loadScoreHistory() {
        if let savedHistory = UserDefaults.standard.array(forKey: "ScoreHistory") as? [[String: Any]] {
            for entry in savedHistory {
                if let round = entry["round"] as? Int,
                   let player1Score = entry["player1Score"] as? Int,
                   let player2Score = entry["player2Score"] as? Int,
                   let player1Time = entry["player1Time"] as? Int,
                   let player2Time = entry["player2Time"] as? Int {
                    scoreHistory.append((round, player1Score, player2Score, player1Time, player2Time))
                }
            }
        }
    }
    
    // TableView DataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        
        let history = scoreHistory[indexPath.row]
        cell.textLabel?.text = "Round \(history.round) - P1: \(history.player1Score) (\(history.player1Time)s) | P2: \(history.player2Score) (\(history.player2Time)s)"
        
        return cell
    }
    
    // TableView Delegate method to handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

