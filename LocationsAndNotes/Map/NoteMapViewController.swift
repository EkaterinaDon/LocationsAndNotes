//
//  NoteMapViewController.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 27.04.21.
//

import UIKit
import MapKit

// MARK: - Annotations

class NoteAnnotation: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var note: Note
    
    // MARK: - Init
    
    init(note: Note) {
        self.note = note
        title = note.name
        if let coordinates = note.locationActual {
            coordinate = CLLocationCoordinate2D(latitude: coordinates.lat, longitude: coordinates.lon)
        } else {
            coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}

// MARK: - MapViewController

class NoteMapViewController: UIViewController {

    // MARK: - Properties
    
    var mapView: MKMapView!
    var note: Note?
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Map".localize()
        addMapView()
        if note?.locationActual != nil {
            mapView.addAnnotation(NoteAnnotation(note: note!))
            mapView.centerCoordinate = CLLocationCoordinate2D(latitude: note!.locationActual!.lat, longitude: note!.locationActual!.lon)
        }
    }
    
    // MARK: - Functions
    
    @objc func handleLongTap(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        let point = recognizer.location(in: mapView)
        let convertedPoint = mapView.convert(point, toCoordinateFrom: mapView)
        
        note?.locationActual = LocationCoordinate(lat: convertedPoint.latitude, lon: convertedPoint.longitude)
        CoreDataManager.sharedInstance.saveContext()
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(NoteAnnotation(note: note!))
    }
    
    // MARK: - UI
    
    func addMapView() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        view.addSubview(mapView)
        
        let longGuesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        mapView.gestureRecognizers = [longGuesture]
        
        NSLayoutConstraint.activate([
            self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
    }
    
}

// MARK: - MKMapVieDelegate

extension NoteMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.isDraggable = true
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == .ending {
            let newLocation = LocationCoordinate(lat: view.annotation!.coordinate.latitude, lon: view.annotation!.coordinate.longitude)
            note?.locationActual = newLocation
            CoreDataManager.sharedInstance.saveContext()
        }
    }
}
