//
//  ListaComprasTVC.swift
//  AndreTairo
//
//  Created by Vinicius Torres on 01/10/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class ListaComprasTVC: UITableViewController {
    
    var arrayProdutos: [Produto] = []
    var selected: Int = -1
 
    let spaceBetweenSections:CGFloat = 6.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
    }
    
    func loadData() {
        
        arrayProdutos = DBManager.getProdutos()
        
        tableView.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        selected = -1
        loadData()
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        var numOfSection: Int = 0
        
        if arrayProdutos.count > 0 {
            
            self.tableView.backgroundView = nil
            numOfSection = arrayProdutos.count
            
        } else {
            
            let noDataLabel: UILabel = UILabel(frame: CGRect(x:0,y:0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noDataLabel.text = "Sua lista está vazia!"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noDataLabel
            
        }
        return numOfSection
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProdutoTableViewCell
        
        cell.nomeLbl.text = arrayProdutos[indexPath.section].nomeProduto
        cell.valorLbl.text = arrayProdutos[indexPath.section].valor.description
        cell.estadoLbl.text = arrayProdutos[indexPath.section].estado?.nome ?? "Indefinido"
        
        if arrayProdutos[indexPath.section].cartao {
            cell.cartaoLbl.text = "Cartão"
        } else {
            cell.cartaoLbl.text = "Dinheiro"
        }
        
        cell.imagemIV.image = arrayProdutos[indexPath.section].image as? UIImage
        
        cell.selectionStyle = .none
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 5
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else {
            return spaceBetweenSections
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let edit = UITableViewRowAction(style: .normal, title: "Editar") { (action, index) in
            self.selected = indexPath.section
            self.performSegue(withIdentifier: "detalhesSegue", sender: self)
        }
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            DBManager.removerProduto(produto: self.arrayProdutos[indexPath.row])
            
            self.loadData()
        }
        
        return [delete,edit]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detalhesSegue" {
            let destination = segue.destination as! AddCompraVC
            if selected != -1 {
                destination.isEdit = true
                destination.produtoEditavel = arrayProdutos[self.selected]
            }
        }
    }
}

