//
//  ViewController.swift
//  THE Highland Exchange
//
//  Created by Rohit SIngh Dhakad on 12/08/23.
//

import UIKit
import WebKit
import CoreLocation


class ViewController: UIViewController {
    
    @IBOutlet var webVw: WKWebView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    var locationManager: CLLocationManager?
    let configuration = WKWebViewConfiguration()
    let wkPreferences = WKPreferences()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        //Make sure to set the delegate, to get the call back when the user taps Allow option
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        wkPreferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = wkPreferences
        webVw.navigationDelegate = self
        webVw.uiDelegate = self
        webVw.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let url = "https://thehighlandexchange.com/?v=3e8d115eb4b3"
        
        self.loadUrl(strUrl: url)
        
    }
    
    func loadUrl(strUrl:String){
        let url = NSURL(string: strUrl)
        let request = NSURLRequest(url: url! as URL)
        self.webVw.load(request as URLRequest)
    }
    
    
}


extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: message, message: nil,
                                                preferredStyle: UIAlertController.Style.alert);
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel) {
            _ in completionHandler()}
        );
        
        self.present(alertController, animated: true, completion: {});
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        switch navigationAction.request.url?.scheme {
        case "tel":
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            break
        default:
            decisionHandler(.allow)
            break
        }
    }
}


extension ViewController: WKNavigationDelegate{
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.activityIndicator.startAnimating()
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        self.activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        
    }
}

//Location Permission popup
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("not determined - hence ask for Permission")
            manager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("permission denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("Apple delegate gives the call back here once user taps Allow option, Make sure delegate is set to self")
        @unknown default:
            fatalError()
        }
    }
}
