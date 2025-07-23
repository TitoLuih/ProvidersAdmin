# ProvidersAdmin

A Flutter application for managing suppliers and invoices. This project provides a comprehensive solution for supplier administration, document management that sents the documents to a service that read it with IA and puts the information on a JSON.

**Important note**
This project was created a year ago when I was learning Flutter for the first time, it is not the cleanest but I want to revive it and keep updating it and making the code cleaner and eassier to read

## 📱 Features

- **Supplier Management**: Complete supplier information management
- **Document Processing**: Handle invoices and related documents
- **Order Management**: Track and manage supplier orders
- **File Upload**: Drag & drop file upload functionality
- **Authentication**: Secure login with code confirmation
- **Real-time Communication**: Socket-based real-time updates

## 🏗️ Architecture

The project follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── global/           # Global configuration and environment
├── helpers/          # Utility functions and helpers
├── models/           # Data models and entities
├── pages/            # UI pages and screens
├── providers/        # State management providers
├── services/         # Business logic and API services
└── widgets/          # Reusable UI components
```

## 📋 Main Components

### Models
- **Articulos**: Product/article management
- **Documento**: Document handling
- **Pedidos**: Order management
- **Proveedor**: Supplier information
- **Login**: Authentication models

### Pages
- **Pagina Principal**: Main dashboard
- **Pedidos Page**: Orders management interface
- **Solicitar Código / Confirmación Código**: Authentication flow
- **Status**: Application status monitoring

### Services
- **Auth Service**: Authentication management
- **Socket Service**: Real-time communication

### Widgets
- **Dropzone Widget**: File upload interface
- **Form Invoice**: Invoice form components
- **Dropped Image Widget**: Image handling

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/TitoLuih/AdminProveedores.git
   cd AdminProveedores
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment**
   - Update `lib/global/enviroment.dart` with your server configuration
   - Ensure proper API endpoints are configured

4. **Run the application**
   ```bash
   flutter run
   ```

## 🛠️ Development

### Project Structure
The project is organized into logical modules:

- **Global**: Environment configuration and global settings
- **Models**: Data structures for the application entities
- **Providers**: State management using Provider pattern
- **Services**: API communication and business logic
- **Pages**: Application screens and navigation
- **Widgets**: Reusable UI components

### State Management
The application uses the Provider pattern for state management, with specific providers for:
- Document management
- File handling
- Supplier information

### File Upload
The application supports drag & drop file upload functionality with:
- Dropzone widget for file selection
- File validation and processing
- Upload progress tracking

## 📱 Platforms Supported

- ✅ Web
- ✅ Linux
- ✅ macOS
- ✅ Windows

## 🔧 Configuration

### Environment Setup
Configure your environment variables in `lib/global/enviroment.dart`:
- API base URL
- Socket server configuration
- Authentication endpoints

### Assets
- Logo and images are stored in the `assets/` directory
- Update `pubspec.yaml` if adding new assets

---

**Note**: This is a Flutter application for supplier and invoice management. Make sure to configure your environment properly before running the application.
