# Tip Calculator iOS App - Technical Documentation

## Table of Contents
1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Core Components](#core-components)
4. [Models & Data Management](#models--data-management)
5. [ViewModels & Business Logic](#viewmodels--business-logic)
6. [Controllers](#controllers)
7. [Views & UI Components](#views--ui-components)
8. [Utilities & Extensions](#utilities--extensions)
9. [Error Handling](#error-handling)
10. [Accessibility](#accessibility)
11. [Testing](#testing)

## Overview

The Tip Calculator is an iOS application built with UIKit and SwiftUI that allows users to calculate tips, split bills among multiple people, and save calculation history. The app features voice input capabilities, accessibility support, and a modern UI design.

### Key Features
- **Tip Calculation**: Calculate tips with predefined percentages (10%, 15%, 20%, 25%)
- **Bill Splitting**: Split bills among multiple people (1-10 people)
- **Voice Input**: Speech recognition for hands-free bill entry
- **Data Persistence**: Save and retrieve calculation history using Core Data
- **Accessibility**: Full VoiceOver and accessibility support
- **Modern UI**: SwiftUI previews and dynamic type support

## Architecture

The application follows the **MVVM (Model-View-ViewModel)** architectural pattern with the following key principles:

### Design Patterns Used
- **MVVM**: Separation of business logic (ViewModels) from UI (Views/Controllers)
- **Protocol-Oriented Programming**: Extensive use of protocols for loose coupling
- **Dependency Injection**: ViewModels are injected into Controllers
- **Observer Pattern**: NotificationCenter for communication between components
- **Repository Pattern**: Core Data abstraction through PersistanceServices

### Architecture Layers

```
┌─────────────────────────────────────────┐
│                UI Layer                 │
│  Controllers + Views + SwiftUI Previews │
├─────────────────────────────────────────┤
│              ViewModel Layer            │
│    CalculationsViewModel + SaveViewModel │
├─────────────────────────────────────────┤
│               Model Layer               │
│        Bill Entity + Core Data          │
├─────────────────────────────────────────┤
│              Service Layer               │
│      PersistanceServices + Utils        │
└─────────────────────────────────────────┘
```

## Core Components

### 1. MainController
**Purpose**: Primary view controller managing the main tip calculation interface

**Key Responsibilities**:
- Manages user input and UI interactions
- Coordinates between ViewModels and Views
- Handles speech recognition for voice input
- Manages navigation and presentation of modals

**Key Features**:
- Real-time tip calculation as user types
- Voice input with microphone button
- Bill splitting functionality with stepper control
- Save functionality with pin button
- Clear/reset functionality

### 2. PresentingTipViewController
**Purpose**: Displays saved bill calculations in a table view

**Key Responsibilities**:
- Shows list of saved calculations
- Handles deletion of saved bills
- Provides empty state messaging
- Manages table view data source

### 3. BillCell
**Purpose**: Custom table view cell for displaying saved bill information

**Key Features**:
- Displays bill amount, tip, total, and date
- Shows split information when applicable
- Custom styling with shadows and rounded corners
- Color-coded left border for visual distinction

## Models & Data Management

### Core Data Entity: Bill

```swift
// Core Data properties (auto-generated)
@NSManaged public var input: String?
@NSManaged public var tip: String?
@NSManaged public var total: String?
@NSManaged public var date: String?
@NSManaged public var splitTotal: String?
@NSManaged public var splitPeopleQuantity: String?
```

**Purpose**: Represents a saved bill calculation with all relevant information

### PersistanceServices
**Purpose**: Core Data management and persistence layer

**Key Features**:
- Singleton pattern for shared Core Data context
- Error handling for save/load operations
- Automatic context saving
- Persistent store management

**Error Handling**:
```swift
enum PersistenceError: Error {
    case saveError(NSError, userInfo: [String:Any])
    case loadPersistentStoreError(NSError, userInfo: [String:Any])
}
```

## ViewModels & Business Logic

### CalculationsViewModel
**Purpose**: Handles all tip calculation logic and bill splitting

**Key Methods**:
- `calculateTip()`: Calculates tip based on bill amount and percentage
- `reset()`: Clears all input fields and resets calculations
- `splitBill()`: Calculates per-person amount when splitting bills

**Business Logic**:
- Supports 4 tip percentages: 10%, 15%, 20%, 25%
- Real-time calculation updates
- Currency formatting for display
- Bill splitting for 1-10 people

### SaveViewModel
**Purpose**: Manages saving and retrieving bill calculations

**Key Features**:
- Saves calculations to Core Data
- Fetches and sorts saved bills
- Handles validation before saving
- Manages toast notifications
- Provides sorted bill list (newest first)

**Data Flow**:
1. User enters bill amount
2. CalculationsViewModel calculates tip and total
3. User taps save button
4. SaveViewModel validates and saves to Core Data
5. UI updates with success feedback

## Controllers

### MainController
**Primary Responsibilities**:
- **UI Management**: Sets up and manages all UI components
- **User Input**: Handles text field input and stepper changes
- **Speech Recognition**: Manages voice input functionality
- **Navigation**: Handles modal presentations
- **Event Handling**: Responds to user interactions

**Key Protocols Implemented**:
- `CalculationsViewModelProtocol`: Access to calculation logic
- `SaveViewModelProtocol`: Access to save functionality
- `SpeechControllerProtocol`: Voice input management
- `SetUIProtocol`: UI setup and configuration

### PresentingTipViewController
**Primary Responsibilities**:
- **Data Display**: Shows saved bill calculations
- **User Interaction**: Handles bill deletion
- **Empty States**: Manages empty table view display
- **Navigation**: Dismissal handling

## Views & UI Components

### MainView (MainController Extension)
**UI Components**:
- **Input Field**: Text field for bill amount with voice input
- **Tip Display**: Shows calculated tip amount
- **Total Display**: Shows total bill with tip
- **Split Controls**: Stepper for number of people
- **Percentage Selector**: Segmented control for tip percentage
- **Action Buttons**: Save, clear, and view history buttons

**Layout Features**:
- Scroll view for content overflow
- Dynamic type support
- Accessibility labels and hints
- Responsive design

### BillCell
**Visual Features**:
- Card-style design with shadows
- Color-coded left border
- Split information display
- Date and time formatting
- Accessibility support

## Utilities & Extensions

### AnchorsLayout
**Purpose**: Simplified Auto Layout constraint management

**Key Features**:
- `anchor()` method for easy constraint setup
- `fillSuperview()` for full view coverage
- `centerInSuperview()` for centering
- Support for padding and size parameters

### AccessibilityUtils
**Purpose**: Enhanced accessibility support for UI components

**Key Features**:
- Dynamic font scaling
- Accessibility labels and hints
- VoiceOver optimization
- Content size category support

### String Extensions
**Purpose**: Currency formatting and text processing

**Key Features**:
- `currencyInputFormatting()`: Formats text as currency
- Regex-based number extraction
- Locale-aware formatting

## Error Handling

### Core Data Errors
- **Save Errors**: Handled in PersistanceServices with custom error types
- **Fetch Errors**: Caught and logged in ViewModels
- **Context Errors**: Managed through try-catch blocks

### User Input Validation
- **Empty Input**: Alert shown when trying to save empty values
- **Invalid Numbers**: Graceful handling of non-numeric input
- **Speech Recognition**: Error handling for audio session issues

### UI Error States
- **Empty Table View**: Custom empty state with helpful messaging
- **Network Issues**: Graceful degradation for offline usage
- **Permission Denied**: Proper handling of speech recognition permissions

## Accessibility

### VoiceOver Support
- **Labels**: Descriptive labels for all UI elements
- **Hints**: Contextual hints for user actions
- **Traits**: Proper accessibility traits for interactive elements
- **Navigation**: Logical reading order

### Dynamic Type
- **Font Scaling**: All text scales with system font size
- **Layout Adaptation**: UI adapts to larger text sizes
- **Content Priority**: Important information remains visible

### Voice Input
- **Speech Recognition**: Hands-free bill entry
- **Audio Feedback**: Visual indicators for recording state
- **Permission Handling**: Graceful permission request flow

## Testing

### Unit Tests
- **SaveViewModelTests**: Tests for save functionality
- **SpeechTest**: Tests for speech recognition
- **TipCalcTests**: General application tests

### Test Coverage Areas
- **Calculation Logic**: Tip and total calculations
- **Data Persistence**: Save and fetch operations
- **User Input**: Text field and stepper interactions
- **Error Handling**: Edge cases and error scenarios

## Key Design Decisions

### 1. MVVM Architecture
**Rationale**: Separates business logic from UI, making the code more testable and maintainable.

### 2. Protocol-Oriented Design
**Rationale**: Enables loose coupling between components and improves testability.

### 3. Core Data for Persistence
**Rationale**: Provides robust data persistence with relationship management and querying capabilities.

### 4. Speech Recognition Integration
**Rationale**: Enhances accessibility and provides hands-free operation for better user experience.

### 5. Dynamic Type Support
**Rationale**: Ensures accessibility compliance and improves usability for users with visual impairments.

## Future Enhancements

### Potential Improvements
1. **Cloud Sync**: iCloud integration for data synchronization
2. **Custom Percentages**: User-defined tip percentages
3. **Receipt Scanning**: OCR for automatic bill entry
4. **Export Functionality**: PDF or CSV export of calculations
5. **Widget Support**: Home screen widget for quick calculations
6. **Apple Watch App**: Companion app for quick calculations
7. **Multiple Currencies**: Support for different currencies
8. **Calculation History**: Enhanced filtering and search

### Technical Debt
1. **Error Handling**: More comprehensive error handling throughout
2. **Testing**: Increased test coverage for edge cases
3. **Performance**: Optimization for large datasets
4. **Code Documentation**: More inline documentation
5. **Refactoring**: Some legacy code could be modernized

## Conclusion

The Tip Calculator app demonstrates a well-structured iOS application with proper separation of concerns, accessibility support, and modern iOS development practices. The MVVM architecture, combined with protocol-oriented programming and comprehensive error handling, creates a maintainable and extensible codebase.

The app successfully balances functionality with usability, providing both traditional input methods and modern voice input capabilities while maintaining full accessibility compliance.
