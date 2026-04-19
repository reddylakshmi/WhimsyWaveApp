import SwiftUI

struct LoginView: View {
    @Bindable var feature: ProfileFeature
    var onLoginSuccess: (() -> Void)?
    @State private var isRegisterMode = false

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()

            VStack(spacing: AppSpacing.sm) {
                Image(systemName: "bag.circle.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(Color.accentColor)
                Text("Whimsy Wave")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                Text(isRegisterMode ? "Create your account" : "Welcome back")
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: AppSpacing.md) {
                if isRegisterMode {
                    inputField(placeholder: "Email Address", text: $feature.email, icon: "envelope")
                        .keyboardType(.emailAddress)
                }
                inputField(placeholder: "Username", text: $feature.username, icon: "person")
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                secureField(placeholder: "Password", text: $feature.password)
            }
            .padding(.horizontal, AppSpacing.md)

            if let error = feature.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal, AppSpacing.md)
            }

            Button {
                Task {
                    if isRegisterMode {
                        await feature.handleRegister()
                    } else {
                        await feature.handleLogin()
                    }
                    if feature.isAuthenticated {
                        onLoginSuccess?()
                    }
                }
            } label: {
                HStack {
                    if feature.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text(isRegisterMode ? "Sign Up" : "Sign In").fontWeight(.bold)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.accentColor)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.cornerRadius))
            }
            .disabled(feature.isLoading)
            .padding(.horizontal, AppSpacing.md)

            Button {
                withAnimation { isRegisterMode.toggle() }
            } label: {
                HStack {
                    Text(isRegisterMode ? "Already have an account?" : "New here?")
                    Text(isRegisterMode ? "Login" : "Create Account").bold()
                }
                .font(.footnote)
            }

            Spacer()
        }
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private func inputField(placeholder: String, text: Binding<String>, icon: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundStyle(.secondary)
            TextField(placeholder, text: text)
        }
        .padding(AppSpacing.md)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius))
    }

    private func secureField(placeholder: String, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: "lock").foregroundStyle(.secondary)
            SecureField(placeholder, text: text)
        }
        .padding(AppSpacing.md)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius))
    }
}
