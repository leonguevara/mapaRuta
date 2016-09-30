//
//  ViewController.swift
//  EjemploRuta
//
//  Created by León Felipe Guevara Chávez on 7/12/16.
//  Copyright © 2016 León Felipe Guevara Chávez. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapaRuta: MKMapView!
    
    private var origen : MKMapItem!
    private var destino : MKMapItem!
    private var unoMas : MKMapItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapaRuta.delegate = self
        
        var puntoCoor = CLLocationCoordinate2D(latitude: 19.359727, longitude: -99.257700)
        var puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        origen = MKMapItem(placemark: puntoLugar)
        origen.name = "Tecnológico de Monterrey Campus Santa Fé"
        
        puntoCoor = CLLocationCoordinate2D(latitude: 19.362896, longitude: -99.268856)
        puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        destino = MKMapItem(placemark: puntoLugar)
        destino.name = "Centro Comercial Santa Fé"
        
        puntoCoor = CLLocationCoordinate2D(latitude: 19.358543, longitude: -99.276304)
        puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        unoMas = MKMapItem(placemark: puntoLugar)
        unoMas.name = "Glorieta"
        
        self.anotaPunto(origen!)
        self.anotaPunto(destino!)
        self.anotaPunto(unoMas!)
        
        self.obtenerRuta(self.origen!, destino: self.destino!)
        self.obtenerRuta(self.destino!, destino: self.unoMas!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func anotaPunto(punto : MKMapItem) {
        let anota = MKPointAnnotation()
        anota.coordinate = punto.placemark.coordinate
        anota.title = punto.name
        mapaRuta.addAnnotation(anota)
    }

    func obtenerRuta(origen: MKMapItem, destino: MKMapItem) {
        let solicitud = MKDirectionsRequest()
        solicitud.source = origen
        solicitud.destination = destino
        solicitud.transportType = .Walking
        let indicaciones = MKDirections(request: solicitud)
        indicaciones.calculateDirectionsWithCompletionHandler({
            (respuesta: MKDirectionsResponse?, error: NSError?) in
            if error != nil {
                print("Error al obtener la ruta")
            } else {
                self.muestraRuta(respuesta!)
            }
        })
    }

    func muestraRuta(respuesta: MKDirectionsResponse) {
        for ruta in respuesta.routes {
            mapaRuta.addOverlay(ruta.polyline, level: MKOverlayLevel.AboveRoads)
            for paso in ruta.steps {
                print(paso.instructions)
            }
        }
        let centro = origen.placemark.coordinate
        let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
        mapaRuta.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        return renderer
    }
}

