//
//  MainViewModel.swift
//  mapApp
//
//  Created by user on 5/21/20.
//  Copyright © 2020 Vinova.Train.mapApp. All rights reserved.
//

//MARK: Sketch

//Model nao cung co PlaceMark: name, subname, coordinates
//View nao cung co yeu cau tuong ung voi Model

//DI Service: Model or DI Service: ViewModel?
//1. Vay dung DI cho Model, chi mot View Model. -> I think this way is possible. func getPlaceMark() -> PlaceMarkProtocol. Moi Model cau truc PlaceMark rieng tuy theo JSON
//2. Hay dung DI cho ViewModel, co mot Main View Model?
//Cach 1 dung voi hien tai nhung neu mo rong len can cac VM khac nhau thi sao?->Vm de xu ly logic View, Nho lai vd DI Shape. 3 View deu co yeu cau tuong tu nhau, NEU 3Maps du lieu giong nhau thi co the xu ly trong chung mot VM, chi khac cach callAPI.
//Hon nua, dung 1 thay co loi: gon nhe: giam bot 3VM -> 1VM, de doc, de cau truc,... con dung 2? 3Vm can xu ly gi chung, tai sao khong de 3VM rieng cho 3 VC doc la duoc roi ma phai them 1 MainVM lam DI service?

//View can tu Model:
//- Basic: PlaceMark[0] to calculate and draw route, mark annotation,
//- Upgrade: In TableView to Search: PlaceMark(MapBox) or Array of PlaceMark to show ([PlaceMark])

//Google, MapBox. MapKit must have different Model because API call of each type is different from others.
//Model:
//Can cau truc lai/ tao moi struct PlaceMark.
//Mot PlaceMark chi chua 1 dia chi, hien tai 1 PlaceMark chua tat ca dia chi tra ve.
//PlaceMark co the dung chung nhung PlaceMarkService khac nhau! -> Init khac nhau! -> 2 cach: 1. PlaceMark rieng sau do gan cho PlaceMark chung. 2. Mot PlaceMark nhung dung protocol PlaceMArkService! Chon cach 1.

//VM:
//Tai sao can VM ma khong dung Model? Duong nhu khong can cac phep tinh Logic cho View khi chi show annotation. -> Tuong Lai phat trien them.
//- Talk with Model: Dua Model query, Lay PlaceMark tu Model
//- Talk with View Controller: Dua PlaceMark
//Ham tinh duong di o VM hay VC?

//VC: 3VC cho 3 Map
//Giu mapView, route, Annotation, activityIndicator
//Lay PlaceMark

//TableVC:
//Co can tung TableVC cho tung loai Map?
//

//MARK: End Sketch

import Foundation

import CoreLocation

protocol ModelAccess {
    
    typealias QueryResult = ([PlaceMarkForAllMap]) -> Void
    
    var parseDataDelegate: ParseDataFromSearch? { get set }
    
    func fetchData(query: String, latitude: Double, longitude: Double) -> [PlaceMarkForAllMap]?
    
    func fetchData1(query: String, latitude: Double, longitude: Double, completion: @escaping QueryResult) -> [PlaceMarkForAllMap]?
    
    func getPlaceMark() -> [PlaceMarkForAllMap]
}

class ModelFactory{
    func getModel(typeOfModel: ViewModel) -> ModelAccess?{
    
        switch typeOfModel {
        case .MapBox:
            return MapBoxModel()
        case .AppleMaps:
            return AppleMapsModel()
        case .Google:
            return GoogleMapsModel()
        }
        
    }
}

class MainViewModel {

    weak var searchTable = SearchTableViewController()
    
    var _modelAccess: ModelAccess?
    var modelFactory = ModelFactory()
    
    var userLocation = CLLocationCoordinate2D()
    
    //let modelAccess: String? //Debug
    
    init(modelAcess: ViewModel){
    
        self._modelAccess = modelFactory.getModel(typeOfModel: modelAcess)
        if _modelAccess == nil {
            print("ERROR: Init wrong type for View Model")
        }
        //self.modelAccess = modelAcess
        
        searchTable?.handleMapSearchDelegate = self
      
        
    }
    
    func getData(query: String, latitude: Double, longitude: Double){
        guard let placeMarkx = _modelAccess?.fetchData(query: query, latitude: latitude, longitude: longitude) else {
            return
        }
        placeMarks = placeMarkx
    }
    
//    func getData1(query: String, latitude: Double, longitude: Double){
//        guard let placeMarkx = _modelAccess?.fetchData(query: query, latitude: latitude, longitude: longitude) { [week self] results in print("ddd") } else {
//            return
//        }
//        placeMarks = placeMarkx
//    }
    //Array of PlaceMark
    //lazy var placeMarks = _modelAccess?.getPlaceMark()
    
    var placeMarks : [PlaceMarkForAllMap] = []
    //1 PlaceMark for set Annotation
    var placeMark = PlaceMarkForAllMap()
    
//    func updatePlaceMark(){
//        placeMark = placeMarks[0]
//    }
    
}

extension MainViewModel: HandleMapSearch {
    func addAnnotationAPI(placemark: PlaceMark, row: Int) {
        print("")
    }
    
    func addAnnotationFromSearch(placeMarks: [PlaceMarkForAllMap], row: Int) {
        placeMark.Name = placeMarks[row].Name
        placeMark.placeName = placeMarks[row].placeName
        placeMark.longitude = placeMarks[row].longitude
        placeMark.latitude = placeMarks[row].latitude
        
        
    }
    
    
}
