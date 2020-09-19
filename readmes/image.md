# Image

An ImageView for url.

Image is a wrapper around [Guiso](https://github.com/Only-IceSoul/ios-Guiso) (iOS) and [Glide](https://github.com/bumptech/glide) (Android).

## **Freatures**

- [x] Memory cache
- [x] Disk cache
- [x] Resize
- [x] url local 
- [x] url Web 
- [x] Base64 String 
- [x] static Image 
- [x] Gif
- [x] PlaceHolder


## **Usage**

```javascript
  import { Image } from 'react-native-jjkit'
  
  const source = {
      uri: 'https://unsplash.it/200/200?image=1',
      asGif: false
      placeholder: null,
      width: 400, 
      height: 400, 
      cache: true 
  }

  <Image source={source}  />

```


## Properties

### `source?: object`

Source for the remote image to load.

---

### `source.uri?: string`

uri to load the image from. e.g. `'https://facebook.github.io/react/img/logo_og.png'`.
static image --> ("static;${uri}")  
base64String --> ("base64,${value}")
url --> ("https://...")

---

### `source.asGif?: string`

 if the image you load is an animated GIF, Image will display a animated gif.

---

### `source.placeholder?: string`

only accept static image ("static;${uri}") and base64String ("base64,${value}")

Image that is shown while a request is in progress. When a request completes successfully, the placeholder is replaced with the requested resource. If the requested resource is loaded from memory, the placeholder may never be shown. If the request fails , the placeholder will continue to be displayed.

---

### `source.width?: number`

The width to be used in the resize, -1 ignore resize.

fitCenter:
Scales the image uniformly (maintaining the image's aspect ratio) so that one of the dimensions of the image will be equal to the given dimension and the other will be less than the given dimension.

---

### `source.height?: number`

The height to be used in the resize, -1 ignore resize.

fitCenter:
Scales the image uniformly (maintaining the image's aspect ratio) so that one of the dimensions of the image will be equal to the given dimension and the other will be less than the given dimension.

---

### `source.cache?: Boolean`

skip the memory cache

---

### `scaleType?: number`

0 --> cover

1 --> contain

---

### `onLoadStart?: () => void`

Called when the image starts to load.

---

### `onLoadSuccess?: (event) => void`

Called on a successful image fetch. Called with the width and height of the loaded image.

e.g. `onLoadError={e => console.log(e.nativeEvent.width, e.nativeEvent.height)}`

---

### `onLoadError?: (event) => void`

Called on an image fetching error.

e.g. `onLoadError={e => console.log(e.nativeEvent.error)}`

---

### `onLoadEnd?: () => void`

Called when the image finishes loading, whether it was successful or an error.

---

## **Clear memory cache**

```javascript
  import { PhotoKit } from 'react-native-jjkit'

    PhotoKit.clearMemoryCache()

```
