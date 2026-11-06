import Foundation;
enum ConnectionState: Error {
    case loading;
    case done;
    case error ;
    
}

class APIService {
    
    func fetchPostData () async throws -> [PostData] {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
            throw ConnectionState.error;
        }
        print ("Requesting url : \(url)")
        let (data, response) = try await URLSession.shared.data(from:url);
        print ("Respose data : \(data)")
        guard let httpsResponse = response as? HTTPURLResponse, httpsResponse.statusCode==200 else  {
            throw ConnectionState.error;
        }
        do{
            let posts = try JSONDecoder().decode([PostData].self, from: data);
            return posts;
        }catch {
            throw ConnectionState.error;
        }
        
    }
    
    func  fectPostDetail (id : Int) async throws -> PostData {
        
        let url =  URL(string:"https://jsonplaceholder.typicode.com/posts/\(id)");
        
        let (data, response) = try await  URLSession.shared.data(from: url!);
         
        print ("Requested post detail : \(id)");
        let statusCode = (response as? HTTPURLResponse)?.statusCode;
        
        if (statusCode != 200) {
            throw ConnectionState.error;
        }
        do{
            let post = try JSONDecoder().decode (PostData.self, from: data);
            return post;
        }catch {
            throw ConnectionState.error;
        }
        
    }
    
}
