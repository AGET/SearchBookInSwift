//
//  ViewController.swift
//  SeachBook_Swift
//
//  Created by Workstation on 29/04/16.
//  Copyright © 2016 Workstation. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var busqueda: UISearchBar!
    @IBOutlet weak var texto: UITextView!
    @IBOutlet weak var espera: UIActivityIndicatorView!
    
    var tx:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //978-84-376-0494-7
        configureSearchBar()
    }
    
    // MARK: Configuration
    func configureSearchBar() {
        busqueda.showsCancelButton = true
    }
    
    // MARK: UISearchBarDelegate
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        NSLog("Selecciono la scope\(selectedScope).")
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        NSLog("Buscando: \(searchBar.text!).")
        searchBar.resignFirstResponder()
        buscar(busqueda.text!)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        NSLog("Cancelado")
        searchBar.resignFirstResponder()
    }
    //SearchEND
    
    func buscar(isbn: String){
        
        //AsincronoInicio
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        NSLog(urls)
        let url = NSURL(string:urls)
        let sesion = NSURLSession.sharedSession()
        
        let bloque = {(datos:NSData?,resp : NSURLResponse?,error:NSError?) -> Void in
            if error == nil{
                let txt = NSString(data:datos!, encoding: NSUTF8StringEncoding)
                if txt! != "{}"{
                    dispatch_async(dispatch_get_main_queue(),{
                        self.texto.text = txt! as String
                    })
                    
                }else{
                    dispatch_async(dispatch_get_main_queue(),{
                        self.mostrarMensajeSimple("Alerta!", message: "No se encontro", owner: self)
                    })
                }
            }else{
                dispatch_async(dispatch_get_main_queue(),{
                    self.mostrarMensajeSimple("Alerta!", message: "Error de conexion", owner: self)
                })
            }
            dispatch_async(dispatch_get_main_queue(),{
                self.espera.stopAnimating()
            })
        }
        let dt = sesion.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
        //AsincronoFin
        
        
        //Sincrono
        //        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:\(isbn)"
        //        let url = NSURL(string:urls)
        //        let datos:NSData?=NSData(contentsOfURL: url!)
        //        if datos == nil {
        //            mostrarMensajeSimple("Alerta!", message: "Al parecer hay un error en el internet", owner: self)
        //        }else{
        //            let txt = NSString(data:datos!, encoding: NSUTF8StringEncoding)
        //            print(txt!)
        //            if txt! != "{}"{
        //                texto.text = txt! as String
        //            }else{
        //                self.mostrarMensajeSimple("Alerta!", message: "No se encontro", owner: self)
        //            }
        //        }
        //SincronoFin
        self.espera.startAnimating()
    }
    
    @IBAction func limpiar(sender: AnyObject) {
        texto.text = ""
        busqueda.text = ""
    }
    
    func mostrarMensajeSimple (title: String, message: String, owner:UIViewController) {
        let alerta = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alerta.addAction(UIAlertAction(title: "Entiendo", style: UIAlertActionStyle.Default, handler:{ (ACTION:UIAlertAction!)in
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
}

