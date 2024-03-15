//
//  Constants.swift
//  TestTask
//
//  Created by Artyom Tabachenko on 15.03.2024.
//

import Foundation

struct Constants {
    struct ConstraintsConstants {
        // MARK: ViewController Constraints
        static let buttonsStackViewLeadingAnchor: CGFloat = 335
        static let buttonsStackViewTrailingAnchor: CGFloat = -16
        static let buttonsStackViewBottomAnchor: CGFloat = -300
        
        static let buttonHeight: CGFloat = 45
        static let buttonWidth: CGFloat = 45
        
        // MARK: BottomSheetViewController Constraints
        static let imageViewTopAnchor: CGFloat = 20
        static let imageViewLeadingAnchor: CGFloat = 20
        static let imageViewHeight: CGFloat = 100
        static let imageViewWidth: CGFloat = 100
        
        static let nameLabelTopAbchor: CGFloat = 20
        static let nameLabelLeadingAnchor: CGFloat = 10
        
        static let bottomSheetStackViewTopAnchor: CGFloat = 10
        static let bottomSheetStackViewLeadingAnchor: CGFloat = 10
        
        static let historyButtonTopAnchor: CGFloat = 50
        static let historyButtonLeadingAnchor: CGFloat = 70
        static let historyButtonTrailingAnchor: CGFloat = -70
        static let historyButtonHeight: CGFloat = 40
    }
    
    struct TileConstants {
        static let tileTemplate: String = "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
    }
    
    struct BottomSheetConstants {
        static let bottomSheetHeightRatio: Double = 0.2
    }
    
    struct ResizedImageConstants {
        static let imageHeight: Double = 40
        static let imageWidth: Double = 40
    }
    
    struct RegionConstants {
        static let defaultLatitudeDelta: Double = 0.04
        static let defaultLongitudeDelta: Double = 0.04
    }
    
    struct ZoomConstants {
        static let zoomInFactor: Double = 7000
        static let zoomOutFactor: Double = 170000
    }
    
    struct LocationAuthorizationMessages {
        static let accessDeniedTitle = "Доступ к геолокации запрещён"
        static let accessDeniedMessage = "Чтобы использовать эту функцию, пожалуйста, разрешите доступ к геолокации в настройках."
        static let accessRestrictedTitle = "Доступ к геолокации ограничен"
        static let accessRestrictedMessage = "Доступ к геолокации ограничен настройками устройства или родительским контролем."
        static let unknownStatusTitle = "Неизвестный статус"
        static let unknownStatusMessage = "Получен неизвестный статус доступа к геолокации."
    }
    
    struct CustomAnnotationViewIdentifiers {
        static let userLocationIdentifier = "UserLocation"
        static let markerIdentifier = "Marker"
    }
}
