# FamilyMemberDetailsPage Implementation

## Overview
This implementation adds a new `FamilyMemberDetailsPage` that displays detailed information about a family member when their card is tapped on the `FamilyDetailsPage`. The page integrates with the backend API to fetch and display conflict case data.

## Features Implemented

### 1. Navigation Enhancement
- **Before**: MemberCard was static display only
- **After**: MemberCard is clickable with visual feedback ("اضغط للمزيد من التفاصيل")
- Navigates to new `FamilyMemberDetailsPage` passing the Person object

### 2. New UI Components

#### Member Profile Section
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
    ),
  ),
  child: Column(
    children: [
      CircleAvatar(radius: 50, ...),
      Text(familyMember.fullName, ...),
    ],
  ),
)
```

#### Member Details Section
- Displays personal information in Arabic RTL layout
- Gender, ID info, contact details, etc.
- Responsive card design

#### Conflict Cases Table
- Header with service type, title, date, status
- Color-coded status indicators (محلول/قيد المراجعة)
- Empty state handling

### 3. API Integration

#### New Endpoint Added
```dart
static const String getConflictCasesByFamilyMember = 
    '$server/ConflictCase/ByFamilyMember';
```

#### ConflictCase Model
```dart
class ConflictCase {
  final int id;
  final String conflictTypeName;
  final String? managerName;
  final String notes;
  final String imageUrl;
  final DateTime sessionDate;
  final bool isResolved;
  final String title;
  // ... more fields
}
```

#### API Method in FamilyCubit
```dart
Future<void> getConflictCasesByFamilyMember(int familyMemberId) async {
  emit(ConflictCasesLoading());
  try {
    final response = await api.get(
      '${ApiLink.getConflictCasesByFamilyMember}/$familyMemberId',
    );
    // Process response...
    emit(ConflictCasesLoaded(conflictCases: conflictCases));
  } catch (e) {
    emit(FamilyFailure(errorMessage: e.toString()));
  }
}
```

### 4. State Management

#### New States Added
```dart
class ConflictCasesLoaded extends FamilyState {
  final List<ConflictCase> conflictCases;
}

class ConflictCasesLoading extends FamilyState {}
```

#### State Handling in UI
- **ConflictCasesLoading**: Shows CircularProgressIndicator
- **ConflictCasesLoaded**: Displays table with data
- **FamilyFailure**: Shows retry button with OnFailureWidget
- **Empty Data**: Shows user-friendly message

### 5. UI Layout Structure

```
FamilyMemberDetailsPage
├── AppBar (تفاصيل عضو الأسرة)
├── SingleChildScrollView
│   ├── _MemberProfileSection (Gradient header)
│   ├── _MemberDetailsSection (Personal info card)
│   ├── _SectionTitle (سجل الخدمات والنشاطات)
│   └── _ConflictCasesSection
│       └── BlocBuilder<FamilyCubit, FamilyState>
│           ├── ConflictCasesLoading → CircularProgressIndicator
│           ├── ConflictCasesLoaded → _ConflictCasesTable
│           └── FamilyFailure → OnFailureWidget
└── CustomNavigationBar
```

### 6. Testing Coverage

#### Model Tests (`conflict_case_test.dart`)
- JSON serialization/deserialization
- Null value handling
- State type validation

#### Widget Tests (`family_member_details_test.dart`)
- Member information display
- Loading state behavior
- Route navigation
- App bar and sections rendering

#### Updated State Tests (`family_state_test.dart`)
- New state classes inheritance
- State properties validation

## Arabic UI Support

### RTL Layout
- `Directionality(textDirection: TextDirection.rtl)`
- Proper text alignment for Arabic content
- Right-to-left table layouts

### Arabic Text Content
- App bar: "تفاصيل عضو الأسرة"
- Section titles: "سجل الخدمات والنشاطات"
- Status indicators: "محلول" / "قيد المراجعة"
- Personal info labels in Arabic

## Error Handling

### API Failures
- Network errors caught and displayed
- Retry functionality via OnFailureWidget
- User-friendly error messages

### Empty States
- No conflict cases: Shows info icon with message
- Loading states: Progress indicators with Arabic text
- Graceful handling of null/empty data

## Visual Design

### Color Scheme
- Primary gradient: Purple/Indigo (#6366F1 to #8B5CF6)
- Status colors: Green for resolved, Orange for pending
- Card elevations and shadows for depth
- Consistent spacing and typography

### Responsive Design
- Flexible layouts that adapt to screen sizes
- Proper text overflow handling
- Scrollable content areas

## File Structure

```
lib/
├── models/
│   └── conflict_case.dart              # New model
├── views/families/
│   ├── family_detiles.dart            # Modified (navigation)
│   └── family_member_details.dart     # New page
├── cubits/family_cubit/
│   ├── family_cubit.dart              # Modified (API method)
│   └── family_state.dart              # Modified (new states)
├── components/constants/
│   ├── app_route.dart                 # Modified (new route)
│   └── api_link.dart                  # Modified (new endpoint)
└── app_route.dart                     # Modified (route handler)

test/
├── conflict_case_test.dart            # New tests
├── family_member_details_test.dart    # New tests
└── family_state_test.dart             # Modified tests
```

## Usage Flow

1. User opens FamilyDetailsPage
2. Family members displayed as cards with "اضغط للمزيد من التفاصيل"
3. User taps on a MemberCard
4. Navigation to FamilyMemberDetailsPage with Person object
5. Page loads member info immediately
6. API call made to fetch conflict cases
7. Loading indicator shown during API call
8. Results displayed in table format
9. User can view detailed service/conflict history

This implementation follows the existing app patterns and provides a comprehensive solution for viewing family member details with their conflict case history.