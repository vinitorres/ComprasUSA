//
//  DBManager.swift
//  AndreTairo
//
//  Created by Vinicius Torres on 01/10/17.
//  Copyright © 2017 Vinicius Torres. All rights reserved.
//

import UIKit
import CoreData

class DBManager: NSObject {
    
    static func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
        
    }
    
    static func addEstado(nome: String, imposto: Double) {
        
        let context = self.getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "Estado", in: context)
        
        let estadoEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        estadoEntity.setValue(nome, forKey: "nome")
        estadoEntity.setValue(imposto, forKey: "imposto")
        
        do {
            try context.save()
            print("estado salvo!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    static func updateEstado(estado: Estado, nome: String, imposto: Double) {
        
        let context = self.getContext()
        
        estado.nome = nome
        estado.imposto = imposto
        
        do {
            try context.save()
            print("estado atualizado!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    static func removerEstado(estado: Estado) {
        
        let context = self.getContext()

        do {
            context.delete(estado)
            try context.save()
            
        } catch {
            print("Error with request: \(error)")
        }
        
    }
    
    static func getEstados() -> [Estado] {
        
        var estados: [Estado] = []
        
        do {
            
            let fetchRequest: NSFetchRequest<Estado> = Estado.fetchRequest()
            
            let searchResults = try self.getContext().fetch(fetchRequest)
            
            print ("num of results = \(searchResults.count)")
            
            for estado in searchResults as [NSManagedObject] {
                estados.append(estado as! Estado)
            }
        } catch {
            print("Error with request: \(error)")
        }
        
        return estados
    }
    
    
    static func addProduto(nome: String, estado: Estado, valor: Double, cartao: Bool, imagem: Any) {
        
        let context = self.getContext()
        let entity =  NSEntityDescription.entity(forEntityName: "Produto", in: context)
        
        let produtoEntity = NSManagedObject(entity: entity!, insertInto: context)
        
        produtoEntity.setValue(nome, forKey: "nomeProduto")
        produtoEntity.setValue(estado, forKey: "estado")
        produtoEntity.setValue(valor, forKey: "valor")
        produtoEntity.setValue(cartao, forKey: "cartao")
        produtoEntity.setValue(imagem, forKey: "image")
        
        do {
            try context.save()
            print("produto salvo!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    static func updateProduto(produtoAntigo: Produto, nome: String, estado: Estado, valor: Double, cartao: Bool, imagem: Any) {
        
        let context = self.getContext()
        
        produtoAntigo.nomeProduto = nome
        produtoAntigo.valor = valor
        produtoAntigo.cartao = cartao
        produtoAntigo.estado = estado
        
        produtoAntigo.setValue(imagem, forKey: "image")
        
        do {
            try context.save()
            print("produto atualizado!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }

    }
    
    static func getProdutos() -> [Produto] {
        
        var produtos: [Produto] = []
        
        do {
            
            let fetchRequest: NSFetchRequest<Produto> = Produto.fetchRequest()
            
            let searchResults = try self.getContext().fetch(fetchRequest)
            
            print ("num of results = \(searchResults.count)")
            
            for produto in searchResults as [NSManagedObject] {
                produtos.append(produto as! Produto)
            }
        } catch {
            print("Error with request: \(error)")
        }
        
        return produtos
    }
    
    static func removerProduto(produto: Produto) {
        
        let context = self.getContext()
        
        do {
            context.delete(produto)
            try context.save()
            
        } catch {
            print("Error with request: \(error)")
        }
        
    }
    
}
