plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.myapp"
    compileSdk = flutter.compileSdkVersion
    // ndkVersion = flutter.ndkVersion // Comment out or remove the default line
    ndkVersion = "27.0.12077973" // Set the required NDK version


    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.myapp"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Add multiDexEnabled if not already present, often needed with Firebase
        multiDexEnabled = true 
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Add the Google services plugin dependency
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.1.1")) // Check for latest BOM version
    implementation("com.google.firebase:firebase-analytics")
    // Add other Firebase SDKs as needed
    implementation("androidx.multidex:multidex:2.0.1") // Add multidex dependency
}
