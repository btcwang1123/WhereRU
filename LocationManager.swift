import Foundation
import CoreLocation
import Combine
import UIKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var userAddress: String = "新竹市 (定位中...)" // 🌟 暫時使用靜態字串避開 iOS 26 Bug
    @Published var batteryLevel: Int = 100
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var userProfile = UserProfile()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.allowsBackgroundLocationUpdates = true
        
        // 啟用電池監測
        UIDevice.current.isBatteryMonitoringEnabled = true
        updateBatteryStatus()
        NotificationCenter.default.addObserver(self, selector: #selector(batteryChanged), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
    }

    @objc func batteryChanged() {
        updateBatteryStatus()
    }

    private func updateBatteryStatus() {
        self.batteryLevel = Int(UIDevice.current.batteryLevel * 100)
    }

    func requestPermission() {
        manager.requestAlwaysAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = location.coordinate
        }
    }

    func setupGeofence(for friend: Friend, radius: CLLocationDistance = 200) {
        let region = CLCircularRegion(center: friend.coordinate, radius: radius, identifier: friend.name)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        manager.startMonitoring(for: region)
        print("🛡️ 開始監控地理圍欄：\(friend.name)")
    }
}
