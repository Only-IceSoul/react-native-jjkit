# Image

An ImageView for url.

Image is a wrapper around [Guiso](https://github.com/Only-IceSoul/ios-Guiso) (iOS) and [Glide](https://github.com/bumptech/glide) (Android).

## **Freatures**

- [x] Memory cache
- [x] Disk cache
- [x] Resize(fitCenter)
- [x] url local 
- [x] url Web 
- [x] Gif


## **Usage**

```javascript
  import { Image } from 'react-native-jjkit'

  const resized = {
      url: "Path to the file",
      asGif: false // static or animated gif.
      width: 200, 
      height: 200,
      cache: true // memory cache
  }
  const original = {
      url: "Path to the file ",
      asGif: false
      width: -1, 
      height: -1, 
      cache: true 
  }

  //preview Scale 
  const myScaleType = 1
  // 0  CenterCrop - scaleAspectFill (default)
  // 1  fitCenter - scaleAspectFit

  <Image data={resized} scaleType={myScaleType} >

```


## **Clear memory cache**

```javascript
  import { PhotoKit } from 'react-native-jjkit'

    PhotoKit.clearMemoryCache()

```
