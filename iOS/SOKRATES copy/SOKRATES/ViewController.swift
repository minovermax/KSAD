//
//  ViewController.swift
//  SOKRATES
//
//  Created by 이성민 on 10/15/19.
//  Copyright © 2019 KSAD. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    // MARK: - App Default Values Setup
    
    var internetConnected = true
    var lastRandNumInspiring = -1
    var lastRandNumEmpowering = -1
    var lastRandNumMotivating = -1
    
    // DO NOT TOUCH - function for loading view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let quoteVC = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "quote") {
            quoteLabel.text = quoteVC as? String
        }
        
        if let authorVC = UserDefaults(suiteName: "group.com.ksad.sokrates")?.value(forKey: "author") {
            authorLabel.text = authorVC as? String
        }
        if quoteLabel.text != "SOKRATES" {
            self.quoteLabel.font = UIFont(name:"Futura-Medium", size: 24.0)
        }
        
        // check internet connection
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { pathUpdateHandler in
            if pathUpdateHandler.status == .satisfied {
                print("internet available")
                self.internetConnected = true
            } else {
                print("internet unavailable")
                self.internetConnected = false
            }
        }
        
        let queue = DispatchQueue(label: "InternetConnectionMonitor")
        monitor.start(queue: queue)
        
        
    } // NEVER TOUCH
    
    
    // MARK: - Label & Button Setup
    
    // connecting labels
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // connecting buttons
    @IBAction func setInspiringQuoteButton(_ sender: Any) {
        if internetConnected == true {
            setInspiringQuote()
        } else if internetConnected == false {
            showNoInternetAlert()
        }
    }
    
    @IBAction func setEmpoweringQuoteButton(_ sender: Any) {
        if internetConnected == true {
            setEmpoweringQuote()
        } else if internetConnected == false {
            showNoInternetAlert()
        }
    }
    
    @IBAction func setMotivatingQuoteButton(_ sender: Any) {
        if internetConnected == true {
            setMotivatingQuote()
        } else if internetConnected == false {
            showNoInternetAlert()
        }
    }
    
    // MARK: - Internet Connection
    // function for UIAlert when no Internet connection
    func showNoInternetAlert () {
        
        let alert = UIAlertController(title: "No Internet Connection", message: "Internet is required to connect to our quote database.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Setting UILabels
    
    // function for inspiring quote [blinking star emoji]
    func setInspiringQuote () {
        
        // URL of the JSON file of KSAD database
        let jsonUrlString = "http://ksad.000webhostapp.com/serviceInspiring.php"
        // making an URL object
        guard let url = URL(string: jsonUrlString) else { return }
                
        
        // parsing 'inspiring' JSON file with Decodable
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
            guard let data = data else { return }
                    
            do {
                        
                let fullQuote = try JSONDecoder().decode([FullQuote].self, from: data)
                
                print(type(of: fullQuote))
                
                // random integer between 0 and the number of quotes in database
                var randomQuote = Int.random(in: 0 ..< fullQuote.count)
                
                while (randomQuote == self.lastRandNumInspiring) {
                    randomQuote = Int.random(in: 0 ..< fullQuote.count)
                }
                
                self.lastRandNumInspiring = randomQuote
                
                print(randomQuote)

                // IB referencing here (Use Main Thread Checker)
                DispatchQueue.main.async {
                    
                    // add animations
                    self.quoteLabel.fadeTransition(0.2)
                    self.authorLabel.fadeTransition(0.2)
                    
                    // alter font and font size
                    self.quoteLabel.font = UIFont(name:"Futura-Medium", size: 24.0)
                    
                    // get random quote and corresponding author
                    let insertedQuote = fullQuote[randomQuote].quote
                    let insertedAuthor = fullQuote[randomQuote].author
                                       
                    // string concatenation
                    self.quoteLabel.text = "\"" + insertedQuote + "\""
                    self.authorLabel.text = "- " + insertedAuthor
                    
                    // put in UserDefaults for the TodayExtension
                    UserDefaults.init(suiteName: "group.com.ksad.sokrates")?.setValue(self.quoteLabel.text, forKey: "quote")
                    UserDefaults.init(suiteName: "group.com.ksad.sokrates")?.setValue(self.authorLabel.text, forKey: "author")
                }
                
            
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
                    
        }.resume()
    }
    
    // function for empowering quote [muscle emoji]
    func setEmpoweringQuote () {
        
        // URL of the 'empowering' JSON file of KSAD database
        let jsonUrlString = "http://ksad.000webhostapp.com/serviceEmpowering.php"
        // making an URL object
        guard let url = URL(string: jsonUrlString) else { return }
                
        
        // parsing JSON file with Decodable
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
            guard let data = data else { return }
                    
            do {
                        
                let fullQuote = try JSONDecoder().decode([FullQuote].self, from: data)
                
                // random integer between 0 and the number of quotes in database
                var randomQuote = Int.random(in: 0 ..< fullQuote.count)
                
                while (randomQuote == self.lastRandNumEmpowering) {
                    randomQuote = Int.random(in: 0 ..< fullQuote.count)
                }
                
                self.lastRandNumEmpowering = randomQuote
                
                print(randomQuote)

                
                // IB referencing here (Use Main Thread Checker)
                DispatchQueue.main.async {
                    
                    // add animations
                    self.quoteLabel.fadeTransition(0.2)
                    self.authorLabel.fadeTransition(0.2)
                    
                    // alter font size
                    self.quoteLabel.font = UIFont(name:"Futura-Medium", size: 24.0)
                    
                    // get random quote and corresponding author
                    let insertedQuote = fullQuote[randomQuote].quote
                    let insertedAuthor = fullQuote[randomQuote].author
                                       
                    // string concatenation
                    self.quoteLabel.text = "\"" + insertedQuote + "\""
                    self.authorLabel.text = "- " + insertedAuthor
                    
                    // put in UserDefaults for the TodayExtension
                    UserDefaults.init(suiteName: "group.com.ksad.sokrates")?.setValue(self.quoteLabel.text, forKey: "quote")
                    UserDefaults.init(suiteName: "group.com.ksad.sokrates")?.setValue(self.authorLabel.text, forKey: "author")
                }
                
            
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
                    
        }.resume()
    }
    
    // function for motivating quote [fire emoji]
    func setMotivatingQuote() {
        
        // URL of the JSON file of KSAD database
        let jsonUrlString = "http://ksad.000webhostapp.com/serviceMotivating.php"
        // making an URL object
        guard let url = URL(string: jsonUrlString) else { return }
                
        
        // parsing 'motivating' JSON file with Decodable
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                    
            guard let data = data else { return }
                    
            do {
                        
                let fullQuote = try JSONDecoder().decode([FullQuote].self, from: data)
                
                // random integer between 0 and the number of quotes in database
                var randomQuote = Int.random(in: 0 ..< fullQuote.count)
                
                while (randomQuote == self.lastRandNumMotivating) {
                    randomQuote = Int.random(in: 0 ..< fullQuote.count)
                }
                
                self.lastRandNumMotivating = randomQuote
                
                print(randomQuote)

                
                // IB referencing here (Use Main Thread Checker)
                DispatchQueue.main.async {
                    
                    // add animations
                    self.quoteLabel.fadeTransition(0.2)
                    self.authorLabel.fadeTransition(0.2)
                    
                    // alter font and font size
                    self.quoteLabel.font = UIFont(name:"Futura-Medium", size: 24.0)
                    
                    // get random quote and corresponding author
                    let insertedQuote = fullQuote[randomQuote].quote
                    let insertedAuthor = fullQuote[randomQuote].author
                                       
                    // string concatenation
                    self.quoteLabel.text = "\"" + insertedQuote + "\""
                    self.authorLabel.text = "- " + insertedAuthor
                    
                    // put in UserDefaults for the TodayExtension
                    UserDefaults.init(suiteName: "group.com.ksad.sokrates")?.setValue(self.quoteLabel.text, forKey: "quote")
                    UserDefaults.init(suiteName: "group.com.ksad.sokrates")?.setValue(self.authorLabel.text, forKey: "author")
                }
                
            
            } catch let jsonError {
                print("Error serializing json:", jsonError)
            }
                    
        }.resume()
    }
    
    
}


// MARK: - UILabel Animations

// DO NOT TOUCH - extension for animations when text is changing
extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}  // NEVER TOUCH
