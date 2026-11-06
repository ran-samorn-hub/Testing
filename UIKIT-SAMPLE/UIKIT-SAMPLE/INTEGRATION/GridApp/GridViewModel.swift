import Foundation ;
import Combine;
import SwiftUI;

@MainActor
class GridViewModel : ObservableObject {
    @Published var listData: [GridData]=[];
    @Published var state  = GridState.LOADING;
    @Published var hasData = false;
     @Published var isLoading: Bool = false;
    
    private let https = GridApiServic();
    func loadListData ()async{
        
        state = .LOADING;
        do{
            listData = try await https.fetchListData();
            hasData = listData.count > 0;
            state = .DONE;
        }catch {
            state = .ERROR;
        }
        
    }
    
    
    func onScrollerListener (_ context : ScrollPhaseChangeContext){
      
        let  boun = context.geometry.bounds.size.height;
        let contentHeight = context.geometry.contentSize.height;
        let top =  context.geometry.contentInsets.top
        let screenHeight  = contentHeight+top+boun;
        let verticalOffset = context.geometry.contentOffset.y+20;
        
        if verticalOffset > screenHeight{
            print ("scroll down")
        }
        else {
            print ("scroll up")
        }
    }
    
}
