//
//  MyProject
//  Copyright (c) Yuichi Nakayasu. All rights reserved.
//
import Foundation
import Alamofire

enum WebApiRequestMethod {
    
    case options
    case get
    case head
    case post
    case put
    case patch
    case delete
    case trace
    case connect
    
    var alamofireHttpMethod: Alamofire.HTTPMethod {
        switch self {
        case .options : return .options
        case .get     : return .get
        case .head    : return .head
        case .post    : return .post
        case .put     : return .put
        case .patch   : return .patch
        case .delete  : return .delete
        case .trace   : return .trace
        case .connect : return .connect
        }
    }
}
