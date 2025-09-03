# JET-VisionOS CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in the JET-VisionOS target, which is designed for Apple Vision Pro.

## Overview

The JET-VisionOS target extends the core flight data recording functionality of JETJETJET to the spatial computing environment of Apple Vision Pro. It leverages visionOS-specific features to create an immersive 3D flight visualization experience.

## visionOS Development Guidelines

### Core Concepts
- Use SwiftUI for building spatial interfaces that take advantage of visionOS's spectrum of immersion
- Implement both windowed and fully immersive experiences
- Leverage RealityKit for advanced 3D rendering and spatial interactions
- Design for hand gestures and eye tracking as primary input methods

### Key visionOS Features to Utilize

#### Immersive Spaces
- Create immersive experiences using `ImmersiveSpace` and related APIs
- Implement proper scene transitions between windowed and immersive modes
- Use `RealityView` for custom RealityKit content in SwiftUI

#### Spatial Interactions
- Design for spatial hand gestures (tap, pinch, drag, zoom, rotate)
- Support eye tracking for element selection
- Implement proper gesture recognition using built-in SwiftUI gestures and ARKit for custom gestures

#### 3D Content Integration
- Use RealityKit and Reality Composer Pro for advanced 3D scenes
- Position and size windows appropriately in 3D space
- Implement object tracking and plane detection where relevant

#### Performance Considerations
- Optimize rendering costs for both UI and RealityKit content
- Follow visionOS performance best practices
- Test on actual Apple Vision Pro hardware when possible

### Architecture Patterns
- Extend existing ViewModels where appropriate for visionOS-specific functionality
- Create visionOS-specific Views that leverage spatial computing capabilities
- Use shared Models and Services from the main JETJETJET target when possible

### Notion Development Resources
- Reference the [visionOS 开发 Notion database](https://www.notion.so/crhlove/261be9d6386a80718480deccb539f276?v=261be9d6386a806c902f000cc0d1930f&source=copy_link) for additional resources and documentation
- Add new relevant resources to the Notion database to maintain a comprehensive knowledge base

### Apple Documentation References
- [visionOS Documentation](https://developer.apple.com/documentation/visionOS)
- [Adding 3D Content to Your App](https://developer.apple.com/documentation/visionOS/adding-3d-content-to-your-app)
- [Creating Fully Immersive Experiences](https://developer.apple.com/documentation/visionOS/creating-fully-immersive-experiences)
- [Designing for visionOS](https://developer.apple.com/design/human-interface-guidelines/designing-for-visionos)

## Development Tasks

### Creating New Features
1. Follow MVVM pattern with SwiftUI Views and Observable ViewModels
2. Leverage existing Services from the main target where appropriate
3. Implement spatial interactions using visionOS-specific APIs
4. Test both windowed and immersive experiences

### Working with 3D Content
1. Use RealityKit for advanced 3D rendering
2. Create Reality Composer Pro projects for complex scenes
3. Position entities using head and device transforms
4. Enable video reflections in immersive environments where appropriate

## Best Practices

### UI/UX Design
- Follow Apple's Human Interface Guidelines for visionOS
- Design for both intimate and fully immersive experiences
- Ensure proper sizing and positioning of UI elements in 3D space
- Implement smooth transitions between different levels of immersion

### Performance
- Profile app performance regularly using Xcode tools
- Optimize RealityKit content rendering costs
- Reduce UI rendering costs in visionOS
- Implement efficient scene restoration patterns

### Compatibility
- Ensure the app works well in both windowed and immersive modes
- Consider how existing iOS functionality translates to visionOS
- Maintain feature parity where appropriate between iOS and visionOS versions