//
//  ViewController.swift
//  ZFFixImageOrentation
//
//  Created by 钟凡 on 2020/11/23.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func pickimage(sender: UIButton) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.sourceType = .camera
        present(vc, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
}
extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var image = info[.originalImage] as? UIImage
        
        var cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        cacheUrl?.appendPathComponent("123.png")
        //修复图片方向
        image = image?.fiexdOrientation()
        let imageData = image?.pngData()
        do {
            try imageData?.write(to: cacheUrl!)
        } catch let error {
            print(error)
        }
        
        picker.dismiss(animated: true, completion: nil)
        
        let vc = WebViewController()
        vc.fileUrl = cacheUrl
        vc.pathUrl = cacheUrl
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension ViewController: UINavigationControllerDelegate {
    
}
