import SwiftUI;

struct MayGridView: View {
    @StateObject var viewModel = GridViewModel();
    
    var body: some View {
        NavigationStack {
             Group {
                 if  viewModel.state == .LOADING{
                     ProgressView("Grid fetching...");
                 } else if !viewModel.hasData{
                    Text("No data found")
                 }
                 else {
                      
                         GeometryReader { proxy in
                             ScrollView{
                                 LazyVGrid(
                                    columns: Array(repeating: GridItem(.fixed(proxy.size.width/2.2), alignment: .center), count: 2),
                                    alignment: .center,
                                    spacing: 10
                                
                                 ) {
                                     
                                     ForEach (viewModel.listData){
                                         item in  VStack(alignment:.center){
                                             AsyncImage(url: URL (string: item.url)){
                                                 phass in switch phass {
                                                 case .empty:
                                                     ProgressView()
                                                 case .success(let image):
                                                     image.resizable()
                                                         .scaledToFit()
                                                 default: EmptyView()
                                                     
                                                 }
                                                 
                                             }
                                             
                                             Text(item.title)
                                             Spacer()
                                             
                                         }
                                                 .background(
                                                    .gray.opacity(0.1)
                                                    
                                                 )
                                                 .cornerRadius(10)
                                         }
                                  
                                     
                                 }
                             }
                             .onScrollPhaseChange { oldPhase, newPhase, context in viewModel.onScrollerListener(context)
                             }
                             .refreshable {
                                 print ("Ref")
                             }
                             
                           
                         }
                     
                }
             }
        }
        .task {
          await  viewModel.loadListData();
        }
    }
}


#Preview {
    MayGridView();
}
