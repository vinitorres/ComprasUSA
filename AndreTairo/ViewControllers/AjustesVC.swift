//
//  AjustesVC.swift
//  AndreTairo
//
//  Created by Vinicius Torres on 01/10/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class AjustesVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var addEstadoBtn: UIView!
    @IBOutlet weak var dolarValueTF: UITextField!
    @IBOutlet weak var iofValueTF: UITextField!
    
    var iof = 0.0
    var dolar = 0.0
    
    var isEdit = false
    
    weak var nomeOK: UITextField?
    weak var impostoOK: UITextField?
    
    weak var alertActionAdd: UIAlertAction?

    var arrayEstados: [Estado] = []
    
    let toolbar = UIToolbar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dolar = UserDefaults.standard.double(forKey: Prefs.KEY_DOLAR)
        
        iof = UserDefaults.standard.double(forKey: Prefs.KEY_IOF)
        
        
        dolarValueTF.delegate = self
        iofValueTF.delegate = self
        
        dolarValueTF.text = dolar.description
        iofValueTF.text = iof.description
        
        dolarValueTF.tag = 5
        iofValueTF.tag = 6
        
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(AjustesVC.save))
        let espace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.items = [espace,doneButton]
        
        dolarValueTF.inputAccessoryView = toolbar
        iofValueTF.inputAccessoryView = toolbar
        
    }
    
    @IBAction func adicionarEstado(_ sender: Any) {
        
        alertWithTextfield(estado: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadData()
        
    }
    
    func loadData() {
        arrayEstados = DBManager.getEstados()
        tableView.reloadData()
    }
    
    func alertWithTextfield(estado: Estado?) {
        
        let alert = UIAlertController(title: "Adicionar Estado", message: "", preferredStyle: .alert)
        
        alert.addTextField { (estadoTF) in
            
            estadoTF.tag = 10
            estadoTF.placeholder = "Nome do estado"
            estadoTF.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)

            self.nomeOK = estadoTF
            if estado != nil {
                estadoTF.text = estado?.nome
            }
        }
        
        alert.addTextField { (impostoTF) in
            
            impostoTF.tag = 11
            impostoTF.placeholder = "Imposto"
            impostoTF.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)

            self.impostoOK = impostoTF
            if estado != nil {
                impostoTF.text = estado?.imposto.description
            }
            
        }
        
        var title = "Adicionar"
        
        if isEdit {
            title = "Atualizar"
        }
        
        let addAction = UIAlertAction(title: title, style: .default) { (action) in
            print("adicionar")
            
            var nome = ""
            var imposto = 0.0
            
            for textfield in alert.textFields! {
                if textfield.tag == 10 {
                    nome = textfield.text!
                }
                
                if textfield.tag == 11 {
                    imposto = Double(textfield.text!)!
                }
            }
            
            if self.isEdit {
                DBManager.updateEstado(estado: estado!, nome: nome, imposto: imposto)
                self.isEdit = false
            } else {
                DBManager.addEstado(nome: nome, imposto: imposto)
            }
            
            self.arrayEstados = DBManager.getEstados()
            
            self.tableView.reloadData()
        }
        
        alertActionAdd = addAction
        
        self.alertActionAdd?.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func save() {
        Prefs.setIOF(iof)
        self.view.endEditing(true)
    }
    
    @objc func textChanged(_ sender:UITextField) {
        if !(nomeOK?.text?.isEmpty)! && !(impostoOK?.text?.isEmpty)! {
            self.alertActionAdd?.isEnabled  = true
        }else{
            self.alertActionAdd?.isEnabled  = false
        }
    }
    
}

extension AjustesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSection: Int = 0
        
        if arrayEstados.count > 0 {
            
            self.tableView.backgroundView = nil
            numOfSection = 1
            
        } else {
            
            self.tableView.separatorColor = .clear
            let noDataLabel: UILabel = UILabel(frame: CGRect(x:0,y:0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noDataLabel.text = "Lista de estados vazia!"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noDataLabel
            
        }
        return numOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayEstados.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "estadoCell")
        
        cell?.textLabel?.text = arrayEstados[indexPath.row].nome
        cell?.detailTextLabel?.text = arrayEstados[indexPath.row].imposto.description
        cell?.detailTextLabel?.textColor = UIColor.red
        
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor.lightGray
        
        cell?.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        return view
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Editar") { (action, index) in
            self.isEdit = true
            self.alertWithTextfield(estado: self.arrayEstados[indexPath.row])
        }
        
        let delete = UITableViewRowAction(style: .default, title: "Delete") { (action, index) in
            
            DBManager.removerEstado(estado: self.arrayEstados[indexPath.row])
            
            self.loadData()
        }
        
        return [delete,edit]
    }
    
}

extension AjustesVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == dolarValueTF {
            print("entrou aqui")
            Prefs.setDolarValue(Double(textField.text!))
        }
        
        if textField == iofValueTF {
            Prefs.setIOF(Double(textField.text!))
        }
    }
}

