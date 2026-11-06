import Foundation;


enum GridState : Error {
    case LOADING;
    case DONE ;
    case ERROR;
    
}

class GridApiServic {
    var baseUrl = "https://jsonplaceholder.typicode.com/photos";
    func  fetchListData (_ start: Int  = 0, _ max: Int = 20) async throws -> [GridData] {
        
        guard var url = URL(string:  baseUrl) else {
            throw GridState.ERROR;
        }
        url.append(queryItems: [
            URLQueryItem(name: "_start", value:"0"),
            URLQueryItem(name: "_limit", value:"20")
        ])
        let (data, response) = try await URLSession.shared.data(from: url);
        guard let httpsResp =  response as? HTTPURLResponse, httpsResp.statusCode==200 else {
            throw GridState.ERROR;
        }
        
        do{
            let decoder = JSONDecoder();
            let result = try decoder.decode([GridData].self, from: data);
            return result;
        }catch {
            throw GridState.ERROR;
        }
    }
}
