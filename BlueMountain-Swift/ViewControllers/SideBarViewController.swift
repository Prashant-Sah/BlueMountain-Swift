//
//  SideBarViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/18/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import CCAutocomplete
import Alamofire
import ObjectMapper

class SideBarViewController: UIViewController {
    
    @IBOutlet weak var suburbTextField: UITextField!
    @IBOutlet weak var streetNameTextField: UITextField!
    @IBOutlet weak var selectAddressButton: UIButton!
    @IBOutlet weak var textStackView: UIStackView!
    @IBOutlet weak var nextCollectionButton: UIButton!
    @IBOutlet weak var allCollectionButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    
    var nextCollectionChecked : Bool = false
    var allCollectionChecked : Bool = false
    
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
        
        suburbTextField.delegate = self
        streetNameTextField.delegate = self
        
        self.suburbTextField.addTarget(self, action: #selector(textFieldDidChange(forTextField:)), for: .editingChanged)
        self.streetNameTextField.addTarget(self, action: #selector(textFieldDidChange(forTextField:)), for: .editingChanged)
        
        self.configureView()
        
        self.getSuburbNames()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        resetView()
    }
}


// MARK: - View Configuration
extension SideBarViewController {
    
    func configureView(){
        
        suburbTextField.textColor = UIColor(red: 162.0/255, green: 216.0/255, blue: 74.0/255, alpha: 1)
        suburbTextField.layer.cornerRadius = 20
        streetNameTextField.textColor = UIColor(red: 162.0/255, green: 216.0/255, blue: 74.0/255, alpha: 1)
        streetNameTextField.layer.cornerRadius = 20
        selectAddressButton.layer.cornerRadius = 20
        setButton.layer.cornerRadius = 20
        
        selectAddressButton.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        setButton.titleEdgeInsets = UIEdgeInsetsMake(5, 10, 5, 10)
        
        self.enableDisableSelectButton(withActiveState: false)
        
        /// Table view
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
        
        streetTableView = UITableView(frame: CGRect(x: 0, y: 50, width: self.revealViewController().rearViewRevealWidth, height: streetTableView.rowHeight), style: .plain)
        streetTableView.register(UINib(nibName: "StreetTableViewCell", bundle: nil), forCellReuseIdentifier: "StreetCell")
        streetTableView.backgroundColor = UIColor.white
        streetTableView.dataSource = self
        streetTableView.delegate = self
        streetTableView.isHidden = true
        view.addSubview(streetTableView)
    }
    
    func enableDisableSelectButton(withActiveState active : Bool){
        selectAddressButton.isEnabled = active
        selectAddressButton.alpha = active ? 1.0 : 0.7
    }
    
    func streetTableView(isActive active : Bool){
        
        for subView in view.subviews{
            subView.isUserInteractionEnabled = active ? false : true
            subView.alpha = active ? 0.5 : 1
           
        }
        streetTableView.isUserInteractionEnabled = active ? true : false
        streetTableView.alpha = 1.0
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


// MARK: - UITextFieldDelegate functions
extension SideBarViewController : UITextFieldDelegate{
    
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
            
            if (isBackSpace == -92 && selectedStreetIndex != nil) {
                print("Backspace was pressed")
                streetNameTextField.text = ""
                selectedStreetIndex = nil
                self.enableDisableSelectButton(withActiveState: false)
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



// MARK: - Autocomplete Tasks
extension SideBarViewController {
    
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

// MARK: - AutoComplete Table View Datasource and Delegate functions
extension SideBarViewController : UITableViewDataSource, UITableViewDelegate {
    
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
                self.enableDisableSelectButton(withActiveState: false)
                selectedSuburbName = matchingNames?[indexPath.row]
                self.suburbTextField.text = self.matchingNames?[indexPath.row]
            }else{
                self.selectedStreetIndex = indexPath.row
                selectedStreetName = self.matchingNames?[indexPath.row]
                streetNameTextField.text = self.matchingNames?[indexPath.row]
                self.enableDisableSelectButton(withActiveState: true)
            }
            self.autoCompleteTableView.isHidden = true
        }else{
            streetTableView(isActive: false)
            streetTableView.isHidden = true
            //            if let calendarVC = self.storyboard?.instantiateViewController(withIdentifier: "CalendarViewController") as? CalendarViewController{
            //                self.navigationController?.setViewControllers([calendarVC], animated: true)
            //            }
            self.revealViewController().revealToggle(animated: true)
            resetView()
            
        }
    }
    
    
}

// MARK: - Get suburb and street names from server
extension SideBarViewController{
    
    func getSuburbNames(){
        
        let suburbSearchURL = BASE_URL.appending(SUBURB_SEARCH_PATH)
        
        let params = [
            "submit" : "Submit"
        ]
        
        Alamofire.request(suburbSearchURL, method: .post, parameters: params).responseJSON { (response) in
            
            if let responseDict = response.result.value as? [String: Any]{
                if let suburbsArray = responseDict["suburbs"] as? [String]{
                    self.suburbNames = suburbsArray
                }
            }else if let error = response.result.error{
                print(error.localizedDescription)
            }
        }
    }
    
    func getStreetNames(){
        
        self.streetNames?.removeAll()
        
        let streetSearchURL = BASE_URL.appending(STREET_NAME_SUGGEST_PATH)
        let params = [
            "suburb" : selectedSuburbName!,
            ]
        
        Alamofire.request(streetSearchURL, method: .post, parameters: params).responseJSON { (response) in
            
            if let responseDict = response.result.value as? [String: Any]{
                if responseDict["code"] as? String == SUCCESS {
                    if let streetsArray = responseDict["streets"] as? [String]{
                        self.streetNames = streetsArray
                    }
                }else{
                    print(responseDict["msg"]!)
                }
            }else if let error = response.result.error{
                print(error.localizedDescription)
            }
        }
    }
    
    func getHouses(completion: @escaping () ->()){
        
        let locationSearchURL = BASE_URL.appending(SEARCH_LOCATION_PATH)
        let params = [
            "suburb" : selectedSuburbName!,
            "address" : selectedStreetName!
        ]
        print(params)
        Alamofire.request(locationSearchURL, method: .post, parameters: params).responseJSON { (response) in
            
            if let responseDict = response.result.value as? [String : Any]{
                if responseDict["code"] as! String == SUCCESS && responseDict["total"] as! String != "0" {
                    
                    self.streetsGarbageInfos = Mapper<StreetGarbageInfo>().mapArray(JSONObject: responseDict["results"])
                    completion()
                    
                }else{
                    print("No Houses found")
                }
                
                
            }else if let error = response.result.error{
                print(error.localizedDescription)
            }
        }
    }
    
    
}

// MARK: - Button Handlers
extension SideBarViewController {
    
    @IBAction func selectButtonClicked(_ sender: UIButton) {
        
        self.getHouses {
            self.streetTableView.frame.size.height = CGFloat(((self.streetsGarbageInfos?.count)! > 6) ? 40 * 6 : 40 * (self.streetsGarbageInfos?.count)!)
            self.streetTableView.reloadData()
            self.streetTableView.isHidden = false
            self.streetTableView(isActive: true)
            
        }
        
    }
    
    @IBAction func setButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func nextCollectionButtonClicked(_ sender: UIButton) {
        nextCollectionChecked = !(nextCollectionChecked)
        nextCollectionButton.setImage(nextCollectionChecked ? #imageLiteral(resourceName: "newTickButOn") : #imageLiteral(resourceName: "newTickBut"), for: .normal)
    }
    
    @IBAction func allCollectionButtonClicked(_ sender: UIButton) {
        allCollectionChecked = !(allCollectionChecked)
        allCollectionButton.setImage(allCollectionChecked ? #imageLiteral(resourceName: "newTickButOn") : #imageLiteral(resourceName: "newTickBut"), for: .normal)
    }
}


// MARK: - Touch Actions
extension SideBarViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        if touch?.view != streetTableView || touch?.view != autoCompleteTableView || touch?.view != textStackView {
            streetTableView.isHidden = true
            streetTableView(isActive: false)
            if streetNameTextField.isFirstResponder {
                streetNameTextField.resignFirstResponder()
            }else if suburbTextField.isFirstResponder{
                suburbTextField.resignFirstResponder()
            }
            self.resignFirstResponder()
            self.autoCompleteTableView.isHidden = true
        }
    }
}
