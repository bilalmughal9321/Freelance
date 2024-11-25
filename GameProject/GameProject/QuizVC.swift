//
//  QuizVC.swift
//  GameProject
//
//  Created by Bilal Mughal on 24/11/2024.
//
import UIKit

struct Question {
    let questionText: String
    let options: [String]
    let correctAnswerIndex: Int
}

class QuizVC: UIViewController {

    // Outlets for the UI elements
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var optionButton1: UIButton!
    @IBOutlet weak var optionButton2: UIButton!
    @IBOutlet weak var optionButton3: UIButton!
    @IBOutlet weak var optionButton4: UIButton!

    private var currentQuestionIndex = 0
    private var score = 0

    // Array of questions
    private var questions: [Question] = []
    var selectedCategory: String? // Holds the selected category

    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedCategory ?? "Quiz"
        setupUI()
        loadQuestions()
        loadQuestion()
    }

    // Function to set up the buttons
    private func setupUI() {
        // Set button styles
        let buttons = [optionButton1, optionButton2, optionButton3, optionButton4]
        for button in buttons {
            button?.backgroundColor = .systemBlue
            button?.setTitleColor(.white, for: .normal)
            button?.layer.cornerRadius = 10
        }
    }

    // Load questions based on the selected category
    private func loadQuestions() {
        switch selectedCategory {
        case "Math":
            backgroundImage.image = UIImage(named: "game2")
            questions = [
                Question(questionText: "What is 2 + 2?", options: ["2", "3", "4", "5"], correctAnswerIndex: 2),
                Question(questionText: "What is 5 x 3?", options: ["15", "10", "20", "25"], correctAnswerIndex: 0)
            ]
        case "General Knowledge":
            backgroundImage.image = UIImage(named: "game3")
            questions = [
                Question(questionText: "What is the capital of France?", options: ["Berlin", "Madrid", "Paris", "Rome"], correctAnswerIndex: 2),
                Question(questionText: "Who wrote 'Hamlet'?", options: ["Shakespeare", "Dickens", "Homer", "Austen"], correctAnswerIndex: 0)
            ]
        case "Science":
            backgroundImage.image = UIImage(named: "game4")
            questions = [
                Question(questionText: "What planet is known as the Red Planet?", options: ["Earth", "Mars", "Venus", "Jupiter"], correctAnswerIndex: 1),
                Question(questionText: "What is H2O commonly known as?", options: ["Salt", "Water", "Oxygen", "Hydrogen"], correctAnswerIndex: 1),
                Question(questionText: "Which gas do plants absorb?", options: ["Oxygen", "Nitrogen", "Carbon Dioxide", "Hydrogen"], correctAnswerIndex: 2),
                Question(questionText: "What is the human body's largest organ?", options: ["Heart", "Liver", "Skin", "Brain"], correctAnswerIndex: 2),
                Question(questionText: "What is the speed of light?", options: ["300,000 km/s", "150,000 km/s", "100,000 km/s", "500,000 km/s"], correctAnswerIndex: 0)
            ]
        default:
            questions = []
        }
    }

    // Load the current question and set up the UI
    private func loadQuestion() {
        guard currentQuestionIndex < questions.count else { return }

        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.questionText

        // Set the option buttons' titles
        optionButton1.setTitle(currentQuestion.options[0], for: .normal)
        optionButton2.setTitle(currentQuestion.options[1], for: .normal)
        optionButton3.setTitle(currentQuestion.options[2], for: .normal)
        optionButton4.setTitle(currentQuestion.options[3], for: .normal)

        updateProgress()
    }

    // Update the progress bar as the user progresses through the quiz
    private func updateProgress() {
        progressView.progress = Float(currentQuestionIndex + 1) / Float(questions.count)
    }

    // Action for when an option is selected
    @IBAction func optionSelected(_ sender: UIButton) {
        // Find the index of the selected button
        var selectedIndex = -1
        if sender == optionButton1 {
            selectedIndex = 0
        } else if sender == optionButton2 {
            selectedIndex = 1
        } else if sender == optionButton3 {
            selectedIndex = 2
        } else if sender == optionButton4 {
            selectedIndex = 3
        }

        // Check if the answer is correct
        if selectedIndex == questions[currentQuestionIndex].correctAnswerIndex {
            score += 1
        }

        // Move to the next question or show the result
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            loadQuestion()
        } else {
            showResult()
        }
    }

    // Show the result when the quiz is over
    private func showResult() {        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "ResultVC") as? ResultVC {
            vc.score = score
            vc.totalQuestions = questions.count
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
