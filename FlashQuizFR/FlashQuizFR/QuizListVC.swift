//
//  QuizListVC.swift
//  FlashQuizFR
//
//  Created by Alexis Saint-Jean on 8/8/15.
//  Copyright (c) 2015 Alexis Saint-Jean. All rights reserved.
//
//CoreData code based on tutorial from http://www.raywenderlich.com/85578/first-core-data-app-using-swift
//Group by function in CoreData based on http://stackoverflow.com/questions/29562104/ios-swift-core-data-counting-child-entities

import UIKit
import CoreData

class QuizListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var words = [AnyObject]()
    var stringResultsArray = [AnyObject]()
    var categoryFromList = ["category": String(), "wordCount": String()]
    var quizListInitialArray = [AnyObject]()
    var languageSelected = "English"
    var selectedLists = [String: String]()
    var quizStartButton = UIBarButtonItem()
    var wordFromList = ["word":String(),  "wordFirst":String(), "translation":String(), "translationFirst":String(), "gender":String(), "category":String()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Selection"
        
        self.quizStartButton = UIBarButtonItem(title: "Start", style: .Plain, target: self, action:"showQuiz:")
        self.quizStartButton.enabled = false
        self.navigationItem.setRightBarButtonItem(quizStartButton, animated: true)

    }
    
    func showQuiz(Sender: AnyObject) {
        println("ShowQuiz() started")
        println("ShowQuiz(): now calling createQuizList()")
        createQuizList()
//        let secondViewController:QuizVC = QuizVC()
//        self.presentViewController(secondViewController, animated: true, completion: nil)
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let QuizScreen = storyboard.instantiateViewControllerWithIdentifier("QuizViewController") as! QuizVC
        //        // ALEXIS: Now we're passing to the 'authorInfoVC' AuthorViewController the author ID so that it knows what info to display
        //        authorInfoVC.contributorID = self.authorInfo!
        //        if let passingName = self.authorName.text {
        //            authorInfoVC.textForAuthorName = passingName
        //        }
                self.presentViewController(QuizScreen, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stringResultsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wordCell") as! UITableViewCell
        
        var categoryName = self.stringResultsArray[indexPath.row]["category"] as! String
        
        cell.textLabel!.text = categoryName
        cell.detailTextLabel?.text = self.stringResultsArray[indexPath.row]["wordCount"] as! String + " words"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let mySelectedCell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        var textOfCell = mySelectedCell.textLabel!.text
        
        if mySelectedCell.accessoryType == UITableViewCellAccessoryType.Checkmark {
            mySelectedCell.accessoryType = UITableViewCellAccessoryType.None
            self.selectedLists[textOfCell!] = nil
        }
        else {
            mySelectedCell.accessoryType = UITableViewCellAccessoryType.Checkmark
            self.selectedLists[textOfCell!] = textOfCell
        }
        
        if self.selectedLists.count > 0 {
            self.quizStartButton.enabled = true
        } else {
            self.quizStartButton.enabled = false
        }
        
        println("QuizListVC: the list of selected words now has \(self.selectedLists.count) selections")
        
//        let row = indexPath.row
//        let categorySelected = self.stringResultsArray[row]["category"] as! String
//        println("DictListVC: the category selected is: \(categorySelected)")
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        
        let fetchRequest = NSFetchRequest(entityName:"WordEntry")
        
        //sortDescriptor is to enable us to sort the list of category alphabetically, to display it in the tableView
        let sortDescriptor = NSSortDescriptor(key: "category", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let countExpression = NSExpression(format: "count:(wordFirst)")
        let countED = NSExpressionDescription()
        countED.expression = countExpression
        countED.name = "wordCount"
        countED.expressionResultType = .Integer32AttributeType
        
        fetchRequest.propertiesToFetch = ["category", countED]
        //Here we are indicating that the fetchRequest will be an array of dictionaries
        fetchRequest.resultType = .DictionaryResultType
        fetchRequest.propertiesToGroupBy = ["category"]
        
        //3
        var error: NSError?
        
        if let results = managedContext.executeFetchRequest(fetchRequest,
            error: &error) {
                words = results
                println("DictListVC: count of categories to add to stringsResultArray: \(words.count)")
                
                for i in 0...results.count-1 {
                    categoryFromList["category"] = words[i]["category"] as? String
                    
                    
                    if let intCount = words[i]["wordCount"]! as? Int {
                        categoryFromList["wordCount"] = String(intCount)
                    }
                    
                    self.stringResultsArray.append(categoryFromList)
                }
                
                println("DictListVC: stringsResultArray now has \(self.stringResultsArray.count) categories")
                println("DictListVC: stringsResultArray's first category is \(self.stringResultsArray[0])")
                
                
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
            
        }
    }
    
    
    //createQuizList() puts 50 words from the selected categories in the QuizEntry CoreData entity
    func createQuizList() {
        
        //1
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        //2
        let fetchRequest = NSFetchRequest(entityName:"WordEntry")
    
        //create an array "filter" which stores the name of the categories selected for the quiz
        var filter = [String]()
        for (key, value) in self.selectedLists {
            filter.append(value)
        }
        print("createQuizList(): filter is \(filter)")
        
        //Use the categories in the "filter" array to only return the words of the categories selected 
        //in the QuizListVC table
        let predicate = NSPredicate(format: "category IN %@", filter)
        fetchRequest.predicate = predicate
        
        //3
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            words = results
            
            for word in words {
                //Finding the number of times each letter appears as first letter in the native language. This is to help us create the lettered sections in the table
//                var nativeFirstLetter = word.valueForKey(self.titleFirst) as! String
//                self.nativeFirstArray.append(nativeFirstLetter)
                
                var newWord = word.valueForKey("word") as! String
                
                wordFromList["word"] = word.valueForKey("word") as? String
                wordFromList["wordFirst"] = word.valueForKey("wordFirst") as? String
                wordFromList["translation"] = word.valueForKey("translation") as? String
                wordFromList["translationFirst"] = word.valueForKey("translationFirst") as? String
                wordFromList["gender"] = word.valueForKey("gender") as? String
                wordFromList["category"] = word.valueForKey("category") as? String
                
                println("appending word \(newWord)")
                self.quizListInitialArray.append(wordFromList)
                
                //Append "word" to the array in the corresponding dictionary in nativeWordlist
//                if self.nativeWordList[nativeFirstLetter] == nil {
//                    self.nativeWordList[nativeFirstLetter] = [wordFromList]
//                } else {
//                    self.nativeWordList[nativeFirstLetter]!.append(wordFromList)
//                }
                
            }
            
            println("createQuizList(): the number of words within the quizListInitialArray is \(self.quizListInitialArray.count)")
            
            //Create a sorted array listing each unique letter
//            uniqueNativeFirstArray = Array(Set(self.nativeFirstArray))
//            uniqueNativeFirstArray.sort(){$0 <  $1}
//            println("DictionaryVC: uniqueNativeFirstArray is : \(uniqueNativeFirstArray)")
//            
//            for i in uniqueNativeFirstArray {
//                var wordArrayForLetter = self.nativeWordList[i]
//                self.sortedNativeWordList.append(wordArrayForLetter!)
//            }
            
            
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
