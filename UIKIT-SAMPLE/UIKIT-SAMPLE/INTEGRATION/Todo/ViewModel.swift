
import Foundation;
import Combine;
 
@MainActor
class PostViewModel: ObservableObject{

    @Published var post: [PostData] = [];
    @Published var state: ConnectionState = .loading;
    @Published var hasData  = false;
    private let https = APIService();
    
    func loadPosts ()async{
        state = .loading;
        
        do {
            post = try await https.fetchPostData();
            state = .done;
            hasData = post.count > 0;
        } catch {
            state = .error;
        }
    }
    
    
    @Published var postDetail: PostData?;
    func onLoadPostDetail (id: Int) async {
        state = .loading;
        do{
            let detail = try await https.fectPostDetail(id: id);
            postDetail = detail;
            state = .done;
            hasData = postDetail != nil;
        }catch {
            state = .error;
        }
    }
}


