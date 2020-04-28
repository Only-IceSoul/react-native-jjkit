# PhotoKit

Fetch gallery photos and videos.  


## Usage

Permission requerid:  
You can use PhotoKit [Permission](./photokitPermission.md)


```javascript
import { PhotoKit } from 'react-native-jjkit'

    PhotoKit.fetchPhotos().then(res => {
      console.log("albums: ",res[0])
      console.log("photos: ",res[1])
    })
    PhotoKit.fetchVideos().then(res => {
        console.log("albums: ",res[0])
        console.log("videos: ",res[1])
    })
    PhotoKit.fetchPhotosVideos().then(res => {
        console.log("albums: ",res[0])
        console.log("photosVideos: ",res[1])
    })


```

Preview: Use [Image](image.md)

##  Objects

### Album

| key | description | type |
| --- | --- | --- |
| id | album id | Number | 
| name | album name | String | 
| count |  the number of elements | Number | 
| data | Path to the file, album cover | String | 
| mediaType | "video" or "image" | String | 


### Media

| key | description | type |
| --- | --- | --- |
| albumId | the album id, identifier | Number | 
| albumName | the album name | String | 
| displayName | The display name of the file | String | 
| data | Path to the file | String | 
| mediaType | "video" or "image" | String | 
| date |   android(Date added) ios(Modification Date) | Number | 
| duration | the playback duration of the data source in seconds | Number | 
| height | The height of the image/video in pixels. | Number | 
| width |  The width of the image/video in pixels. | Number | 


## Get Data

### Raw 

byte array encoded to base64 String

```javascript
import { PhotoKit } from 'react-native-jjkit'

PhotoKit.requestRaw(Media.data).then(base64String => {
    console.log("result : ",base64String)
})
```


### Photo 

byte array encoded to base64 String

FitCenter 


```javascript
import { PhotoKit } from 'react-native-jjkit'

let request = {
    data: Media.data,
    widht: 1280,  //fitcenter
    height: 1280,  // fitcenter
    quality : 0.8 //0.0 to 1  just jpeg
    format : PhotoKit.jpeg  // or png
}

PhotoKit.requestPhoto(request.data,request.width,request.height,request.format,request.quality).then(base64String => {
    console.log("result : ",base64String)
})
```

