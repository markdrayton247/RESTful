//
//  EditViewController.swift
//  RESTful
//
//  Created by Mark Drayton on 14/07/2016.
//  Copyright © 2016 Mark Drayton Ltd. All rights reserved.
//

protocol UpdateTitleDelegate {
    func writeValueBack(title: String, id: String)
}


import UIKit

class EditViewController: UIViewController, UITextFieldDelegate {
    
    var _title: String?
    var _id: String?
    var delegate: UpdateTitleDelegate?

    @IBOutlet weak var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        titleField.text = _title
    }
    
    override func viewWillDisappear(animated: Bool) {
        self._title = titleField.text
        delegate?.writeValueBack(titleField.text!, id: self._id!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        self.navigationController!.popViewControllerAnimated(true)
        return false
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
