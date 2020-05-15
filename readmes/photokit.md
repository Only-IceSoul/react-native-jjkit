# PhotoKit

Fetch gallery photos and videos.  


## Usage

Permission requerid:  
You can use PhotoKit [Permission](./photokitPermission.md)


```javascript
import { PhotoKit } from 'react-native-jjkit'
                                                     
    var mediaType =  
     PhotoKit.gif
     PhotoKit.photo
     null or any string  // gif and photo

    PhotoKit.fetchImages(mediaType).then(res => {
      console.log("albums: ",res[0])
      console.log("Images: ",res[1])
    })
    PhotoKit.fetchVideos().then(res => {
        console.log("albums: ",res[0])
        console.log("videos: ",res[1])
    })
    PhotoKit.fetchAll().then(res => {
        console.log("albums: ",res[0])
        console.log("Images/Videos: ",res[1])
    })

    //It will ask if the album name is in the array
    var names = ["Pictures","Camera roll","WhatsApp","Whats App","whats app images"]
    var oneAlbum = ["Pictures"]
    var mediaType = 
    PhotoKit.gif  
    PhotoKit.photo   
    PhotoKit.image  // git and photo
    PhotoKit.video  // video
    PhotoKit.all  // image and video

    PhotoKit.fetchAlbums(names,mediaType).then(res => {
        console.log("albums: ",res[0])
        console.log("Images/Videos: ",res[1])
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
| uri | Path to the file, album cover | String | 
| mediaType | "video" - "image" - "gif" | String | 


### Media

| key | description | type |
| --- | --- | --- |
| albumId | the album id, identifier | Number | 
| albumName | the album name | String | 
| displayName | The display name of the file | String | 
| uri | Path to the file | String | 
| mediaType | "video" - "image" - "gif" | String | 
| date |   android(Date added) ios(Modification Date) | Number | 
| duration | the playback duration of the data source in seconds | Number | 
| height | The height of the image/video in pixels. | Number | 
| width |  The width of the image/video in pixels. | Number | 


## Get Data

byte array encoded to base64 String

### Raw 

```javascript
import { PhotoKit } from 'react-native-jjkit'

PhotoKit.requestRaw(media.uri).then(base64String => {
    console.log("result : ",base64String)
})
```


### Image 

```javascript
import { PhotoKit } from 'react-native-jjkit'

let request = {
    uri: media.uri,
    width: 1280,  //fitcenter
    height: 1280,  // fitcenter
    quality : 0.8, //0.0 to 1  just jpeg
    format : PhotoKit.jpeg  // or png
}

PhotoKit.requestImage(request)
.then(base64String => {
    console.log("result : ",base64String)
})
```

