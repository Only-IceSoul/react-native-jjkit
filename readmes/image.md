# Image

An ImageView for url.

## **Freatures**

### Android(Glide):
 
- [x] Memory cache
- [x] Disk cache
- [x] Resize(fitCenter)
- [x] url local
- [x] url Web
- [x] Gif

### IOS(Guiso):
- [x] Memory cache
- [x] Disk cache
- [x] Resize(fitCenter)
- [x] url local 
- [x] url Web
- [x] Gif


## **Usage**

```javascript
  import { Image } from 'react-native-jjkit'

  const thumbnail = {
      url: "Path to the file",
      type: "video" or "image" or "gif", //if u just need a thumbnail for gif, use image 
      width: 200, 
      height: 200,
      cache: true // memory cache
  }
  const original = {
      url: "Path to the file ",
      type: "video" or "image" or "gif" , //if u just need a thumbnail for gif, use image
      width: -1, //original size need w -1 and h -1
      height: -1,  
      cache: true // memory cache
  }

  //preview Scale 
  const myScaleType = 1
  // 0  CenterCrop - scaleAspectFill (default)
  // 1  fitCenter - scaleAspectFit

  <Image data={thumbnail} scaleType={myScaleType} >

```


## **Clear memory cache**

```javascript
  import { PhotoKit } from 'react-native-jjkit'

        PhotoKit.clearMemoryCache()

```