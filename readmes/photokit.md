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
| date |   android(Date added) ios(Modification Date) | String | 
| duration | the playback duration of the data source in seconds | Number | 
| height | The height of the image/video in pixels. | Number | 
| width |  The width of the image/video in pixels. | Number | 


## Albums ignored

### IOS

 -  Hidden
 -  Bursts
 -  Recently Added
 -  Recently Deleted
 -  Unable to Upload
 -  Camera Roll
 -  Recents


# Send me your suggestions at

justinjlf21@gmail.com