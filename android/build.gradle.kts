allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Le dice a Gradle que no importa qué versión pidan mis dependencias (como url_launcher), ignóralas y usa específicamente estas versiones que yo digo (No recomendado).
// subprojects {
//     configurations.all {
//         resolutionStrategy {
//             force("androidx.browser:browser:1.8.0")
//             force("androidx.core:core:1.13.1")
//             force("androidx.core:core-ktx:1.13.1")
//         }
//     }
// }

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
