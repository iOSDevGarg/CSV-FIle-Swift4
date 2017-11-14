//
//  ViewController.swift
//  CSV-File-Swift4
//
//  Created by IosDeveloper on 14/11/17.
//  Copyright © 2017 iOSDeveloper. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: TextFields Outlets
    @IBOutlet weak var TF1: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF4: UITextField!
    
    //Objects needed
    var DetailArray = [DetailToStore]()
    var Detail: DetailToStore!
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delagtes to TextFields
        TF1.delegate = self
        TF2.delegate = self
        TF3.delegate = self
        TF4.delegate = self
        
        //setting return keys
        TF1.returnKeyType = .next
        TF2.returnKeyType = .next
        TF3.returnKeyType = .next
        TF4.returnKeyType = .done
        
    }
    
    //MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        if csvFile.isSelected == true
        {
            TF1.text = ResultValues.csvFileValue.Name
            TF2.text = ResultValues.csvFileValue.Value1
            TF3.text = ResultValues.csvFileValue.Value2
            TF4.text = ResultValues.csvFileValue.Value3
        }
        else
        {
            //nothing here normal loading
        }
    }
    
    //MARK: Button Actions
    
    //Save a new Record
    @IBAction func SaveNewRecord(_ sender: Any) {
        
        let TF1Text:String = TF1.text!
        let TF2Text:String = TF2.text!
        let TF3Text:String = TF3.text!
        let TF4Text:String = TF4.text!
        
        let trimmed1 = TF1Text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmed2 = TF2Text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmed3 = TF3Text.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmed4 = TF4Text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (trimmed1.count > 0) && (trimmed2.count > 0) && (trimmed3.count > 0) && (trimmed4.count > 0)
        {
            csvFile.isSelected = false
            
            //create a path for file
            let text:String = "mynewcsv"
            let fileName = "\(text.lowercased()).csv"
            let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            let documentDirectoryPath:String = path1[0]
            //path of file
            let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
            let filePath = path?.path
            let fileManager = FileManager.default
            
            //check if file exists or not
            if fileManager.fileExists(atPath: filePath!)
            {
                //yes file is available so need to update
                self.Detail = DetailToStore()
                
                //for loop to allocate data
                for _ in 0..<1{
                    self.Detail.Name = TF1.text!
                    self.Detail.Date = self.returnDate()
                    self.Detail.time = self.returnTime()
                    self.Detail.value1 = TF2.text!
                    self.Detail.value2 = TF3.text!
                    self.Detail.value3 = TF4.text!
                    self.DetailArray.append(self.Detail!)
                }
                
                //Update CSV file
                self.updateCsvFile(filename: text.lowercased())
            }
            else
            {
                //file do not exist need to create a new file
                self.Detail = DetailToStore()
                
                //for loop to allocate data
                for _ in 0..<1{
                    self.Detail.Name = TF1.text!
                    self.Detail.Date = self.returnDate()
                    self.Detail.time = self.returnTime()
                    self.Detail.value1 = TF2.text!
                    self.Detail.value2 = TF3.text!
                    self.Detail.value3 = TF4.text!
                    self.DetailArray.append(self.Detail!)
                }
                
                //Create a new CSV file
                self.creatCSV(filename: text.lowercased())
            }
        }
        else
        {
            self.showToast(message: "Enter values in all Text Fields")
        }
    }
    
    //Load a Saved Record
    @IBAction func LoadSavedRecords(_ sender: Any) {
        let Vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectCSV") as! SelectCSV
        self.navigationController?.pushViewController(Vc, animated: true)
    }
    
    @IBAction func clearSavedRecord(_ sender: Any) {
        self.removeFile(itemName: "mynewcsv", fileExtension: "csv")
        self.showToast(message: "All records are cleared")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: TF Delgates
extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == TF1
        {
            TF2.becomeFirstResponder()
        }
        else if textField == TF2
        {
            TF3.becomeFirstResponder()
        }
        else if textField == TF3
        {
            TF4.becomeFirstResponder()
        }
        else if textField == TF4
        {
            TF4.resignFirstResponder()
        }
        return true
    }
}

extension ViewController {
    
    //MARK: Date Format
    func returnDate() -> String{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        return result
    }
    
    //MARK: Time Format
    func returnTime() -> String{
        let date = Date()
        let formatter1 = DateFormatter()
        formatter1.dateFormat = "h:mm a"
        let result1 = formatter1.string(from: date)
        return result1
    }
}

//MARK: CSV File save Record Handler
extension ViewController {
    
    //MARK: remove csv file from document directory
    func removeFile(itemName:String, fileExtension: String)
    {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemName).\(fileExtension)"
        do {
            try fileManager.removeItem(atPath: filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
        
    }
    
    // MARK: CSV file creating
    func creatCSV(filename: String) -> Void
    {
        
        //Name for file
        let fileName = "\(filename).csv"
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        
        //path of file
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        
        //Headers for file
        var csvText = "Name,Date,Time,Value1,Value2,Value3\n"
        
        //Loop to save array //details below header
        for detail in DetailArray
        {
            let newLine = "\(detail.Name),\(detail.Date),\(detail.time),\(detail.value1),\(detail.value2),\(detail.value3)\n"
            csvText.append(newLine)
        }
        //Saving handler
        do
        {
            //save
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            showToast(message: "Record is saved")
        }
        catch
        {
            //if error exists
            print("Failed to create file")
            print("\(error)")
        }
        
        //removing all arrays value after saving data
        DetailArray.removeAll()
        print(path ?? "not found")
    }
    
    // MARK: Updating CSV file values
    func updateCsvFile(filename: String) -> Void {
        
        //Name for file
        let fileName = "\(filename).csv"
        
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        //path of file
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        
        //Loop to save array //details below header
        for detail in DetailArray
        {
            let newLine = "\(detail.Name),\(detail.Date),\(detail.time),\(detail.value1),\(detail.value2),\(detail.value3)\n"
            
            //Saving handler
            do
            {
                //save
                try newLine.appendToURL(fileURL: path!)
                showToast(message: "Record is saved")
            }
            catch
            {
                //if error exists
                print("Failed to create file")
                print("\(error)")
            }
            
            print(path ?? "not found")
            
        }
        //removing all arrays value after saving data
        DetailArray.removeAll()
        
    }
    
}

//MARK: Custom Toast message
extension UIViewController {
    
    //Add a toast message on Screen
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.numberOfLines = 0
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        toastLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

//MARK: Extension for String
extension String {
    func appendLineToURL(fileURL: URL) throws {
        try (self + "\n").appendToURL(fileURL: fileURL)
    }
    
    func appendToURL(fileURL: URL) throws {
        let data = self.data(using: String.Encoding.utf8)!
        try data.append(fileURL: fileURL)
    }
}

//MARK: Extension for File data
extension Data {
    func append(fileURL: URL) throws {
        if let fileHandle = FileHandle(forWritingAtPath: fileURL.path) {
            defer {
                fileHandle.closeFile()
            }
            fileHandle.seekToEndOfFile()
            fileHandle.write(self)
        }
        else {
            try write(to: fileURL, options: .atomic)
        }
    }
}
