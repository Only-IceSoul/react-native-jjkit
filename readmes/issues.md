
## Android 

**Incompatibility with gradle**  
update to 3.6.1+  

```gradle
buildscript {

        dependencies {
            classpath 'com.android.tools.build:gradle:3.6.1'
           
        }
}

```

/gradle-wrapper.properties 

update ur distributionURL

[all versions](https://developer.android.com/studio/releases/gradle-plugin)

```
distributionUrl=https\://services.gradle.org/distributions/gradle-5.6.4-all.zip  //or last version

```

build project

**AndroiX**

Install jetifier

```
npm install jetifier --save
 
```


## IOS

**swift**  

```
open ios project .xcworkspace 
add a swift file to folder projectname (skip bridge)
```

OR

open ios/podfile,  add in the first line

```
 ENV['SWIFT_VERSION'] = '4.2'

```

**Missing librarys**  

project

```
 cd ios
 pod deintegrate
 pod install
```


**To much files**

brew uninstall watchman
brew install watchman
