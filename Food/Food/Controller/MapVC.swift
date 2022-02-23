//
//  MapVC.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/12/2.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    var restaurant: Restaurant = Restaurant()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        //显示比例尺寸左上角
        //mapView.showsScale = true
        //指南针 只有在地图偏离正北方向才会显示
        mapView.showsCompass = true
        //显示高流量地方
        mapView.showsTraffic = true
        
        //地址转换为坐标标记在地图上
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location, completionHandler: { placemarks, error in
            if let error = error {
                print(error)
                return
            }
            
            if let placemarks = placemarks {
                //取得第一个坐标
                let placemark = placemarks[0]
                //加上标记就是那种大头针
                let annotation = MKPointAnnotation()
                annotation.title = self.restaurant.name
                annotation.subtitle = self.restaurant.type
                
                if let location = placemark.location {
                    annotation.coordinate = location.coordinate
                    //显示标记
                    self.mapView.showAnnotations([annotation], animated: true)
                    //选取标记
                    self.mapView.selectAnnotation(annotation, animated: true)
                }
            }
        })
    }
}

extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identiffier = "MyMarker"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        //重复使用标记
        var annotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identiffier) as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identiffier)
        }
        
        annotationView?.glyphText = "🤪"
        annotationView?.markerTintColor = UIColor(named: "mainColor")
        
        return annotationView
    }
}
