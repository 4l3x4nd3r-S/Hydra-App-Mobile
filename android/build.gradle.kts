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
    project.evaluationDependsOn(":app")
}

subprojects {
    val subproject = this
    if (subproject.state.executed) {
        if (subproject.hasProperty("android")) {
            val android = subproject.extensions.getByName("android")
            (android as? com.android.build.gradle.BaseExtension)?.compileSdkVersion(36)
        }
    } else {
        subproject.afterEvaluate {
            if (subproject.hasProperty("android")) {
                val android = subproject.extensions.getByName("android")
                (android as? com.android.build.gradle.BaseExtension)?.compileSdkVersion(36)
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
