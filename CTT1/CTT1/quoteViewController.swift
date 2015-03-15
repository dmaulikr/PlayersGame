//
//  quoteViewController.swift
//  CTT1
//
//  Created by Alexis Saint-Jean on 3/11/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//

import UIKit

class quoteViewController: ViewController {
    @IBOutlet weak var quoteTextField: UITextView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var professionLabel: UILabel!

    @IBOutlet weak var backgroundImage: UIImageView!
    var imageSet = ["NasaC.jpg","GalaxyC.jpg","HubbleEyeC.jpg","PillarsC.jpg"]
    
    
    var textOfQuote: String?
    var authorOfQuote: String?
    var professionOfAuthor: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.quoteTextField.text = textOfQuote
        self.authorLabel.text = authorOfQuote
        self.professionLabel.text = professionOfAuthor
        let randomNumber = Int(arc4random_uniform(4))
        println("random Number is \(randomNumber)")
        
        self.backgroundImage.image = UIImage(named: self.imageSet[randomNumber])

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showAuthorVC(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let next = storyboard.instantiateViewControllerWithIdentifier("authorVC") as AuthorViewController
        self.presentViewController(next, animated: true, completion: nil)
        
    }
    @IBAction func showVideoVC(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let next = storyboard.instantiateViewControllerWithIdentifier("videoVC") as videoViewController
        self.presentViewController(next, animated: true, completion: nil)
        
    }

}
