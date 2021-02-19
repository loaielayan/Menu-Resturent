//
//  RequestManager.swift
//  Resturent Menu
//
//  Created by Loai Elayan on 2/17/21.
//

import Foundation
import Alamofire


class RequestManager {
    
    static func getCategories(pageNumber: Int, completionHandler:@escaping ([Category]?, Int?,Error?)->Void){
        
        let userToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjlhZjhkYjhiYzQ2ZDNmNjk1MWI3MjQwM2I2Mjc5NjkzYjI1MWY4YzliMzJmOTc3YWEyNzk0YTU1NWFhY2I3MjE3ZWI2YjcwNGIyMjk5YmU2In0.eyJhdWQiOiI4Zjc4NjY2NC0wNTg5LTQ3MTgtODBkMS1lMTY4M2FmYmM3MjQiLCJqdGkiOiI5YWY4ZGI4YmM0NmQzZjY5NTFiNzI0MDNiNjI3OTY5M2IyNTFmOGM5YjMyZjk3N2FhMjc5NGE1NTVhYWNiNzIxN2ViNmI3MDRiMjI5OWJlNiIsImlhdCI6MTYwODEwMjY1MCwibmJmIjoxNjA4MTAyNjUwLCJleHAiOjE2Mzk2Mzg2NTAsInN1YiI6IjkxYmVmM2Q4LTcyYzYtNGQ5YS1hODAzLWUwZDEwMWVmODdhNiIsInNjb3BlcyI6WyJnZW5lcmFsLnJlYWQiXSwiYnVzaW5lc3MiOiI5MWJlZjNkOC03OTQ5LTQ0MjctOTg2NS1hYTI3MDVlNTYyOGQiLCJyZWZlcmVuY2UiOiIxMDAxMTEifQ.OxBVuOzdNqsowS1ebKSpn8vrfrsXR64VeN_cFzvZCVYI-s5meANJA3XHKX8THmIH3MlYYVz4zW41PfTWt1Klzmg9WcEcCuB30NncMS_UGdF3vcgSPc8RVxiGwzfj428HzSbjbM8P-ukg4TqcInYwDLKNaCOc5DEmXkdSbscUZazrBuK09ts74xBw9MhOk5E-ZCOsPm2Ts4ASHJ0m3qB2JI79IF3846iMHz8jpciYSBTkga37AlT7fef_Hxwrn1apxRIrb6rLKCV6zDr4ged2Ir9-GKjNSk1a_onUTHdP3-3_2lBEE51MFhX45qansnR2LDXUl-QMp9T0PDhWO9TR9QIwZJAsp1aFXW9S4E-Ok7566eDrplOHKVt5Tw08P9LefOK_Ob875ZsGpta56CzqMuVdlnJ7vnkbD_UuPlLquc1o9_yvOcu-Frk5QCNGNsyyzITobOvOwQ9TN24-BpDjq7s7debkDes5Sg6aVn4fmnVKkfDO44qJ9ppUPcOc2U8dh7voCJEry53lh9LPM6MiRmt8YBeiXDL8iRU2k_tcreJVEOtjRwkB-2m08jQ5DHDFrALNdvUFU6bgslbNSw9vKUiJbQrblwmohOR9fC-VtBPdVhQywyerNE1hs1jeFrHC2AZE-g2y5uQhVALYRxIy0-IBJgeh-jnCxpOsds_sOg0"
        let headers: HTTPHeaders = HTTPHeaders(["Accept":"application/json", "Authorization":"Bearer \(userToken)"])
        
        AF.request(Constants.baseurl + "categories?page=\(pageNumber)", method: .get, headers: headers).responseDecodable(of: Categories.self) { response in
            
            print(response)
            switch response.result
            {
            case .success:
                guard let categories = response.value else { return }
                print(categories)
                completionHandler(categories.data,categories.meta.last_page,response.error)
                break
            case .failure:
                completionHandler(nil,nil, response.error)
                break
            }
        }
        
    }
    
    static func getProducts(pageNumber: Int, completionHandler:@escaping ([Product]?, Int?,Error?)->Void){
        
        let userToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjlhZjhkYjhiYzQ2ZDNmNjk1MWI3MjQwM2I2Mjc5NjkzYjI1MWY4YzliMzJmOTc3YWEyNzk0YTU1NWFhY2I3MjE3ZWI2YjcwNGIyMjk5YmU2In0.eyJhdWQiOiI4Zjc4NjY2NC0wNTg5LTQ3MTgtODBkMS1lMTY4M2FmYmM3MjQiLCJqdGkiOiI5YWY4ZGI4YmM0NmQzZjY5NTFiNzI0MDNiNjI3OTY5M2IyNTFmOGM5YjMyZjk3N2FhMjc5NGE1NTVhYWNiNzIxN2ViNmI3MDRiMjI5OWJlNiIsImlhdCI6MTYwODEwMjY1MCwibmJmIjoxNjA4MTAyNjUwLCJleHAiOjE2Mzk2Mzg2NTAsInN1YiI6IjkxYmVmM2Q4LTcyYzYtNGQ5YS1hODAzLWUwZDEwMWVmODdhNiIsInNjb3BlcyI6WyJnZW5lcmFsLnJlYWQiXSwiYnVzaW5lc3MiOiI5MWJlZjNkOC03OTQ5LTQ0MjctOTg2NS1hYTI3MDVlNTYyOGQiLCJyZWZlcmVuY2UiOiIxMDAxMTEifQ.OxBVuOzdNqsowS1ebKSpn8vrfrsXR64VeN_cFzvZCVYI-s5meANJA3XHKX8THmIH3MlYYVz4zW41PfTWt1Klzmg9WcEcCuB30NncMS_UGdF3vcgSPc8RVxiGwzfj428HzSbjbM8P-ukg4TqcInYwDLKNaCOc5DEmXkdSbscUZazrBuK09ts74xBw9MhOk5E-ZCOsPm2Ts4ASHJ0m3qB2JI79IF3846iMHz8jpciYSBTkga37AlT7fef_Hxwrn1apxRIrb6rLKCV6zDr4ged2Ir9-GKjNSk1a_onUTHdP3-3_2lBEE51MFhX45qansnR2LDXUl-QMp9T0PDhWO9TR9QIwZJAsp1aFXW9S4E-Ok7566eDrplOHKVt5Tw08P9LefOK_Ob875ZsGpta56CzqMuVdlnJ7vnkbD_UuPlLquc1o9_yvOcu-Frk5QCNGNsyyzITobOvOwQ9TN24-BpDjq7s7debkDes5Sg6aVn4fmnVKkfDO44qJ9ppUPcOc2U8dh7voCJEry53lh9LPM6MiRmt8YBeiXDL8iRU2k_tcreJVEOtjRwkB-2m08jQ5DHDFrALNdvUFU6bgslbNSw9vKUiJbQrblwmohOR9fC-VtBPdVhQywyerNE1hs1jeFrHC2AZE-g2y5uQhVALYRxIy0-IBJgeh-jnCxpOsds_sOg0"
        let headers: HTTPHeaders = HTTPHeaders(["Accept":"application/json", "Authorization":"Bearer \(userToken)"])
        AF.request(Constants.baseurl + "products?include=category", method: .get, headers: headers).responseDecodable(of: products.self) { response in
            
            //print(response)
            switch response.result
            {
            case .success:
                guard let products = response.value else { return }
                
                completionHandler(products.data,products.meta.last_page,response.error)
                break
            case .failure:
                completionHandler(nil,nil, response.error)
                break
            }
        }
        
        
    }
}
