import SwiftUI
import SwiftCoreUtilities

struct PermissionDemoView: View {
    @StateObject private var viewModel = PermissionDemoViewModel()
    
    var body: some View {
        VStack {
            Text("Permission Management")
                .font(.title)
                .padding(.top, 20)
            
            List(viewModel.permissions) { permission in
                HStack {
                    VStack(alignment: .leading) {
                        Text(permission.type.rawValue.capitalized)
                            .font(.headline)
                        Text("Status: \(permission.state.rawValue)")
                            .font(.subheadline)
                            .foregroundColor(permission.state.color)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.requestPermission(for: permission.type)
                    }) {
                        Text("Request")
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .onAppear {
            viewModel.refreshPermissionStates()
        }
    }
}

private extension PermissionState {
    var color: Color {
        switch self {
        case .granted, .authorizedWhenInUse, .authorizedAlways:     return .green
        case .denied, .notDetermined:                               return .red
        case .restricted, .provisional, .ephemeral:                 return .yellow
        }
    }
}
