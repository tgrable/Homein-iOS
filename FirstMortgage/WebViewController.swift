//
//  WebViewController.swift
//  FirstMortgage
//
//  Created by Timothy C Grable on 10/28/15.
//  Copyright © 2015 Trekk Design. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    // MARK:
    // MARK: Properties
    @IBOutlet weak var fmcWebView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlPath: String = "http://www.firstmortgageco.com"
        fmcWebView.loadRequest(NSURLRequest(URL: NSURL(string: urlPath)!))
        fmcWebView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:
    // MARK: Actions
    @IBAction func goBack(sender: UIButton) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        print("Webview fail with error \(error)");
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    func webViewDidStartLoad(webView: UIWebView) {
        print("Webview started Loading")
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        print("Webview did finish load")
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
