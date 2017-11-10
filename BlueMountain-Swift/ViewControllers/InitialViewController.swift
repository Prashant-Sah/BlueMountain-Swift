//
//  InitialViewController.swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/30/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import ObjectMapper

class InitialViewController: UIViewController {
    
    @IBOutlet weak var suburbTextField: UITextField!
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var problemLoadingAddressButton: UIButton!
    
    var suburbNames : [String]?
    var streetNames : [String]?
    var matchingNames : [String]?
    var selectedSuburbName : String?
    var selectedStreetIndex : Int?
    var selectedStreetName : String?
    var suburbTextFieldIsActive = false
    
    var streetsGarbageInfos : [StreetGarbageInfo]?
    
    var streetTableView = UITableView()
    var autoCompleteTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        self.getSuburbNames()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        CustomNavigationBar.titleText = "Blue Mountain"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetView()
    }
}


// MARK: - Configure View
extension InitialViewController {
    
    func configureView(){
        
        suburbTextField.layer.cornerRadius = 15
        streetNameTextField.layer.cornerRadius = 15
        proceedButton.layer.cornerRadius = 20
        
        suburbTextField.delegate = self
        streetNameTextField.delegate = self
        
        self.suburbTextField.addTarget(self, action: #selector(textFieldDidChange(forTextField:)), for: .editingChanged)
        self.streetNameTextField.addTarget(self, action: #selector(textFieldDidChange(forTextField:)), for: .editingChanged)
        
        let attributes = [
            NSFontAttributeName : UIFont.systemFont(ofSize: 23),
            NSForegroundColorAttributeName : UIColor.black,
            NSUnderlineStyleAttributeName : NSUnderlineStyle.styleSingle.rawValue
            ] as [String : Any]
        
        let attributeString = NSMutableAttributedString(string: "Problem loading your address?", attributes: attributes )
        problemLoadingAddressButton.setAttributedTitle(attributeString, for: .normal)
        problemLoadingAddressButton.addTarget(self, action: #selector(goToProblemsVC), for: .touchUpInside)
        
        let frameWRTView = suburbTextField.convert(self.suburbTextField.frame, to: self.view)
        autoCompleteTableView = UITableView(frame: CGRect(x: frameWRTView.origin.x, y: frameWRTView.origin.y + self.suburbTextField.frame.size.height, width: self.suburbTextField.frame.size.width, height: autoCompleteTableView.rowHeight), style: .plain)
        autoCompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AutoCompleteCell")
        autoCompleteTableView.layer.cornerRadius = 15
        autoCompleteTableView.layer.masksToBounds = false
        autoCompleteTableView.backgroundColor = UIColor.white
        autoCompleteTableView.dataSource = self
        autoCompleteTableView.delegate = self
        autoCompleteTableView.isHidden = true
        autoCompleteTableView.rowHeight = 50
        view.addSubview(autoCompleteTableView)
        
        streetTableView = UITableView(frame: CGRect(x: 0, y: 50, width: self.view.frame.size.width, height: streetTableView.rowHeight), style: .plain)
        streetTableView.register(UINib(nibName: "StreetTableViewCell", bundle: nil), forCellReuseIdentifier: "StreetCell")
        streetTableView.backgroundColor = UIColor.white
        streetTableView.dataSource = self
        streetTableView.delegate = self
        streetTableView.isHidden = true
        view.addSubview(streetTableView)
        
        
    }
    
    
    func enableDisableProceedButton(withActiveState active : Bool){
        proceedButton.isEnabled = active
        proceedButton.alpha = active ? 1.0 : 0.7
    }
    
    func streetTableView(isActive active : Bool){
        
        for subView in view.subviews{
            subView.isUserInteractionEnabled = active
            subView.alpha = active ? 0.5 : 1
        }
        self.streetTableView.isUserInteractionEnabled = active
        self.streetTableView.alpha = 1.0
    }
    
    func resetView(){
        
        suburbTextField.text = ""
        streetNameTextField.text = ""
        selectedStreetName = ""
        selectedSuburbName = ""
        selectedStreetIndex = nil
        streetsGarbageInfos?.removeAll()
        matchingNames?.removeAll()
    }
}


// MARK: - Button Handlers
extension InitialViewController {
    
    func goToProblemsVC(){
        
        let tabVC = self.tabBarController as! CustomTabBarController
        tabVC.selectedIndex = 2
        tabVC.toggleButtonImages(withIndex: 2)
    }
    
    @IBAction func proceedButtonClicked(_ sender: UIButton) {
        
        self.getHouses {
            print("pressed")
            self.streetTableView.frame.size.height = CGFloat(((self.streetsGarbageInfos?.count)! > 6) ? 40 * 6 : 40 * (self.streetsGarbageInfos?.count)!)
            self.streetTableView.reloadData()
            self.streetTableView.isHidden = false
            self.streetTableView(isActive: true)
            
        }

    }
    
}

// MARK: - Autocomplete Tasks
extension InitialViewController {
    
    func textFieldDidChange(forTextField textField : UITextField){
        
        if (textField == self.suburbTextField){
            self.performAutoComplete(withSearchString: textField.text!, forTextField: self.suburbTextField)
        }else if textField == streetNameTextField{
            self.performAutoComplete(withSearchString: textField.text!, forTextField: self.streetNameTextField)
        }
    }
    
    func performAutoComplete(withSearchString search: String, forTextField textField : UITextField){
        
        self.matchingNames?.removeAll()
        
        if (textField == self.suburbTextField){
            
            self.matchingNames = suburbNames?.filter{
                $0.lowercased().hasPrefix(search.lowercased())
            }
            if(self.matchingNames != nil){
                
                let frameWRTView = suburbTextField.convert(self.suburbTextField.frame, to: self.view)
                self.autoCompleteTableView.frame.origin = CGPoint(x: frameWRTView.origin.x, y: frameWRTView.origin.y + suburbTextField.frame.size.height)
                self.setTableViewHeightAndReload()
            }
            
        }else if (textField == self.streetNameTextField){
            self.matchingNames = streetNames?.filter{
                $0.lowercased().hasPrefix(search.lowercased())
            }
            if(self.matchingNames != nil){
                
                let frameWRTView = suburbTextField.convert(self.streetNameTextField.frame, to: self.view)
                self.autoCompleteTableView.frame.origin = CGPoint(x: frameWRTView.origin.x, y: frameWRTView.origin.y + streetNameTextField.frame.size.height)
                self.setTableViewHeightAndReload()
            }
        }
    }
    
    func setTableViewHeightAndReload(){
        
        self.autoCompleteTableView.frame.size.height = ((matchingNames?.count)! > 4) ? autoCompleteTableView.rowHeight * 4 : autoCompleteTableView.rowHeight * CGFloat((matchingNames?.count)!)
        
        self.autoCompleteTableView.isHidden = false
        self.autoCompleteTableView.reloadData()
    }
}


// MARK: - UITextFieldDelegate functions
extension InitialViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == suburbTextField{
            suburbTextFieldIsActive = true
            
        }else if(textField == streetNameTextField && selectedSuburbName != ""){
            suburbTextFieldIsActive = false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField == suburbTextField) {
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92 ) { //&& selectedStreetIndex != nil
                streetNameTextField.text = ""
                selectedStreetIndex = nil
                self.enableDisableProceedButton(withActiveState: false)
            }
        }else if  textField == streetNameTextField{
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (isBackSpace == -92 ) { //&& selectedStreetIndex != nil
                self.enableDisableProceedButton(withActiveState: false)
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == self.suburbTextField{
            if (selectedSuburbName != ""){
                self.getStreetNames()
            }
            suburbTextFieldIsActive = false
        }
    }
}


// MARK: - AutoComplete and Street Table View Datasource and Delegate functions
extension InitialViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == autoCompleteTableView{
            return self.matchingNames?.count ?? 0
        }else {
            return streetsGarbageInfos?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == autoCompleteTableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AutoCompleteCell", for: indexPath)
            cell.textLabel?.textColor = UIColor(red: 162.0/255, green: 216.0/255, blue: 74.0/255, alpha: 1)
            cell.textLabel?.text = self.matchingNames?[indexPath.row]
            return cell
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "StreetCell", for: indexPath) as? StreetTableViewCell
            cell?.streetName.text = streetsGarbageInfos?[indexPath.row].street
            cell?.houseNumber.text = streetsGarbageInfos?[indexPath.row].houseNumber
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == autoCompleteTableView {
            if(suburbTextFieldIsActive){
                self.enableDisableProceedButton(withActiveState: false)
                selectedSuburbName = matchingNames?[indexPath.row]
                self.suburbTextField.text = self.matchingNames?[indexPath.row]
            }else{
                self.selectedStreetIndex = indexPath.row
                selectedStreetName = self.matchingNames?[indexPath.row]
                streetNameTextField.text = self.matchingNames?[indexPath.row]
                self.enableDisableProceedButton(withActiveState: true)
            }
            self.autoCompleteTableView.isHidden = true
        }else{
            let data = NSKeyedArchiver.archivedData(withRootObject: streetsGarbageInfos?[indexPath.row])
            UserDefaults.standard.set(data, forKey: "Location")
            streetTableView(isActive: false)
            streetTableView.isHidden = true
            let tabBar = self.tabBarController as! CustomTabBarController
            resetView()
            tabBar.setTabBarItems(withLocationSelected: true)
        }
    }
}


// MARK: - Get suburb and street names from server
extension InitialViewController{
    
    func getSuburbNames(){
        
        let params = [
            "submit" : "Submit"
        ]
        
        APICaller.shared.getSuburbs(withParameters: params, withIndicatorMessage: nil) { (suburbs) in
            self.suburbNames = suburbs
        }
    }
    
    func getStreetNames(){
        
        self.streetNames?.removeAll()
        
        let params = [
            "suburb" : selectedSuburbName!,
            ]
        
        APICaller.shared.autoSuggestStreet(withParameters: params, withIndicatorMessage: nil) { (streets) in
            
            self.streetNames = streets
        }
    }
    
    func getHouses(completion: @escaping () ->()){
        
        if selectedStreetName != "" || selectedSuburbName != ""{
            
            let params = [
                "suburb" : selectedSuburbName!,
                "address" : selectedStreetName!
            ]
            print(params)
            
            APICaller.shared.searchLocation(withParameters: params, withIndicatorMessage: "Getting Locations for your data") { (count, results) in
                
                if count != "0" {
                    self.streetsGarbageInfos = Mapper<StreetGarbageInfo>().mapArray(JSONObject : results)
                    completion()
                }
            }
        }else{
            
            Alerter().showAlert(withMessage: "Looks like you have input garbage or nothing", alertTitle: "Error", alertActions: nil)
        }
    }
}


