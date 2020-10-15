# PhotoKit

Fetch gallery photos and videos.  


## Usage

Permission requerid:  
You can use PhotoKit [Permission](./photokitPermission.md)


```javascript
import { PhotoKit } from 'react-native-jjkit'
                                                     
    var mediaQuery = 
    PhotoKit.gif  
    PhotoKit.photo   
    PhotoKit.image  // gif and photo
    PhotoKit.video  // video
    PhotoKit.video_gif // video and gif
    PhotoKit.video_photo // video and photo
    PhotoKit.all  // image and video

    // default value null , empty,undefined (all albums)
    var names = ["Pictures","Camera roll","WhatsApp","Whats App","whats app images"] 

    var names = ["Pictures"] // one Album


    //pagination
     //limit : Constrains the maximum number of rows returned , default value -1 
    const limit = 100
    // offset: the number of rows to skip , default value -1
    const offet = 50 

    const query = {
       query: mediaQuery,
       names: names,
       limit: limit ,
       offset: offset, 

    }

    /*ORDER BY:
      android -> date added DESC
      ios -> modification Date DESC
    */

    //fetches albums and medias
    PhotoKit.fetch(query).then(res => {
      console.log("albums: ",res[0])
      console.log("Images/Videos: ",res[1])
    })
   

   //only fetches albums
    PhotoKit.fetchAlbums(mediaQuery).then(res => {
        console.log("albums: ",res)
    })
   

```

Preview: Use [ImageListView](imageListView.md)

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


## Get Bytes

byte array encoded to base64 String

Warn: Maybe freeze with debug.

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

