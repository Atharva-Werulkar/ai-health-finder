# 🏥 AI-MSC (AI Medical Specialist Consultant)

**Your AI-Powered Healthcare Companion** 🤖💊

AI-MSC is an innovative Flutter application that revolutionizes healthcare accessibility by combining artificial intelligence with location-based services to help users find the right medical specialists quickly and efficiently.

## ✨ Features

### 🧠 **Intelligent Medical Analysis**
- **AI-Powered Consultation**: Leverages Google's Gemini 2.0 Flash model to analyze your symptoms and medical descriptions
- **Smart Specialist Recommendation**: Automatically determines the appropriate medical specialist based on your input
- **Natural Language Processing**: Simply describe your symptoms in plain English

### 📍 **Location-Based Doctor Discovery**
- **Nearby Doctors**: Find qualified doctors and specialists in your vicinity (5km radius)
- **Real-time Location Services**: Uses GPS to provide accurate location-based results
- **Integrated Maps**: Powered by Google Maps API for precise location data

### 💼 **Comprehensive Doctor Information**
- **Detailed Profiles**: View doctor ratings, reviews, and business status
- **Contact Information**: Direct access to doctor contact details
- **User Ratings**: See community feedback and ratings
- **Practice Locations**: Complete address and vicinity information

### 🎨 **Modern UI/UX**
- **Material Design 3**: Clean, modern interface with teal accent colors
- **Poppins Typography**: Beautiful, readable font styling
- **Responsive Design**: Optimized for all screen sizes
- **Loading Animations**: Smooth, engaging user experience with SpinKit animations

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **AI Integration**: Google Generative AI (Gemini 2.0 Flash)
- **Maps & Location**: Google Maps API, Geolocator
- **HTTP Requests**: HTTP package for API communications
- **UI Components**: Material Design 3, Google Fonts, Iconsax
- **State Management**: StatefulWidget with setState
- **Permissions**: Permission Handler for location access

## 🚀 Environment Setup

This project uses environment variables to securely store API keys. Follow these steps to set up your environment:

### 1. **Clone and Setup**
```bash
git clone <your-repo-url>
cd aimsc
flutter pub get
```

### 2. **Environment Configuration**
Copy the `.env.example` file to `.env`:
```bash
cp .env.example .env
```

### 3. **API Keys Setup**
Edit the `.env` file and add your actual API keys:
```env
# Google Gemini AI API Key
GEMINI_API_KEY=your_gemini_api_key_here

# Google Maps API Key  
MAP_API_KEY=your_google_maps_api_key_here
```

### 4. **Required API Keys**
- **Gemini API Key**: Get from [Google AI Studio](https://makersuite.google.com/app/apikey)
- **Google Maps API Key**: Get from [Google Cloud Console](https://console.cloud.google.com/)
  - Enable Places API
  - Enable Maps JavaScript API

### ⚠️ **Security Note**
- **Never commit the `.env` file** to version control
- The `.env` file is already added to `.gitignore`
- Use `.env.example` as a template for team members

## 📱 How It Works

1. **📝 Describe Symptoms**: Enter your medical concerns or symptoms
2. **🤖 AI Analysis**: Gemini AI analyzes your description and suggests the appropriate specialist
3. **📍 Location Detection**: App detects your current location (with permission)
4. **🔍 Doctor Search**: Finds nearby doctors matching the specialist recommendation
5. **👨‍⚕️ View Results**: Browse doctor profiles with ratings, contact info, and locations
6. **📞 Contact**: Direct access to call or get directions to the doctor

## 🔧 Installation & Running

### Prerequisites
- Flutter SDK (>=3.3.2)
- Dart SDK
- Android Studio / VS Code
- Valid Google API keys

### Steps
```bash
# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| `google_generative_ai` | AI-powered medical analysis |
| `flutter_dotenv` | Environment variable management |
| `geolocator` | Location services |
| `google_maps_flutter` | Maps integration |
| `http` | API communications |
| `permission_handler` | App permissions |
| `flutter_spinkit` | Loading animations |
| `google_fonts` | Typography |
| `iconsax` | Modern icons |
| `url_launcher` | External links |

## 🎯 Use Cases

- **Emergency Situations**: Quick specialist identification
- **Preventive Care**: Find the right doctor for regular checkups
- **Specialist Referrals**: When you need specific medical expertise
- **Travel Healthcare**: Find doctors while traveling
- **Second Opinions**: Locate multiple specialists for comparison

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support, email [werulkaratharva@gmail.com] or create an issue in this repository.

---

**Built with ❤️ using Flutter and AI** | **Making Healthcare Accessible** 🌟
