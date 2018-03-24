//
//  AboutGameViewController.swift
//  AimForThat2018
//
//  Created by droal_ara on 8/02/18.
//  Copyright © 2018 droal. All rights reserved.
//

import UIKit

class AboutGameViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.btnBack.titleLabel?.adjustsFontSizeToFitWidth = true
        self.btnBack.titleLabel?.numberOfLines = 0
        self.btnBack.titleLabel?.baselineAdjustment = UIBaselineAdjustment.alignCenters
        self.btnBack.titleLabel?.minimumScaleFactor = 0.2
        
        //BUNDLE es la representación de toda la aplicación empaquetada (codigo, recursos, etc)
        //Bundle es compartido por toda la aplicación
        //Accedemos al recurso html si existe
        
        
        //if let url = Bundle.main.url(forResource: "AimForThat", withExtension: "html")
        if let url = URL(string: "https://www.apple.com")
        {
            //Transformar el archivo html en fichero de datos
            if let htmlData = try? Data(contentsOf: url){
                
                //obtener la direccion base de archivos de la aplicacion
                let baseUrl =  URL(fileURLWithPath: Bundle.main.bundlePath)
                
                //cargar los datos en el WebView
                self.webView.load(htmlData, mimeType: "text/html", textEncodingName: "UTF-8", baseURL: baseUrl)
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func btnBackPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
