allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

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
    afterEvaluate {
        if (plugins.hasPlugin("com.android.application") || plugins.hasPlugin("com.android.library")) {
            val androidExtension = extensions.findByName("android") as? com.android.build.gradle.BaseExtension
            if (androidExtension != null && androidExtension.namespace == null) {
                androidExtension.namespace = group.toString()
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    afterEvaluate {
        val extension = extensions.findByName("android")
        if (extension != null) {
            when (extension) {
                is com.android.build.gradle.LibraryExtension -> {
                    // Forzamos el SDK de manera segura sin llamadas directas a operadores anulables
                    extension.compileSdk = 36
                }
                is com.android.build.gradle.AppExtension -> {
                    extension.compileSdkVersion(36)
                }
            }
        }
    }
}