//
//  ViewController.swift
//  TestTask
//
//  Created by Artyom Tabachenko on 12.03.2024.
//

import UIKit
import MapKit
import CoreLocation
import CoreLocationUI

class ViewController: UIViewController {
    // MARK: UI
    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        return map
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var myLocationButton: CLLocationButton = {
        let button = CLLocationButton()
        button.icon = .arrowOutline
        button.cornerRadius = 75
        button.addTarget(self, action: #selector(currentLocation), for: .touchUpInside)
        return button
    }()
    
    private lazy var zoomInButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 75
        button.setImage(UIImage(named: "zoomIn"), for: .normal)
        button.addTarget(self, action: #selector(zoomInAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var zoomOutButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 75
        button.setImage(UIImage(named: "zoomOut"), for: .normal)
        button.addTarget(self, action: #selector(zoomOutAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var trackerButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 75
        button.setImage(UIImage(named: "tracker"), for: .normal)
        button.addTarget(self, action: #selector(isAddingAction), for: .touchUpInside)
        return button
    }()
        
    // MARK: Properties
    var tileRenderer: MKTileOverlayRenderer!
    var isAddingMarker = false
    
    private var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupConstraints()
        setupTileRenderer()
        
        mapView.delegate = self
        locationManager.delegate = self
        
        setupGestureRecognizer()
    }
}

// MARK: - Private functions
extension ViewController {
    private func setupConstraints() {
        view.addSubview(mapView)
        buttonsStackView.addArrangedSubview(zoomInButton)
        buttonsStackView.addArrangedSubview(zoomOutButton)
        buttonsStackView.addArrangedSubview(myLocationButton)
        buttonsStackView.addArrangedSubview(trackerButton)
        view.addSubview(buttonsStackView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            mapView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor
            ),
            mapView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            mapView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            ),
        ])
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsStackView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.ConstraintsConstants.buttonsStackViewLeadingAnchor
            ),
            buttonsStackView.trailingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.ConstraintsConstants.buttonsStackViewTrailingAnchor
            ),
            
            buttonsStackView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor,
                constant: Constants.ConstraintsConstants.buttonsStackViewBottomAnchor
            )
        ])
        
        zoomInButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            zoomInButton.heightAnchor.constraint(
                equalToConstant: Constants.ConstraintsConstants.buttonHeight
            ),
            zoomInButton.widthAnchor.constraint(
                equalToConstant: Constants.ConstraintsConstants.buttonWidth
            ),
        ])
        
        zoomOutButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            zoomOutButton.heightAnchor.constraint(
                equalToConstant: Constants.ConstraintsConstants.buttonHeight
            ),
            zoomOutButton.widthAnchor.constraint(
                equalToConstant: Constants.ConstraintsConstants.buttonWidth
            ),
        ])
        
        trackerButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trackerButton.heightAnchor.constraint(
                equalToConstant: Constants.ConstraintsConstants.buttonHeight
            ),
            trackerButton.widthAnchor.constraint(
                equalToConstant: Constants.ConstraintsConstants.buttonWidth
            ),
        ])
    }
    
    private func setupTileRenderer() {
        let template = Constants.TileConstants.tileTemplate
        let overlay = MKTileOverlay(urlTemplate: template)
        overlay.canReplaceMapContent = true
        mapView.addOverlay(overlay, level: .aboveLabels)
        tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleMapTap(gestureRecognizer:))
        )
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        case .denied:
            showAlert(
                with: Constants.LocationAuthorizationMessages.accessDeniedTitle,
                message: Constants.LocationAuthorizationMessages.accessDeniedMessage
            )
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showAlert(
                with: Constants.LocationAuthorizationMessages.accessRestrictedTitle,
                message: Constants.LocationAuthorizationMessages.accessRestrictedMessage
            )
        case .authorizedAlways:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
        @unknown default:
            showAlert(
                with: Constants.LocationAuthorizationMessages.unknownStatusTitle,
                message: Constants.LocationAuthorizationMessages.unknownStatusMessage
            )
        }
    }

    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Настройки", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        })
        present(alert, animated: true)
    }
    
    func addBottomSheetView() {
        let bottomSheetVC = BottomSheetViewController()
        let navigationController = UINavigationController(rootViewController: bottomSheetVC)

        navigationController.modalPresentationStyle = .pageSheet
        
        let fraction = UISheetPresentationController.Detent.custom { [weak self] _ in
            guard let self else { return 0 }
            return view.frame.height * Constants.BottomSheetConstants.bottomSheetHeightRatio
        }
        navigationController.sheetPresentationController?.detents = [fraction]
        
        self.present(navigationController, animated: true)
    }
    
    private func addCustomPin(coordinate: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Илья" // Hardcode
        pin.subtitle = "GPS 14:00" // Hardcode
        mapView.addAnnotation(pin)
    }
    
    private func createAnnotationView(
        for annotation: MKAnnotation,
        on mapView: MKMapView,
        withIdentifier identifier: String,
        imageName: String
    ) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let resizedImage = resizeImage(
            imageName: imageName,
            targetSize: CGSize(
                width: Constants.ResizedImageConstants.imageWidth,
                height: Constants.ResizedImageConstants.imageHeight
            )
        )
        annotationView?.image = resizedImage
        
        return annotationView
    }
    
    private func resizeImage(
        imageName: String,
        targetSize: CGSize
    ) -> UIImage? {
        guard let image = UIImage(named: imageName) else { return nil }
        
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}

// MARK: - MKMapViewDelegate
extension ViewController: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        rendererFor overlay: MKOverlay
    ) -> MKOverlayRenderer {
        return tileRenderer
    }
    
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
    ) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return createAnnotationView(
                for: annotation,
                on: mapView,
                withIdentifier: Constants.CustomAnnotationViewIdentifiers.userLocationIdentifier,
                imageName: "userLocation"
            )
        }
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        return createAnnotationView(
            for: annotation,
            on: mapView,
            withIdentifier: Constants.CustomAnnotationViewIdentifiers.markerIdentifier,
            imageName: "markerImage"
        )
    }
    
    func mapView(
        _ mapView: MKMapView,
        didSelect view: MKAnnotationView
    ) {
        if isAddingMarker {
            let location = view.annotation?.coordinate
            let annotation = MKPointAnnotation()
            annotation.coordinate = location!
            mapView.addAnnotation(annotation)
            isAddingMarker = false
        }
        addBottomSheetView()
    }
}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return }
        self.locationManager.stopUpdatingLocation()
        print(locations)
        
        mapView.setRegion(MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: Constants.RegionConstants.defaultLatitudeDelta,
                longitudeDelta: Constants.RegionConstants.defaultLongitudeDelta)
        ), animated: true)
    }
    
    func locationManagerDidChangeAuthorization(
        _ manager: CLLocationManager
    ) {
        checkLocationAuthorization()
    }
}

// MARK: - objc func
extension ViewController {
    @objc func currentLocation() {
        locationManager.startUpdatingLocation()
    }
    
    @objc func zoomInAction() {
        let zoomInRegion = MKCoordinateRegion(
            center: mapView.centerCoordinate,
            latitudinalMeters: mapView.region.span.latitudeDelta * Constants.ZoomConstants.zoomInFactor,
            longitudinalMeters: mapView.region.span.longitudeDelta * Constants.ZoomConstants.zoomInFactor
        )
        mapView.setRegion(zoomInRegion, animated: true)
    }
    
    @objc func zoomOutAction() {
        let zoomOutRegion = MKCoordinateRegion(
            center: mapView.centerCoordinate,
            latitudinalMeters: mapView.region.span.latitudeDelta * Constants.ZoomConstants.zoomOutFactor,
            longitudinalMeters: mapView.region.span.longitudeDelta * Constants.ZoomConstants.zoomOutFactor
        )
        mapView.setRegion(zoomOutRegion, animated: true)
    }
    
    @objc func isAddingAction() {
        isAddingMarker = true
    }
    
    @objc func handleMapTap(gestureRecognizer: UIGestureRecognizer) {
        if isAddingMarker {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            addCustomPin(coordinate: coordinate)
            isAddingMarker = false
        }
    }
}
