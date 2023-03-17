# **Social Authentication with Flutter Wihtout Firebase**

The app allows users to log in using social OAuth
- Google
- GitHub
- LinkedIn
- Twitter
- Microsoft
- Slack
- Facebook.

This project is a Flutter application that demonstrates how to implement social authentication on android web windows ios using a Node.js backend API 
  - **[Nodedjs Repo Github link](https://github.com/aawssm/oAuth_Nodejs)** 
  - **[Youtube tutorial Click Here](https://youtu.be/V7-Cp6n4kjg)**.

The app uses the following dependencies:

- **`routemaster`**: A simple and flexible routing library for Flutter.
- **`url_launcher`**: A Flutter package for launching URLs.

## **Installation**

1. Clone the repository:

```
git clone https://github.com/your-username/social-auth-flutter.git

```

1. Install dependencies by running the following command in the project directory:

```
flutter pub get

```

1. In the **`lib/api/dio.dart`** file, change the **`baseDiol`** variable to match the URL of your backend API.
2. Run the app on an emulator or physical device using the following command:

```
flutter run

```


After clicking on the desired social login button, the app launches a URL using the **`url_launcher`** package to initiate the OAuth authentication flow. Once the user has successfully authenticated with the chosen provider, they will be redirected back to the app and receive an access token.

The app uses the **`routemaster`** package to manage the different pages of the app, including the login page, home page, and social login callback pages.
