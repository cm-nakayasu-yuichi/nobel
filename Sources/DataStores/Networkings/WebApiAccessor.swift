//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation
import Alamofire

class WebApiAccessor {
    
    func request<T>(_ request: T, responsed: @escaping (WebApiResponse<T.Response>) -> ()) where T: WebApiRequest {
        
        let dataRequest = Alamofire.request(
            request.urlString,
            method: request.method.alamofireHttpMethod,
            parameters: request.parameters,
            encoding: URLEncoding.default,
            headers: nil
        )
        
        dataRequest.validate().response() { dataResponse in
            let result = WebApiResponse<T.Response>()
            result.statusCode = dataResponse.response?.statusCode ?? 0
            result.request = dataResponse.request
            
            if let error = dataResponse.error {
                result.error = error
                responsed(result)
                return
            }
            
            guard let data = dataResponse.data else {
                result.error = WebApiError.noData
                responsed(result)
                return
            }
            
            do {
                guard let response = try request.parse(data) else {
                    result.error = WebApiError.failureParse
                    responsed(result)
                    return
                }
                result.response = response
                responsed(result)
            } catch let error {
                result.error = error
                responsed(result)
            }
        }
    }
}
