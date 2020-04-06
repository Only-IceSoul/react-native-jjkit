
## Android

**Add Kotlin**

/app/build.gradle 

```gradle
apply plugin: 'kotlin-android' 
apply plugin: 'kotlin-android-extensions'

android {

   dependencies {
     // From node_modules
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
  
    }
}

```

/build.gradle

```gradle
buildscript {

        ext.kotlin_version = '1.3.61'  //or the last version
        dependencies {
            classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        }
    }
}

```

build porject

## IOS

**add Swift**

```
open ios project .xcworkspace 
add a swift file to folder projectname (skip bridge)
```

**install**

open terminal projectname/ios
```
 pod install
```
