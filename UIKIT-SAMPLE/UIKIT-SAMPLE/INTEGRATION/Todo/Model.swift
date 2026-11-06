import Foundation;


struct PostData:Codable,Identifiable {
    let id : Int;
    let userId: Int? ;
    let title: String? ;
    let body: String?;
   
}

