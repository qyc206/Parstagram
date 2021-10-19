//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Qin Ying Chen on 10/19/21.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        // tell parse to create a table
        let post = PFObject(className: "Posts")
        
        // define schema of table
        post["caption"] = commentField.text
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()  // save image as a png
        let file = PFFileObject(name: "image.png", data: imageData!)   // binary image saved in a diff place in parse
        post["image"] = file    // store url where the binary photo is stored
        
        post.saveInBackground { success, error in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("saved!")
            } else {
                print("error!")
            }
        }
        
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self  // get photo that the user took
        picker.allowsEditing = true // present a second screen to allow user to modify image
        
        // check if the camera is available
        if  UIImagePickerController.isSourceTypeAvailable(.camera){
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        // resize image
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        // display image
        imageView.image = scaledImage
        
        // dismiss camera view
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
