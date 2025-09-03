# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**JETJETJET** is an iOS application that turns your iPhone into a professional flight data recorder with real-time 3D flight visualization. The app uses CoreMotion to capture device movement data and SceneKit to render a 3D airplane that responds to the device's orientation in real-time.

### Core Features
- Real-time 3D flight simulation using CoreMotion and SceneKit
- Flight data recording with SwiftData persistence
- Sci-fi interface with dynamic starfield background and neon effects
- Multiple 3D airplane models (default box-based and imported jet model)
- Flight history with data visualization and replay capabilities

### Technical Stack
- **UI Framework**: SwiftUI + Combine
- **3D Rendering**: SceneKit (native Apple framework)
- **Data Persistence**: SwiftData (iOS 17+)
- **Sensors**: CoreMotion
- **Minimum iOS Version**: 17.0+
- **No third-party dependencies**

## Project Structure

```
JETJETJET/
├── JETJETJET/              # Main iOS app target
│   ├── Models/             # SwiftData models (FlightData, FlightSession)
│   ├── ViewModels/         # Business logic (FlightRecordingVM, FlightHistoryVM, etc.)
│   ├── Views/              # SwiftUI interface components
│   │   ├── 3D/             # SceneKit 3D rendering components
│   │   ├── Recording/      # Flight recording interface
│   │   ├── History/        # Flight history and data visualization
│   │   ├── Replay/         # Flight data replay interface
│   │   ├── Settings/       # Settings interface
│   │   └── Common/         # Shared UI components
│   ├── Services/           # Core services (MotionService, SoundService, HapticService)
│   ├── Utils/              # Utility classes and extensions
│   └── Resources/          # Assets, 3D models, audio files
├── JET-VisionOS/           # VisionOS target (Apple Vision Pro support)
├── Packages/               # Swift packages (RealityKitContent)
└── .superdesign/           # HTML design files
```

## Architecture Overview

### Data Flow
1. **MotionService** captures CoreMotion data at 10Hz intervals
2. **FlightRecordingVM** processes motion data and manages recording state
3. **SwiftData Models** (FlightData, FlightSession) persist flight data
4. **ViewModels** provide data to SwiftUI Views
5. **Views** render UI and 3D visualization

### Key Components

#### MotionService
- Handles CoreMotion device updates
- Calculates acceleration, speed, and device orientation (pitch, roll, yaw)
- Implements sensor calibration and data filtering
- Manages different states (idle, monitoring, recording)

#### FlightRecordingVM
- Central business logic coordinator
- Manages flight recording sessions
- Handles data persistence with SwiftData
- Controls recording lifecycle (start/stop)
- Provides real-time data to UI

#### 3D Visualization
- **Airplane3DModel**: Manages 3D airplane models and SceneKit scenes
- **Airplane3DSceneView**: SwiftUI wrapper for SceneKit view
- Supports multiple airplane models (default box-based and imported jet model)

#### Data Models
- **FlightData**: Individual motion data points with timestamp
- **FlightSession**: Grouped flight recordings with metadata
- **FlightStats**: Computed statistics from flight data

## Common Development Tasks

### Building the Project
```bash
# Open in Xcode and build normally
# No additional setup required for basic development
```

### Running Tests
```bash
# Currently no automated tests configured
# Manual testing on physical device required for CoreMotion features
```

### Adding New Features
1. Follow MVVM pattern with SwiftUI Views and Observable ViewModels
2. Use SwiftData for data persistence
3. Leverage existing Services for common functionality
4. Add new Views to appropriate subdirectories in Views/

### Working with 3D Models
1. Add new .scn files to Resources/
2. Update AirplaneModelType enum with new model
3. Configure model-specific settings in AirplaneModelConfig
4. Test on physical device for proper orientation

## Development Guidelines

### Code Quality
- Use SwiftUI declarative patterns
- Follow MVVM architecture
- Maintain clear separation of concerns
- Use Observable classes for ViewModels
- Implement proper error handling

### Performance Considerations
- MotionService updates at 10Hz - optimize processing
- Large flight data sets - implement batching and memory management
- 3D rendering - use efficient SceneKit practices
- Background data saving with SwiftData

### Device Requirements
- Physical iOS device required for CoreMotion testing
- iOS 17.0+ minimum deployment target
- Xcode 15.0+ for SwiftData and latest SwiftUI features

## Shared Files and Cross-Target Resources

### Project Targets
1. **JETJETJET** - Main iOS application target
2. **JET-VisionOS** - VisionOS application target for Apple Vision Pro

### Shared Swift Packages
- **RealityKitContent** - Shared 3D content package used across both targets

### Shared Resources
The following resources are shared between targets through Xcode's Target Membership settings:

iOS和visionOS共享的代码文件可见 [project.pbxproj](JETJETJET.xcodeproj/project.pbxproj)

### Managing Shared Files
1. Shared files are managed through Xcode's Target Membership settings in the File Inspector
2. The project.pbxproj file contains the actual target membership configuration
3. Do not manually edit the project.pbxproj file - use Xcode interface for target membership changes
4. When adding new shared files, ensure they are added to the appropriate targets in Xcode
5. Shared resources should be documented in this section to maintain visibility across the development team