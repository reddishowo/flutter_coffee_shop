plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // Pastikan plugin ini tetap ada
    id("com.google.gms.google-services")
}

android {
    namespace = "com.coffeeshop.coffee_shop"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    buildToolsVersion = "34.0.0"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        
        // --- [TAMBAHAN 1] Aktifkan Desugaring ---
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.coffeeshop.coffee_shop"
        // Ubah minSdk minimal ke 21 jika nanti masih error, tapi coba default dulu
        minSdk = flutter.minSdkVersion 
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Opsional: Aktifkan MultiDex jika nanti error method limit
        multiDexEnabled = true 
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// --- [TAMBAHAN 2] Dependency khusus Desugaring ---
dependencies {
    // Library ini wajib agar fitur desugaring berjalan
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}