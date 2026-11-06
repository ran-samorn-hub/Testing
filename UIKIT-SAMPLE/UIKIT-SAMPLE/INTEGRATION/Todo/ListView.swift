import SwiftUI

struct PostView: View {
    @StateObject private var viewModel = PostViewModel()
    @State var postUser: PostData? = nil;
    

    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.state == .loading {
                    ProgressView("Fetching posts...")
                } else if viewModel.state == .done && viewModel.hasData {

                    List {
                        ForEach(viewModel.post, id: \.id) {
                            data in
                            HStack {
                                Image(systemName: "paperplane")
                                    .foregroundColor(Color.white)
                                    .frame(width: 40, height: 40)
                                    .background(.green)
                                    .clipShape(.circle)
                                    .padding(.top, 5)

                                VStack(alignment: .leading) {
                                    Text(data.title ?? "")
                                        .font(.system(size: 18))
                                        .lineLimit(1)
                                        .fontWeight(.bold)
                                    Text(data.body ?? "")
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }
                                Spacer()
                                Image(systemName: "chevron.forward")
                                    .foregroundColor(.gray)
                            }
                            .onTapGesture {
                                postUser = data;
                            }
                           
                        }
                    }

                } else {
                    Text("No Data Found")
                }
            }
        }
        .sheet(item: $postUser, content: { user in
            PostDetailView(post: user);
        })
        .task {
            await viewModel.loadPosts()
        }

    }

}


struct PostDetailView :View {
    let post : PostData;
    @StateObject private var viewModel = PostViewModel()
    var body: some View {
         
        NavigationView{
            if viewModel.state == .loading {
                 ProgressView("Fetching post...")
            }else if  viewModel.hasData {
                    GeometryReader{ proxy in
                        VStack(alignment: .leading){
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.gray)
                                .frame(width: .infinity, height: proxy.size.width)
                                .opacity(0.2)
                                .overlay{
                                    Image(systemName: "paperplane")
                                        .resizable().scaledToFit()
                                        .padding()
                                        .foregroundColor(Color.white)
                                        .frame(width: 100, height: 100)
                                        .background(.green)
                                        .cornerRadius(20)
                                        .padding(.top, 5)
                                       
                                }
                            Text (viewModel.postDetail?.title ?? "")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                                .padding(.vertical,10)
                            Text(viewModel.postDetail?.body ?? "")
                            
                            Spacer()
                        }
                }
                .padding()
            }else {
                 Text("No data found")
            }
        }.task {
            await viewModel.onLoadPostDetail(id: post.id)
        }
        
    }
}


#Preview(body: {PostView()});


