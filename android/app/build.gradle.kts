plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.xr.xrtechtools"  // ← CHANGÉ
    compileSdk = 34  // ← FIXÉ à 34
    ndkVersion = "25.1.8937393"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8  // ← CHANGÉ de 11 à 8
        targetCompatibility = JavaVersion.VERSION_1_8  // ← CHANGÉ de 11 à 8
    }

    kotlinOptions {
        jvmTarget = "1.8"  // ← CHANGÉ de 11 à 8
    }

    defaultConfig {
        applicationId = "com.xr.xrtechtools"  // ← CHANGÉ
        minSdk = 21  // ← FIXÉ à 21 (au lieu de flutter.minSdkVersion)
        targetSdk = 34  // ← FIXÉ à 34
        versionCode = 1
        versionName = "1.0.0"
        
        multiDexEnabled = true  // ← AJOUTÉ
    }

    buildTypes {
        release {
            isMinifyEnabled = false  // ← AJOUTÉ (désactive ProGuard)
            isShrinkResources = false  // ← AJOUTÉ
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")  // ← AJOUTÉ
}