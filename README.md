# oobacht

Project for the lecture "Development of mobile applications" at DHBW Stuttgart Campus Horb

## Ordner Struktur

- assets: Icons, Logos, Bilder
- fonts:  Schriftarten
- lib: Code
  - firebase: Alles bzgl. firebase
  - logic:    
    - classes: Datenklassen und sonstige Klassen
    - services: Services die Funktionen bereit stellen
  - screens:  Einzelne Screens: Jeder Screen neuer Unterordner
    - main_menu:      Name des Screens
      - (components): Widgets die nur in diesem Screen gebraucht werden und größer
      - main_menu.dart: Layout/Scaffold des Screens
      - ...
  - utils:     Funktionen die in der App mehrmals verwendet werden, z.B. Validierung, Theme
  - widgets:   Widgets die in der App mehrmals verwendet werden, z.B. App-Bar, Eingabefelder
  - main.dart:   Hauptklasse

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
