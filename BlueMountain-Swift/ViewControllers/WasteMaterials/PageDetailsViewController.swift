//
//  PageDetailsViewController.Swift
//  BlueMountain-Swift
//
//  Created by Ashim Dhakal on 10/11/17.
//  Copyright © 2017 Prashant Sah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class PageDetailsViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var mapView : MKMapView!
    
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageDetailsView: UIWebView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var receivedPage : Pages?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CustomNavigationBar.titleText = "Materials"
        self.configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let customNavBar = self.navigationController?.navigationBar as? CustomNavigationBar
        customNavBar?.leftButton.setImage(#imageLiteral(resourceName: "leftBut"), for: .normal)
        customNavBar?.leftButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        customNavBar?.buttonType = CustomNavigationBar.NavigationButtonType.back.rawValue
    }
    
    func backButtonClicked() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if mapView != nil{
            self.mapView.removeFromSuperview()
            self.mapView = nil
        }
        if pageDetailsView != nil{
        self.pageDetailsView.removeFromSuperview()
        self.pageDetailsView = nil
        }
    }
    
}


// MARK: - Configure the view based on received "Pages" Object
extension PageDetailsViewController {
    
    func configureView(){
        
        if (receivedPage?.latitude?.isEmpty)! {
            self.mapViewHeightConstraint.constant = 0
            self.mapView = nil
        }else{
            
            var region = MKCoordinateRegion()
            let location = CLLocationCoordinate2DMake(Double((receivedPage?.latitude)!)!, Double((receivedPage?.longitude)!)!)
            region.center = location
            region.span = MKCoordinateSpanMake(0.01, 0.01)
            self.mapView.setRegion(region, animated: true)
            
            let annotationPoint = MKPointAnnotation()
            annotationPoint.coordinate = location
            annotationPoint.title = ""
            self.mapView.addAnnotation(annotationPoint)
            
        }
        
        self.titleLabel.text = self.receivedPage?.pageTitle
        
        if let pageContent = receivedPage?.pageContent{
            
            let headerString = "<meta name=\"viewport\" content=\"initial-scale=2.0\" /> \n"
            let modifiedPageContent = headerString + pageContent
            self.pageDetailsView.loadHTMLString(modifiedPageContent, baseURL: nil)
        }
        
        let parentVC = self.navigationController?.viewControllers.first
        if(parentVC?.isKind(of: CalendarViewController.self))!{
            
            let headerString = "<meta name=\"viewport\" content=\"initial-scale=2.0\" /> \n"
            let HTMLContent = headerString + (receivedPage?.allowed)!
            self.pageDetailsView.loadHTMLString(HTMLContent, baseURL: nil)
        }
    }

}



