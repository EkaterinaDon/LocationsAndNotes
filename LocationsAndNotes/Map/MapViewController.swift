//
//  MapViewController.swift
//  LocationsAndNotes
//
//  Created by Ekaterina on 25.04.21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Properties
    
    var mapView: MKMapView!
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
        notes.forEach { (note) in
            if note.locationActual != nil {
                mapView.addAnnotation(NoteAnnotation(note: note))
            }
        }
    }


    // MARK: - UI
    
    func addMapView() {
        mapView = MKMapView()
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
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
    
    // MARK: - Functions
    
    @objc func handleLongTap(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state != .began {
            return
        }
        let point = recognizer.location(in: mapView)
        let convertedPoint = mapView.convert(point, toCoordinateFrom: mapView)
        
        let newNote = Note.newNote(name: "", inFolder: nil)
        newNote.locationActual = LocationCoordinate(lat: convertedPoint.latitude, lon: convertedPoint.longitude)
        goToNote(note: newNote)
    }
    
    func goToNote(note: Note) {
        let noteController = NoteController()
        noteController.note = note
        navigationController?.pushViewController(noteController, animated: true)
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            DispatchQueue.main.async {
                mapView.setCenter(annotation.coordinate, animated: true)
            }
            return nil
        }
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.animatesDrop = true
        pin.canShowCallout = true
        pin.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        return pin
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let selectedNote = (view.annotation as! NoteAnnotation).note
        goToNote(note: selectedNote)
    }
}
