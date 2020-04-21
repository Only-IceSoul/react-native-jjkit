# Image

An ImageView for url.

## **Freatures**

### Android(Glide):
 
- [x] Memory cache
- [x] Disk cache
- [x] Resize(fitCenter)
- [x] url local
- [x] url Web

### IOS:
- [x] Memory cache
- [ ] Disk cache
- [x] Resize(fitCenter)
- [x] url local
- [ ] url Web


## **Usage**

```javascript
  import { Image } from 'react-native-jjkit'

  const thumbnailData = {
      url: "Path to the file",
      type: "video" or "image",
      width: 200, 
      height: 200,
      cache: true
  }
  const originalData = {
      url: "Path to the file",
      type: "video" or "image",
      width: -1, //original size need w -1 and h -1
      height: -1,  
      cache: true
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