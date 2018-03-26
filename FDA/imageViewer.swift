//
//  imageViewer.swift
//  FDA
//  PURPOSE :-  the current class will be called from every controller where the image is being displayed to give the user to functionality to display the image in bigger area and give the zoom functionality as well
//  Created by Kaustubh on 03/11/17.
//  Copyright © 2017 Aditya. All rights reserved.
//

import UIKit

class imageViewer: UIViewController,UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imgView: UIImageView!
    
    var image1 = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        
        imgView.image = image1
        imgView.isUserInteractionEnabled = true
        scrollView.maximumZoomScale = 4.0;
        scrollView.minimumZoomScale = 1.0;
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        return imgView
    }
        
        
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
