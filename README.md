CineVault - Personal Cinema Assistant
Project Overview
CineVault is a mobile application developed with Flutter that serves as a centralized vault for movie enthusiasts. The primary goal is to solve 'choice paralysis' by providing an organized and clean interface for discovering and tracking personal movie journeys.

Key Features
Modern Authentication Flow: Includes Splash, Login, Sign Up, and Forgot Password screens with a cohesive design.

Dynamic Home Screen: Features movie lists organized in a horizontal layout for smooth browsing.

Advanced Search & Filtering: A pull-up panel using DraggableScrollableSheet with genre chips and rating sliders.

Detailed Movie Insights: Comprehensive detail pages showing posters, release years, and synopses.

Profile Management: User statistics, about section, and a secure logout process with confirmation dialogs.

Technical Architecture
Clean Architecture: Follows 'Separation of Concerns' by organizing the project into Models, Screens, and Widgets folders.

Type-Safe Data Modeling: Uses a structured Movie class with final fields to ensure data integrity.

Component Reusability: Implements custom, reusable widgets for buttons, text fields, and movie cards to maintain 'DRY' principles.

Navigation: Managed through a centralized bottom navigation system and structured Navigator.push transitions for passing data objects.

Development Roadmap
[ ] Firebase Integration: To provide a real-time database for user profiles and watchlists.

[ ] TMDB API Connection: To replace mock data with live, worldwide movie information.

[ ] AI-Powered Recommendations: (Optional) To suggest movies based on user preferences.

How to Run
1. Clone the repository: git clone https://github.com/aliozcankarol/CineVault.git

2. Install dependencies: flutter pub get

3. Run the app: flutter run

Author: Ali Özcan Karol