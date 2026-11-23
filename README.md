## MyPortofolio Mobile

Name: **Paramita Santoso**

NPM: **2506554171**

Class: **KKI**<br><br>

### Description
`myportofolio_mobile` is mobile version of `myportofolio`, which showcases my education records and experiences.<br><br>

### Tech Stack
- Flutter
- Dart
<br><br>

### Set up locally
1. Clone the repository:
    ```bash
    git clone https://github.com/paramitasan/myportofolio_mobile.git
    cd myportofolio_mobile
    ```

2. Install the dependencies:
    ```
    flutter pub get
    ```
3. Run the application (on a connected device, emulator, or web server):
    ```
    flutter run
    # or run via web server:
    flutter run -d web-server
    ```
4. If using web-server, open the localhost URL printed in the terminal in your browser.
<br>

---
### Week 2 (Assignment 08) - 23 Nov 2026
- Add education record and experience form
- Form validation
- Navigation (through Home screen and drawer)<br>

#### Reflection
1. 
    **Explain the differences between Navigator.push(), Navigator.pushReplacement(), and Navigator.pop().**
    **`Navigator.push()`** opens a new page on top of the current page by adding the new route onto the navigation stack, allowing user to return to the previous screen.  
    **`Navigator.pushReplacement()`** replaces the current page on top of the navigation stack with a new page, removing the previous route so user cannot navigate back to it.  
    **`Navigator.pop()`** closes the page on top of the stack and removes it from the stack. This returns user to the underlying screen.  
    **How the Home option in the drawer takes user back to the home screen?**
    In `LeftDrawer` (`left_drawer.dart`), tapping the Home `ListTile` calls `Navigator.pushReplacement()` with a `MaterialPageRoute` pointing to `MyHomePage()`, replacing the current form screen with the home screen.
    <br>
2. 
    **How does the arrangement of Scaffold, AppBar, and Drawer keep the page structure consistent?**
    Every screen (`MyHomePage`, `ExperienceFormPage`, and `EducationFormPage`) uses `Scaffold` as its base layout, pairing a uniform `AppBar` at the top with the shared LeftDrawer widget in its drawer property. The drawer in `left_drawer.dart` ensures consistent top-bar styling, layout hierarchy, and navigation options across all pages.  
    **Give one example of the portfolio theme colors being used on more than one page.**
    `backgroundColor: Colors.blueGrey.shade700` is reused across the `AppBar` on `MyHomePage`, `ExperienceFormPage`, and `EducationFormPage`, as well as on the "Save" `ElevatedButton` in both form pages.
    <br>
3. 
    **Why this form layout is chosen.**
    Placing `TextFormField` widgets inside a vertical `Column` creates a clear, single-column top-to-bottom flow that is easy to scan and interact with on mobile screens of varying widths.  
    **Explain what the spacing and scrolling widgets do when screen space is limited.**
    - `SingleChildScrollView` wraps the `Column` so user can scroll through all fields when the screen is small or when the on-screen keyboard opens, preventing `RenderFlex` overflow errors.
    - Padding (`EdgeInsets.all(8.0)`) around each input field and button maintains consistent spacing between touch targets and ensures validation error messages have room to appear without crowding adjacent fields.
    <br>
4. 
    **What roles do `GlobalKey<FormState>`, `validator`, and `validate()` play when Save is pressed?**
    - `GlobalKey<FormState>` (`_formKey`): Uniquely identifies the Form widget and exposes its `FormState` so external widgets (like the "Save" button) can inspect and control the form.
    - `validator`: A callback attached to each `TextFormField` that checks user's input against field constraints and returns a String error message when invalid.
    - `validate()`: Triggered by `_formKey.currentState!.validate()` when "Save" is pressed. It executes every validator in the form, displays any returned error messages directly below the invalid fields, and returns true only if all fields pass.  
    **Give one example of a value the form rejects and explain why choosing an input widget or keyboard type alone is insufficient.**
    In `EducationFormPage`, entering 2000 for `Starting Year` or `End Year` is rejected because the validator enforces a range between 2010 and 2100. Relying only on `keyboardType: TextInputType.number` is insufficient because it only hints which keyboard to open on mobile devices. It does not enforce domain rules (such as the 2010–2100 year range or ensuring `end_year` >= `starting_year`). It also does not prevent invalid characters typed via physical/web keyboards or pasted from the clipboard.
    <br>

#### AI Disclosure
- **Tools used:**
    - Google Gemini: Used for reviewing code, giving suggestions, diagnosing issues, and debugging.
<br>

- **Prompt Strategy & Assisted Parts:**
  - Provided the Django models (Experience and Education) alongside Dart files, then ask targeted questions and explanations.
  - **Specific assisted parts:** Formatting `DateTime` values in the confirmation dialog to display YYYY-MM-DD without timestamps and '-' when ended_at is null, mapping Django fields and constraints into Flutter.
<br>

- **Prompts:**
    - "I uploaded `experience_form.dart`. This is my experience model in my Django project. Help me check the form fields in my dart project and tell me what needs to be changed so that it matches my Django project."
    - "I uploaded `education_form.dart`. This is my education model in my Django project. Help me check the form fields in my dart project and tell me what needs to be changed so that it matches my Django project."
    - "How to display `$_startedAt` and `$_endedAt` (if exist) without the time?"
    - "Could you help me check my code for potential bugs?"
<br>

- **AI's Limitation & Manual Fix:**
    - AI could not execute or visually inspect, so the running app, web-server navigation, theme consistency, and edge-case form inputs had to be tested and verified manually.

---
### Week 1 (Assignment 07) - 16 Nov 2026
- Main page containing profile information and buttons (responsive)
- Profile information can be copied to clipboard ★<br>

#### Reflection
1. 
    In Flutter, **widget tree** is the logical representation of all the UIs widgets. The tree determines how widgets relate to one another. **Parent widgets** contain and configure child widgets—passing down layout constraints (such as maximum width or padding) and styling, while **child widgets** determine how they render within those constraints. 
    <br>
2. 
    List of the widgets used in this project and their functions.<br>
    **Custom Widgets:**
    - `MyApp`: The root widget of the application.
    - `MyHomePage`: The main page layout containing the user's profile cards and action button grid.
    - `InfoCard`: Displays individual profile details (NPM, Name, Class) inside a styled card.
    - `ItemCard`: Renders each interactive menu button with an icon, label, and tap feedback.
    *(`ItemHomepage` is used to hold button data, though it is a Dart model class rather than a widget.)*
    <br>
    
    **Built-in Flutter Widgets:**
    - `MaterialApp`: Configures Material Design styling, app title, and root navigation.
    - `Scaffold`: Provides the basic visual layout structure (app bar and body).
    - `AppBar`: Displays the top navigation bar with the `'MyPortofolio'` title.
    - `SingleChildScrollView`: Enables vertical scrolling so pixel overflow does not occur on smaller screens.
    - `Center`: Aligns its child widget to the center of the available space.
    - `ConstrainedBox`: Caps the maximum width of the content (900px) so the layout remains readable on wider screens.
    - `Padding` & `SizedBox`: Add spacing around and between widgets.
    - `Column` & `Row`: Arrange child widgets vertically and horizontally.
    - `Expanded`: Makes each `InfoCard` share available horizontal width equally inside a `Row`.
    - `GridView.count`: Displays the 5 menu buttons in a 3-column grid.
    - `Card`: Gives `InfoCard` a Material surface with rounded corners and elevation shadow.
    - `Material`: Provides the background color and rounded border radius for `ItemCard`.
    - `InkWell`: Detects tap gestures (`onTap`).
    - `Container`: Holds child widgets with internal padding.
    - `Text` & `Icon`: Display text labels and Material icons.
    - `SnackBar`: Shows brief feedback notifications at the bottom of the screen when buttons are tapped or info is copied.
    <br>
3. 
    **`MaterialApp`** is a convenience widget that wraps several foundational widgets required for a Material Design application, such as navigation (`Navigator`), theming (`ThemeData`), localization, and default text styles. It is commonly used as the root widget because it establishes a consistent visual design system across all screens and provides essential app-wide services (like routing and `ScaffoldMessenger` for snackbars) to every descendant widget in the tree.
    <br>
4. 
    **StatelessWidget** is a widget whose configuration and appearance does not change after being built, usually used for displaying static information that does not depend on user input. On the other hand, **StatefulWidget** is a widget that can change its appearance or behavior while the app is running. It is necessary when we want to make components that respond to user input.
    <br>
5. 
    **`BuildContext`** is an object that handles the location of a specific widget within the widget tree. It is crucial because it allows a widget to look up and interact with ancestor widgets above it in the tree. Inside the `build` method, `context` is used to access inherited data—for example, calling `ScaffoldMessenger.of(context)` to locate the nearest `Scaffold` and display a `SnackBar`.
    <br>
6. 
    "Explain the concept of hot reload in Flutter and how it differs from hot restart. When can you not rely on hot reload and must instead perform a hot restart or full restart?"<br>
    - **Hot reload:** updates UI almost instantly while preserving current app state (such as navigation stack, form inputs, and variable values).
    - **Hot restart:** Restarts the Flutter application completely, destroying and reinitializing all states back to their initial values.
    <br>

    Hot restart must be done when we want to make the app return to its original state. A **hot restart** or **full restart** is required when making changes to `main()`, `initState()`, global or static variables, `enum` definitions, or when converting a `StatelessWidget` into a `StatefulWidget`. Additionally, a **full restart** (rebuilding the app) is necessary when adding new native dependencies/packages in `pubspec.yaml` or modifying native Android/iOS configuration files.
    <br>

#### AI Disclosure
- **Tools used:**
    - Google Gemini: Used for reviewing code structure, diagnosing issues, and giving suggestions.
    - Claude Sonnet 5.5: Used for debugging widget behavior and implementing the tap-to-copy clipboard interaction.
<br>

- **Prompt Strategy & Assisted Parts:**
  - I sent my latest file, then used targeted prompts describing specific errors (such as pixel overflow) or desired interactions (`InkWell` tap-to-copy). I also asked the AI to explain *why* specific widgets worked so I could integrate them cleanly into my existing codebase.
  - **Specific assisted parts:** Wrapping the body in `SingleChildScrollView` + `ConstrainedBox` + `Expanded` for responsiveness in `menu.dart`, and adding `Clipboard.setData` inside `InfoCard`.
<br>

- **Prompts:**
    - "Could you help me fix the pixel overflow problem I currently have? I would like to make the page responsive if possible. Explain the problem and what you did."
    - "I'd like to have tap-to-copy feature for InfoCard. I read it uses InkWell. How to implement it?"
<br>

- **AI's Limitation & Manual Fix:**
    - Context-unaware snippets and bracket nesting: The AI only gave partial code snippets with different indentation than my file. I had to manually trace the widget tree and verify where to insert the lines so mismatched parentheses wouldn't break the build or cause layout errors.