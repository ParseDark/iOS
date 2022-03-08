import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ClashHomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("主页")
                }
            SettingView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("设置")
                }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
