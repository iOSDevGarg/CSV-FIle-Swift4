//
//  SelectCSV.swift
//  CSV-File-Swift4
//
//  Created by IosDeveloper on 14/11/17.
//  Copyright © 2017 iOSDeveloper. All rights reserved.
//

import UIKit

class SelectCSV: UIViewController {

    //Outlets
    @IBOutlet weak var mainTableView: UITableView!
    
    //required declarations
    var FinalArray = [[String]]()
    var listView = [String]()
    let cellReuseIdentifier = "Cell"
    let newData = ReadContent()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Removing extra seprators
        mainTableView.tableFooterView = UIView()
        
        //checking if file exists
        let fileName = "mynewcsv.csv"
        let path1 = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path1[0]
        
        //path of file
        let path = NSURL(fileURLWithPath: documentDirectoryPath).appendingPathComponent(fileName)
        let filePath = path?.path
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filePath!)
        {
            //file exists
            self.readCsv(filename: "mynewcsv")
        }
        else
        {
            //file do not exists
            self.showToast(message: "mynewcsv file Do not exists")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK:SelectCSV Extension for tableView
extension SelectCSV : UITableViewDelegate,UITableViewDataSource
{
    //MARK:- Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //load table if Array have Values
        if self.FinalArray.count > 0
        {
            return FinalArray.count
        }
        else
        {
            return 0
        }
    }
    
    //setting cell data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //cell declaration
        let cell = self.mainTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! CustomTableCell
        
        //setting data according to index to avoid extra arrays
        newData.initWithData(data: self.FinalArray, index: indexPath.row)
        
        cell.nameLabel.text = newData.name
        cell.dateLabel.text = newData.date
        cell.timeLabel.text = newData.time
        
        return cell
    }
    
    //setting height for cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        return Env.iPad ? 180 : 80
    }
    
    //selectimg Items from tableView
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        newData.initWithData(data: self.FinalArray, index: indexPath.row)
        self.getContentForSelectedFile(index: indexPath.row)
    }
}

//MARK: CSV File Reader Handler
extension SelectCSV {
    
    //Clean rows seprate as ms-Excel
    func cleanRows(file:String)->String
    {
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    //Read content of CSV File
    func readDataFromCSV(fileName:String, fileType: String)-> String!
    {
        
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
        let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        let dirPath          = paths.first
        
        let imageURL = URL(fileURLWithPath: dirPath!).appendingPathComponent("\(fileName).\(fileType)")
        
        do
        {
            var contents = try String(contentsOfFile: imageURL.path, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        }
        catch
        {
            print("File Read Error for file \(imageURL.path)")
            return nil
        }
        
    }
    
    //Main Function to get output from a file
    func readCsv(filename: String)
    {
        DispatchQueue.global(qos: .background).async
            {
                //BackGround Queue Update
                var data = self.readDataFromCSV(fileName: filename, fileType: "csv")
                data = self.cleanRows(file: data!)
                var csvRows = self.csv(data: data!)
                
                //removing header and extra Appended value
                csvRows.remove(at: csvRows.count-1)
                csvRows.remove(at: 0)
                
                //getting string format values to array
                for count in 0..<csvRows.count {
                    self.listView = csvRows[count]
                    let stringMessage = self.listView[0]
                    let DetailNewArray = stringMessage.components(separatedBy: ",")
                    self.FinalArray.append(DetailNewArray)
                }
                
                DispatchQueue.main.async
                    {
                        //Main Queue Update With All UI
                        //reload tableView here after getting all content
                        self.mainTableView.delegate = self
                        self.mainTableView.dataSource = self
                        self.mainTableView.reloadData()
                        
                }
        }
    }
    
    //get exact decoded data
    func csv(data: String) -> [[String]]
    {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
    
    //get for selectedFile
    func getContentForSelectedFile(index: Int) {
        DispatchQueue.global(qos: .background).async
            {
                
                //BackGround Queue Update
                self.listView = self.FinalArray[index]
                //get data in SingleTon Class
                ResultValues.csvFileValue.Name = self.listView[0]
                ResultValues.csvFileValue.Date = self.listView[1]
                ResultValues.csvFileValue.time = self.listView[2]
                ResultValues.csvFileValue.Value1 = self.listView[3]
                ResultValues.csvFileValue.Value2 = self.listView[4]
                ResultValues.csvFileValue.Value3 = self.listView[5]
                
                DispatchQueue.main.async {
                    //Main Queue Update With All UI
                    csvFile.isSelected = true
                    self.navigationController?.popToRootViewController(animated: true)
                }
        }
    }
}

