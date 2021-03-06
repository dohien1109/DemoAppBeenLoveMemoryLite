//
//  MealViewController.swift
//  DemoAppBeenLoveMemoryLite
//
//  Created by dohien on 05/09/2018.
//  Copyright © 2018 dohien. All rights reserved.
//
import UIKit
import os.log
class MealViewController: UIViewController , UITextFieldDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var meal: Meal?

    @IBOutlet weak var centerName: NSLayoutConstraint!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // có thể bấm nút cancel quay lại mà k lưu thay đổi đối với bữa ăn
          navigationController?.dismiss(animated: true, completion: nil)
      
    }
    @IBOutlet weak var ratingControl: RatingController!
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        if let  meal = meal {
            navigationItem.title = meal.name
            nameTextField.text = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        updateSaveButtonSate()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerName.constant -= view.bounds.width
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.centerName.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonSate()
        // đặt tiêu đề
        navigationItem.title = textField.text
    }
    func  textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true , completion:  nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // cấu hình bộ điều khiển chế độ xem đích khi nhấn nút lưu
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default,type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    private func updateSaveButtonSate(){
        //  tắt nút lưu nếu trường văn bản trống
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
