//
//  ViewController.swift
//  AimForThat2018
//
//  Created by droal_ara on 7/02/18.
//  Copyright © 2018 droal. All rights reserved.
//

//Libreria para interfaz grafica
import UIKit
//Libreria para hacer animaciones
import QuartzCore

class ViewController: UIViewController {

    var currentValue : Int = 0
    var targetValue : Int = 0
    var score : Int = 0
    var round : Int = 0
    var time : Int = 0
    var timer : Timer?
    var maxScore = 0

    
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        resetGame()
        updateLabels()
        setupSlider()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setupSlider(){
        
        let thumbImageNormal = UIImage(named:"SliderThumb-Normal")
        //let thumbImageNormal = UIImage(named:"SliderThumb-Highlighted")
        let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        let trackLeftImage = UIImage(named : "SliderTrackLeft")
        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
    
        //configurar el indicador
        self.slider.setThumbImage(thumbImageNormal, for: .normal)
        self.slider.setThumbImage(thumbImageHighlighted, for: .highlighted)
        
        //recortar la imagen de fondo ddel slide
        //está tomando de trackLeft 15 pixeles a la izquierda y 15 pixeles a la derecha
        //Esta parte se etirarara para formar el fondo del slide
        let insets = UIEdgeInsetsMake(0, 15, 0, 15)
        
        let trackLeftResized = trackLeftImage?.resizableImage(withCapInsets: insets)
        let trackRightResized = trackRightImage.resizableImage(withCapInsets: insets)
        //Configurar imagenes del slider
        self.slider.setMinimumTrackImage(trackLeftResized, for: .normal)
        self.slider.setMaximumTrackImage(trackRightResized, for: .normal)
        
    }
    
    
    @IBAction func btnShowAlert() {
        
        //Calcular error de acierto y puntuación de la ronda
        let difference : Int = abs(self.currentValue - self.targetValue)
        var points  : Int = 100 - difference
        let tittle : String
        
        switch difference{
        case 0:
            tittle = "Puntuación perfecta"
            points = Int(10 * Float(points))
        case 1...5:
            tittle = "Casi perfecto!"
            points = Int(1.5 * Float(points))
        case 6...12:
            tittle = "Te ha faltado poco..."
            points = Int(1.2 * Float(points))
        default:
            tittle = "Has caido lejos!"
            
        }
        // puntuación acumulada
        self.score += points
        let message = "Has marcado: \(points) puntos"
        
        //#preferredStyle:
        //.actionSheet ->Mensaje de alerta con botones uno abajo de otro
        //.alert ->Mensaje de alerta con botones uno al lado de otro
        let alert = UIAlertController(title: tittle, message: message, preferredStyle: .actionSheet)
        
        
        //#UIAlertAction(title: <#T##String?#>, style: <#T##UIAlertActionStyle#>, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
        //style ->default: texto normal, cancel: texto en negrilla, destructive:texto en rojo
        //handler ->Si se quiere ejecutar codigo adicional
        let actionButton = UIAlertAction(title: "OK", style: .destructive, handler:
        {action in
            self.newRound()
            self.updateLabels()
        })
        
        
        //agergar la accion a la alerta
        alert.addAction(actionButton)
        
        //#present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil)
        //UIViewController ->ViewController a presentar, en este caso la alert es un ViewController
        //animated ->true, muestra una animacion de fundido
        //completion ->Si se quiere ejecutar algun código una vez finalice la presentación, por default es nil
        present(alert, animated: true)

    }
    
    @IBAction func slSliderMoved(_ sender: UISlider) {
        
        //sender.value retorna un float y currentValue es entero, se podria hacer cast o redondear
        //lroundf ->redondea eliminando puntos decimales: 2.2->2
        //roundf ->redondea manteniendo decimales: 2.2->2.0
        self.currentValue = lroundf(sender.value)
    }
    
    //GENERAR NUEVA RONDA
    func newRound(){
        //arc4random_uniform(100) ->genera un numero float aleatorio entre 0 y 99 donde todos los numeros son igualmente probables
        self.targetValue = Int(arc4random_uniform(100))+1
        self.currentValue = 50
        self.slider.value = Float(self.currentValue)
        self.round += 1
    }
    
    //Actualizar labels
    func updateLabels(){
        self.targetLabel.text = "\(self.targetValue)"
        self.scoreLabel.text = "\(self.score)"
        self.roundLabel.text = "\(self.round)"
        self.timeLabel.text = "\(self.time)"
        self.recordLabel.text = "\(self.maxScore)"
    }
    
    @IBAction func btnStartNewGame() {
        self.saveMaxPunctuation()
        
        //Crear una animacion(transicion) empleando la libreria QuartzCore
        let transition = CATransition()
        transition.type = kCATransitionFade//fundido
        transition.duration = 5 //segundos
        //(opcional)transición lenta al principio y rapida al final
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        //se agrega la animacion a la vista, se puede agregar un identificador para referenciarlo en el codigo
        self.view.layer.add(transition, forKey: nil)
    }
    
    func resetGame(){

        //reiniciar variables
        self.score = 0
        self.round = 0
        self.time = 60
        
        //invalidar si existe un timer corriendo
        if(timer != nil){
            timer?.invalidate()
        }
        
        //timeInterval ->tiempo de repeticion (1segundo)
        //target ->la clase que va a ejecutar el timer (this)
        //selector ->metodo a ejecutar
        //userInfo ->informacion adicional
        //repeats ->debe repetirse
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        
        
        self.updateLabels()
        
        self.newRound()
    }
    
    //funcion de timer cada segundo
    @objc func tick(){
        self.time -= 1
        self.timeLabel.text = "\(self.time)"
        
        if(self.time <= 0){
            timer?.invalidate()
           self.saveMaxPunctuation()
        }
    }
    
    
    func saveMaxPunctuation(){
        //Emplear la clase UserDefaults para almacenar datos de manera global (la mejor puntuacion)
        self.maxScore = UserDefaults.standard.integer(forKey: "maxScore")
        
        if maxScore < self.score{
            self.maxScore = self.score
            UserDefaults.standard.set(self.maxScore, forKey: "maxScore")
        }
        let message = """
        La puntuación máxima es: \(UserDefaults.standard.integer(forKey: "maxScore"))
        Quieres intentar de nuevo!
        """
        let alert = UIAlertController(title: "Se terminó el tiempo", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler:
        {action in
            self.resetGame()
        })
        alert.addAction(action)
        present(alert, animated: true)
    }
}

