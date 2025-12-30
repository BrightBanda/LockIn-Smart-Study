// ---------------------------
// Project-level Gradle file
// ---------------------------

buildscript {
    repositories {
        google()       // Required for Google plugins
        mavenCentral() // Required for Gradle dependencies
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.0.2") // Android Gradle Plugin
        classpath("com.google.gms:google-services:4.4.0") // Google Services plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: Custom build directories
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
