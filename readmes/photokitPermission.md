# PhotoKit Permission

## Android

update your AndroidManifiest.xml
```xml
 <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
 <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

## IOS
update your Info.plist

```xml
  <key>NSPhotoLibraryUsageDescription</key>
  <string>YOUR TEXT</string>
```


## Request 
```javascript

    import { PhotoKit } from 'react-native-jjkit'

    PhotoKit.isPermissionGranted().then((granted) => {
        if(!granted){
        PhotoKit.requestPermission().then(result => {
                    switch (result){
                    case 0:
                        //notDetermined
                    case 1:
                        //authorized
                        break;
                    case 2:
                        //denied
                        break;
                    }
            })
        }
    }
```