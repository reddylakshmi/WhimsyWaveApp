import SwiftUI

struct LoginView: View {
    @Bindable var feature: AccountFeature
    var onLoginSuccess: (() -> Void)?
    @State private var isRegisterMode = false

    var body: some View {
        VStack(spacing: AppSpacing.xl) {
            Spacer()

            VStack(spacing: AppSpacing.sm) {
                Image(systemName: "bag.circle.fill")
                    .font(.system(size: 100))
                    .foregroundStyle(Color.accentColor)
                Text("app.name")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                Text(isRegisterMode ? "auth.createAccount" : "auth.welcomeBack")
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: AppSpacing.md) {
                if isRegisterMode {
                    inputField(placeholder: "form.emailAddress", text: $feature.email, icon: "envelope")
                        .keyboardType(.emailAddress)
                }
                inputField(placeholder: "form.username", text: $feature.username, icon: "person")
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                secureField(placeholder: "form.password", text: $feature.password)
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
                        Text(isRegisterMode ? "auth.signUp" : "action.signIn").fontWeight(.bold)
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
                    Text(isRegisterMode ? "auth.haveAccount" : "auth.newHere")
                    Text(isRegisterMode ? "auth.login" : "auth.createAccountAction").bold()
                }
                .font(.footnote)
            }

            Spacer()
        }
        .padding()
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private func inputField(placeholder: LocalizedStringKey, text: Binding<String>, icon: String) -> some View {
        HStack {
            Image(systemName: icon).foregroundStyle(.secondary)
            TextField(placeholder, text: text)
        }
        .padding(AppSpacing.md)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius))
    }

    private func secureField(placeholder: LocalizedStringKey, text: Binding<String>) -> some View {
        HStack {
            Image(systemName: "lock").foregroundStyle(.secondary)
            SecureField(placeholder, text: text)
        }
        .padding(AppSpacing.md)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: AppConstants.Layout.buttonCornerRadius))
    }
}
