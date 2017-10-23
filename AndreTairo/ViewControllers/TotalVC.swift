//
//  TotalVC.swift
//  AndreTairo
//
//  Created by Vinicius Torres on 01/10/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit

class TotalVC: UIViewController {
    
    @IBOutlet weak var totalUS: UILabel!
    @IBOutlet weak var totalRS: UILabel!
    
    var arrayProdutos: [Produto] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadData()
    }
    
    func loadData() {
        
        var totalDolar = 0.0
        var totalReais = 0.0
        
        arrayProdutos = DBManager.getProdutos()
        
        var dolar = 0.0
        var iof = 0.0

        if let dolarPrefs = Prefs.getDolarValue() {
            dolar = dolarPrefs
        }
        
        if let iofPrefs = Prefs.getIOF() {
         iof = iofPrefs
        }
        
        if arrayProdutos.count > 0 {
                        
            for produto in arrayProdutos {
                
                var valor = produto.valor
                
                print(valor)
                
                totalDolar += valor
                
                valor = valor*dolar
                print(valor)
                
                let impostoEstado = (produto.estado!.imposto/100) + 1
                valor = valor*impostoEstado
               
                print(valor)
                if produto.cartao {
                    
                    let multiplicadorIOF = iof/100.0 + 1.0
                    
                    valor = valor*multiplicadorIOF
                    
                }
                print("valor em reais: \(valor)")
                totalReais += valor
            }
            
            totalUS.text = totalDolar.description
            totalRS.text = totalReais.description
            
        } else {
            totalUS.text = "-"
            totalRS.text = "-"
        }
        
    }
    
}
