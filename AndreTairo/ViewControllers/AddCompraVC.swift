//
//  AddCompraVC.swift
//  AndreTairo
//
//  Created by Vinicius Torres on 01/10/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class AddCompraVC: UIViewController {
    
    @IBOutlet weak var nomeTF: UITextField!
    @IBOutlet weak var estadoTF: UITextField!
    @IBOutlet weak var valorTF: UITextField!
    @IBOutlet weak var cartaoSwitch: UISwitch!
    @IBOutlet weak var imagemIV: UIImageView!
    @IBOutlet weak var cadastrarBtn: UIButton!

    
    var picker = UIPickerView()
    var smallImage: UIImage!
    
    let nome = ""
    let valor = 0.0
    let cartao = false
    let imagem = UIImage()
    var estado: Estado?

    var estados: [Estado] = []
    
    var isEdit: Bool = false
    var produtoEditavel: Produto?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nomeTF.returnKeyType = .done
        nomeTF.delegate = self
        
        //picker estados
        
        picker.delegate = self
        picker.dataSource = self
        
        let toolbarEstado = UIToolbar()
        toolbarEstado.sizeToFit()
        let doneButtonEstado = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(selecionarEstado))
        let espace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbarEstado.items = [espace,doneButtonEstado]
        
        
        estadoTF.addTarget(self, action: #selector(AddCompraVC.addPicker), for: .touchDown)
        
        estadoTF.inputAccessoryView = toolbarEstado
        
        //toolbar valor
        
        let toolbarValor = UIToolbar()
        toolbarValor.sizeToFit()
        let doneButtonValor = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(setValor))
        
        toolbarValor.items = [espace,doneButtonValor]

        
        valorTF.inputAccessoryView = toolbarValor
        
        //image action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddCompraVC.imageTapped(tapGestureRecognizer:)))
        imagemIV.isUserInteractionEnabled = true
        imagemIV.addGestureRecognizer(tapGestureRecognizer)
        
        if isEdit {
            loadData()
        }
        
        
    }
    
    func loadData() {
        nomeTF.text = produtoEditavel?.nomeProduto
        imagemIV.image = produtoEditavel?.image as? UIImage
        estado = produtoEditavel?.estado
        estadoTF.text = estado?.nome
        cartaoSwitch.isOn = (produtoEditavel?.cartao)!
        valorTF.text = produtoEditavel?.valor.description
        
        
        cadastrarBtn.setTitle("Atualizar", for: .normal)
    }
    
    @objc func addPicker() {
        if estados.count > 0 {
            if (estadoTF.text?.isEmpty)! {
                estado = estados[0]
                estadoTF.text = estado?.nome
            }
            estadoTF.inputView = picker
        } else {
            let alert = UIAlertController(title: "Erro!", message: "Você deve cadastrar pelo menos um estado antes de prosseguir.", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        estados = DBManager.getEstados()
    }
    
    @objc func setValor() {
        
        valorTF.endEditing(true)
        
    }
    
    @objc func selecionarEstado() {
        
        estadoTF.resignFirstResponder()
        
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        let alert = UIAlertController(title: "Selecionar imagem", message: "Selecione a fonte da imagem", preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default, handler: { (action: UIAlertAction) in
                self.selectPicture(sourceType: .camera)
            })
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de fotos", style: .default) { (action: UIAlertAction) in
            self.selectPicture(sourceType: .savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func selectPicture(sourceType: UIImagePickerControllerSourceType) {
        
        //Criando o objeto UIImagePickerController
        let imagePicker = UIImagePickerController()
        
        //Definimos seu sourceType através do parâmetro passado
        imagePicker.sourceType = sourceType
        
        //Definimos a MovieRegisterViewController como sendo a delegate do imagePicker
        imagePicker.delegate = self
        
        //Apresentamos a imagePicker ao usuário
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    @IBAction func cadastrar(_ sender: Any) {
            
        if !(nomeTF.text?.isEmpty)! && !(estadoTF.text?.isEmpty)! && !(valorTF.text?.isEmpty)! && imagemIV.image != nil {
            
            if imagemIV.image != UIImage(named: "gift") {
                
                let nome = nomeTF.text!
                let valor = Double(valorTF.text!)
                let cartao = cartaoSwitch.isOn
                let imagem = imagemIV.image!
                
                if isEdit {
                    DBManager.updateProduto(produtoAntigo: produtoEditavel!, nome: nome, estado: self.estado!, valor: valor!, cartao: cartao, imagem: imagem)
                } else {
                    DBManager.addProduto(nome: nome, estado: self.estado!, valor: valor!, cartao: cartao, imagem: imagem)
                    
                }
                
                self.navigationController?.popViewController(animated: true)
                
            } else {
                
                let alert = UIAlertController(title: "Erro!", message: "Você deve selecionar uma imagem para o produto", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Erro!", message: "Você deve preencher todos os campos para cadastrar um produto", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okButton)
            self.present(alert, animated: true, completion: nil)
        }
            
        
    
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/5
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/5
            }
        }
    }
    
}

extension AddCompraVC: UIPickerViewDelegate,UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return estados.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return estados[row].nome
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != -1 {
            estado = estados[row]
            estadoTF.text = estado?.nome
        }
    }
}

extension AddCompraVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        
        let smallSize = CGSize(width: 300, height: 200)
        UIGraphicsBeginImageContext(smallSize)
        image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
        
        smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imagemIV.image = smallImage
        
        dismiss(animated: true, completion: nil)
    }
}

extension AddCompraVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nomeTF.endEditing(true)
        
        return true
    }
}

