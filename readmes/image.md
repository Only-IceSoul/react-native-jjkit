# Image

An ImageView for url.

## **Freatures**

### Android(Glide):
 
- [x] Memory cache
- [x] Disk cache
- [x] Resize(fitCenter,centerCrop(notEnabled))
- [x] url local
- [x] url Web
- [x] Gifs 

### IOS(Guiso):
- [x] Memory cache
- [x] Disk cache
- [x] Resize(fitCenter,centerCrop(notEnabled))
- [x] url local
- [x] url Web
- [x] Gifs


## **Usage**

```javascript
  import { Image } from 'react-native-jjkit'

  const thumbnailData = {
      url: "Path to the file",
      type: "video" or "image" or "gif", //if u just need a thumbnail for gif, use image 
      width: 200, 
      height: 200,
      cache: true // memory cache
  }
  const originalData = {
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

  <Image data={thumbnailData} scaleType={myScaleType} >

```


## **Clear memory cache**

```javascript
  import { PhotoKit } from 'react-native-jjkit'

        PhotoKit.clearMemoryCache()

```