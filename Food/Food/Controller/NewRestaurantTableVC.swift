//
//  NewRestaurantTableVC.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/12/8.
//

import UIKit

class NewRestaurantTableVC: UITableViewController {
    
    var restaurant: Restaurant!
    
    @IBOutlet var photoImageView: UIImageView! {
        didSet {
            photoImageView.layer.cornerRadius = 10.0
            photoImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet var nameTextField: RoundedTF! {
        didSet {
            nameTextField.tag = 1
            //nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    
    @IBOutlet var typeTextField: RoundedTF! {
        didSet {
            typeTextField.tag = 2
            typeTextField.delegate = self
        }
    }
    
    @IBOutlet var addressTextField: RoundedTF! {
        didSet {
            addressTextField.tag = 3
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet var phoneTextField: RoundedTF! {
        didSet {
            phoneTextField.tag = 4
            phoneTextField.delegate = self
        }
    }
    
    @IBOutlet var descTextView: UITextView! {
        didSet {
            descTextView.tag = 5
            descTextView.layer.cornerRadius = 10.0
            descTextView.layer.masksToBounds = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //取消分隔符
        tableView.separatorStyle = .none
        //去掉左边的滚动条
        tableView.showsVerticalScrollIndicator = false
        //不隐藏滑动时顶部的bar显示
        navigationController?.hidesBarsOnSwipe = false
        
        //自定导航栏
        if let appearance = navigationController?.navigationBar.standardAppearance {
            
            appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "mainColor")!]
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "mainColor")!]
            
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        //MARK: 用代码实现约束布局-photoImageView
        //取得父视图
        let margins = photoImageView.superview!.layoutMarginsGuide
        //停用自动调整大小的覆盖 以代码的方式来使用自动布局
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        photoImageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        photoImageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        photoImageView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        photoImageView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
        //点击空白区域关闭键盘
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }
    
    //MARK: save按钮
    @IBAction func saveButton(sender: UIButton) {
        if nameTextField.text == "" || typeTextField.text == "" || addressTextField.text == "" || phoneTextField.text == "" || descTextView.text == "" {
            let alertController = UIAlertController(title: "哎呀😲", message: "请依次填入正确的信息", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        }
        
        print("Name: \(nameTextField.text ?? "")")
        print("Type: \(typeTextField.text ?? "")")
        print("Location: \(addressTextField.text ?? "")")
        print("Phone: \(phoneTextField.text ?? "")")
        print("Description: \(descTextView.text ?? "")")
        
        //存取新资源
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            
            restaurant = Restaurant(context: appDelegate.persistentContainer.viewContext)
            restaurant.name = nameTextField.text!
            restaurant.type = typeTextField.text!
            restaurant.location = addressTextField.text!
            restaurant.phone = phoneTextField.text!
            restaurant.summary = descTextView.text!
            restaurant.isFavorite = false
            
            if let imageData = photoImageView.image?.pngData() {
                restaurant.image = imageData
            }
            
            print("已保存")
            appDelegate.saveContext()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: 选择照片发布
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let photoSourceRequesController = UIAlertController(title: "", message: "添加图片", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "拍照", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            let photoLibraayAction = UIAlertAction(title: "相册", style: .default, handler: {(action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
            })
            
            //点击空白区域也可以取消
            let alertAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            photoSourceRequesController.addAction(cameraAction)
            photoSourceRequesController.addAction(photoLibraayAction)
            photoSourceRequesController.addAction(alertAction)
            
            //ipad错误
            if let popoverController = photoSourceRequesController.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
            }
            
            present(photoSourceRequesController, animated: true, completion: nil)
        }
    }

    
}

//MARK: 点击输入法的return 跳转到下一行
extension NewRestaurantTableVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //取得下一行TextField
        if let nextTextField = view.viewWithTag(textField.tag + 1) {
            //移除目前TextField的焦点 赚到下一行
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
}

//MARK: 获取Info提示
extension NewRestaurantTableVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            photoImageView.image = selectedimage
            photoImageView.contentMode = .scaleAspectFill
            photoImageView.clipsToBounds = true
        }
        
        dismiss(animated: true, completion: nil)
    }
}

