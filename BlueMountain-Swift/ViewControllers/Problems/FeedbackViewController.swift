//
//  FeedbackViewController.swift
//  BlueMountain-Swift
//
//  Created by Prashant Sah on 7/25/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import CCAutocomplete
import CoreLocation

class FeedbackViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var feedbackTopicTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var textStackView: UIStackView!
    
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    var dropDownTableView : UITableView = UITableView()
    var dropDownTableViewIsActive = false
    
    var problemTypes = [ProblemTypes]()
    var selectedProblemIndex : Int?
    
    var userInfo : UserInfo?
    var imageData : Data? = nil
    var fileName : String?
    var feedbackInfo : FeedbackInfo?
    var locationManager : CLLocationManager?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.feedbackTextView.delegate = self
        self.revealViewController().panGestureRecognizer().isEnabled = false
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeRight(sender:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        self.configureView()
        
        problemTypes = DBManager.sharedInstance.getProblemTypesFromDatabase()
        if(problemTypes.isEmpty == true){
            getProblemTypes()
        }else{
            self.dropDownTableView.reloadData()
        }
        
        if(feedbackInfo != nil){
            self.selectedProblemIndex = feedbackInfo?.problemTypeIndex
            if(self.selectedProblemIndex != nil){
            self.feedbackTopicTextField.text = self.problemTypes[(feedbackInfo?.problemTypeIndex)!].title
            }
            self.locationTextField.text = feedbackInfo?.location
            self.feedbackTextView.text = feedbackInfo?.message
        }
    }
}

// MARK: - configuring View
extension FeedbackViewController {
    
    func configureView(){
        
        feedbackTopicTextField.placeholder = "Choose a Topic"
        feedbackTopicTextField.addTarget(self, action: #selector(feedbackTopicTextFieldBecameActive), for: .touchDown)
        
        locationTextField.placeholder = "Location"
        feedbackTextView.text = "Notes"
        feedbackTextView.textColor = UIColor.lightGray
        feedbackTopicTextField.layer.cornerRadius = 15
        locationTextField.layer.cornerRadius = 15
        feedbackTextView.layer.cornerRadius = 15
        sendButton.layer.cornerRadius = 15
        
        let locateBut = UIButton(type: .custom)
        locateBut.frame =  CGRect(x: self.locationTextField.frame.size.width - 35, y: 5, width: 30, height: 30)
        locateBut.setBackgroundImage(#imageLiteral(resourceName: "locateBut"), for: .normal)
        locateBut.addTarget(self, action: #selector(locateButtonPressed), for: .touchUpInside)
        locationTextField.rightViewMode = UITextFieldViewMode.always ;
        locationTextField.rightView = locateBut;
        
        dropDownTableView = UITableView(frame: CGRect(x: self.feedbackTopicTextField.frame.origin.x, y: self.feedbackTopicTextField.frame.origin.y + self.feedbackTopicTextField.frame.size.height, width: self.feedbackTopicTextField.frame.size.width, height: 160), style: .plain)
        dropDownTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DropDownCell")
        dropDownTableView.layer.cornerRadius = 15
        dropDownTableView.layer.masksToBounds = true
        dropDownTableView.backgroundColor = UIColor.white
        dropDownTableView.dataSource = self
        dropDownTableView.delegate = self
        dropDownTableView.isHidden = true
        self.textStackView.addSubview(dropDownTableView)
    }
}

// MARK: - Fetch problem types from server
extension FeedbackViewController{
    
    func getProblemTypes(){
        
        let params = [
            "submit" : "Submit"
        ]
        
        let getProblemsURL = "\(BASE_URL.appending(GET_PROBLEM_TYPES_PATH))"
        
        Alamofire.request(getProblemsURL, method: .post, parameters : params).responseJSON(completionHandler: { [weak self] response in
            guard let sSelf = self else{
                return
            }
            
            if let json = response.result.value{
                let obtainedResponse = json as! Dictionary<String, Any>
                
                let problemTypesDict = obtainedResponse["problem_types"] as! [[String:Any]]
                if let problemTypes = Mapper<ProblemTypes>().mapArray(JSONObject: problemTypesDict){
                    sSelf.problemTypes = problemTypes
                    DBManager.sharedInstance.pushProblemTypesToDatabase(withArray: problemTypes)
                    sSelf.dropDownTableView.reloadData()
                    print(json)
                }
                
            }else{
                print(response.result.error!)
            }
        })
    }
}



// MARK: - Button and Swipe Handlers
extension FeedbackViewController {
    
    func respondToSwipeRight(sender:UISwipeGestureRecognizer){
        
        if let problemsVC = self.storyboard?.instantiateViewController(withIdentifier: "ProblemsVC") as? ProblemsViewController{
            
            self.feedbackInfo = FeedbackInfo.init(self.selectedProblemIndex, location: self.locationTextField.text, message: self.feedbackTextView.text, imageData: self.imageData)
            problemsVC.feedbackInfo = self.feedbackInfo
            if(self.userInfo != nil){
            problemsVC.userInfo = self.userInfo
            }
            
            let transition = CATransition.init()
            transition.duration = 0.45
            transition.type =  kCATransitionPush
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.navigationController?.setViewControllers([problemsVC], animated: false)
            //self.navigationController?.popViewController(animated: true)
        }
    }
    
    func locateButtonPressed (){
        
        // Instantiate LocationVC if user is allowed to pin-point the location and use it's delegate function at the end of this controller
        /*
         if let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationVC") as? LocationViewController{
         locationVC.userLocationDelegate = self
         let navVC = UINavigationController(rootViewController: locationVC)
         self.present(navVC, animated: true, completion: nil)
         }
         */
        
        
        if (self.locationManager == nil){
            self.locationManager = CLLocationManager()
            self.locationManager?.delegate = self as CLLocationManagerDelegate
            self.locationManager?.requestWhenInUseAuthorization()
        }
        self.locationManager?.startUpdatingLocation()
        
    }
    
    
    
    
    @IBAction func choosePhoto(_ sender : UIButton){
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        
        let takePhoto = UIAlertAction(title: "Take a Photo", style: .default) { (alertAction) in
            
            if(UIImagePickerController.isSourceTypeAvailable(.camera)){
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }else{
                print("camera not found")
            }
        }
        
        let chooseFromGallery = UIAlertAction(title: "Choose photo from gallery", style: .default) { (alertAction) in
            
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let alertController = UIAlertController(title: "Action Required", message: "Choose Image Source", preferredStyle: .actionSheet)
        
        //to change font of title and message.
        let titleFont = [NSFontAttributeName: UIFont(name: "Avenir", size: 22.0)!]
        let messageFont = [NSFontAttributeName: UIFont(name: "Avenir-Roman", size: 18.0)!]
        
        let titleAttrString = NSMutableAttributedString(string: "Action Required", attributes: titleFont)
        let messageAttrString = NSMutableAttributedString(string: "Choose Image Source", attributes: messageFont)
        
        alertController.setValue(titleAttrString, forKey: "attributedTitle")
        alertController.setValue(messageAttrString, forKey: "attributedMessage")
        
        alertController.addAction(takePhoto)
        alertController.addAction(chooseFromGallery)
        
        alertController.view.tintColor = UIColor.red
        alertController.view.backgroundColor = UIColor.black
        alertController.view.layer.cornerRadius = 40
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func sendButtonPressed(_ sender : UIButton){
        
        // perfrom validation
        
        let feedbackPathURL = BASE_URL.appending(FEEDBACK_PATH)
        
        let params = [
            "name"              : self.userInfo?.name,
            "email"             : self.userInfo?.email,
            "problem_type_id"   : self.problemTypes[selectedProblemIndex!].problemTypeId,
            "phone_no"          : self.userInfo?.phone,
            "location"          : self.locationTextField.text,
            "notes"             : self.feedbackTextView.text
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key,value) in params{
                multipartFormData.append((value?.data(using: .utf8))!, withName: key)
            }
            multipartFormData.append(self.imageData!, withName: "image", fileName: self.fileName!, mimeType: "JPEG")
        }, usingThreshold: UInt64.init(), to: feedbackPathURL, method: .post, headers: nil) { (encodingResult) in
            switch (encodingResult){
            case .success(let upload, _ , _ ):
                upload.responseJSON(completionHandler: { (response) in
                    debugPrint(response)
                    if let responseDict = response.result.value as? [String : Any]{
                        if (responseDict["code"] as? String == SUCCESS){
                            //Show success alert
                        }else{
                            //show error alert
                        }
                    }
                })
                break
            case .failure(let encodingError):
                print("failed to upload with error : \(encodingError.localizedDescription)")
            }
        }
        
    }
}



// MARK: - UITextViewDelegate functions
extension FeedbackViewController : UITextViewDelegate {
    
    func feedbackTopicTextFieldBecameActive(){
        self.dropDownTableViewIsActive = true
        self.feedbackTopicTextField.resignFirstResponder()
        self.setResetUserInteraction()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.feedbackTextView.text = ""
        self.feedbackTextView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            feedbackTextView.text = "Notes"
            feedbackTextView.textColor = UIColor.lightGray
        }
    }
    
}



// MARK: - UITableViewDataSource, UITableViewDelegate functions
extension FeedbackViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.problemTypes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath)
        cell.textLabel?.font = UIFont(name: "Avenir", size: 18)
        cell.textLabel?.text = problemTypes[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.feedbackTopicTextField.text = problemTypes[indexPath.row].title
        self.selectedProblemIndex = indexPath.row
        self.dropDownTableViewIsActive = false
        self.setResetUserInteraction()
    }
    
}


// MARK: - Handle touches for dropDownTableView
extension FeedbackViewController {
    
    func setResetUserInteraction(){
        
        self.dropDownTableView.isHidden = !dropDownTableViewIsActive
        self.feedbackTextView.isUserInteractionEnabled = !dropDownTableViewIsActive
        self.sendButton.isUserInteractionEnabled = !dropDownTableViewIsActive
        self.photoButton.isUserInteractionEnabled = !dropDownTableViewIsActive
        self.feedbackTopicTextField.isEnabled = !dropDownTableViewIsActive
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        if touch?.view != dropDownTableView{
            self.dropDownTableViewIsActive = false
            self.setResetUserInteraction()
        }else if (touch?.view != textStackView.superview){
            self.resignFirstResponder()
        }
    }
}



// MARK: - UIImagePickerControllerDelegate functions
extension FeedbackViewController : UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.photoButton.setImage(editedImage, for: .normal)
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            self.photoButton.setImage(originalImage, for: .normal)
            self.imageData = UIImageJPEGRepresentation(originalImage, 1)
        }else{
            self.photoButton.setImage(nil, for: .normal)
        }
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        self.fileName = imageURL.absoluteString
        self.photoButton.layer.masksToBounds = true
        self.photoButton.layer.cornerRadius = 15
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - CLLocationManagerDelegate functions
extension FeedbackViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.locationManager?.stopUpdatingLocation()
        
        if let userLocation = locations.last{
            
            let latlon = "\(String(describing: userLocation.coordinate.latitude)),\(String(describing: userLocation.coordinate.longitude))"
            
            let params = [
                "latlng" : latlon
            ]
            
            Alamofire.request("http://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: params).responseJSON { (response) in
                
                if let responseDict = response.result.value as? [String: Any] {
                    let status = responseDict["status"] as? String
                    if status == "OK"{
                        let resultsArray = responseDict["results"] as? [[String:Any]]
                        if let place = resultsArray?.first?["formatted_address"] {
                            self.locationTextField.text = place as? String
                        }
                    }else{
                        let errorMessage = responseDict["error_message"]
                        print(errorMessage!)
                    }
                }else{
                    print(response.result.error!)
                }
            }
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        print("Failed to get  location \(error.localizedDescription)")
    }
}


// MARK: - UserLocationDelegate functions for reverse geocoding use GoogleAPI
/*Use when LocationVC is instantiated
 extension FeedbackViewController : UserLocationDelegate{
 
 func didSelectLocation(_ locationCord: CLLocationCoordinate2D) {
 
 
 let userAnnotationCoordinate = locationCord;
 if (userAnnotationCoordinate.latitude != 0 && userAnnotationCoordinate.longitude != 0){
 let latlon = "\(userAnnotationCoordinate.latitude),\(userAnnotationCoordinate.longitude)"
 
 let params = [
 "latlng" : latlon
 ]
 
 Alamofire.request("http://maps.googleapis.com/maps/api/geocode/json", method: .get, parameters: params).responseJSON { (response) in
 
 if let responseDict = response.result.value as? [String: Any] {
 let status = responseDict["status"] as? String
 if status == "OK"{
 let resultsArray = responseDict["results"] as? [[String:Any]]
 if let place = resultsArray?.first?["formatted_address"] {
 self.locationTextField.text = place as! String
 }
 }else{
 let errorMessage = responseDict["error_message"]
 print(errorMessage!)
 }
 }else{
 print(response.result.error)
 }
 }
 }
 
 }
 }
 */





