//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation

class WebApiResponse<Response> {
    
    var error: Error?
    var statusCode: Int = 0
    var request: URLRequest?
    var response: Response?
}
