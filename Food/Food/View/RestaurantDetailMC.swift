//
//  RestaurantDetailMC.swift
//  FoodPin
//
//  Created by 贝蒂小熊 on 2021/11/29.
//

import UIKit
import MapKit

class RestaurantDetailMC: UITableViewCell {
    
   @IBOutlet var mapView: MKMapView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureMapSdk (location: String) {
        
        //获取位置
        let geocoder = CLGeocoder()
        
        print(location)
        geocoder.geocodeAddressString(location, completionHandler: { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let placemarks = placemarks {
                // 取得第一地标
                let placemark = placemarks[0]
                
                // 加上标记
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    // 显示标记
                    annotation.coordinate = location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    // 设置缩放地图大小
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                    self.mapView.setRegion(region, animated: false)
                }
            }
            
        })
    }

}

