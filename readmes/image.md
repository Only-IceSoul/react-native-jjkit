# Image

An ImageView for url.

Image is a wrapper around [Guiso](https://github.com/Only-IceSoul/Guiso) (iOS) and [Glide](https://github.com/bumptech/glide) (Android).

## **Freatures**

- [x] Memory cache
- [x] Disk cache
- [x] Resize
- [x] uri
- [x] Base64 String 
- [x] static Image 
- [x] Gif

## **Usage**

```javascript
  import { Image } from 'react-native-jjkit'
  
  const source = {
      uri: 'https://unsplash.it/200/200?image=1',
      width: 400, 
      height: 400, 
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
uri --> ("value")

---

### `source.asGif?: boolean`

 if the image you load is an animated GIF, Image will display a animated gif.
 Default Value -> false

---

### `source.headers?: Object key:string `

Headers to load the image with. e.g. { Authorization: 'someAuthToken' }.

---

### `source.priority?: string`

low
normal -> Default
high

Priorities for completing loads. If more than one load is queued at a time, the load with the higher priority will end first. Priorities are considered best effort, there are no guarantees about the order in which loads will start or finish.

---

### `source.placeholder?: string`

only accept static image ("static;${uri}") and base64String ("base64,${value}")

 Default value -> null

Image that is shown while a request is in progress. When a request completes successfully, the placeholder is replaced with the requested resource. If the requested resource is loaded from memory, the placeholder may never be shown. If the request fails , the placeholder will continue to be displayed.

---

### `source.width?: number`

The width to be used in the resize, -1 ignore resize.  
 Default value -> -1 

---

### `source.height?: number`

The height to be used in the resize, -1 ignore resize.  
 Default value -> -1 

---

### `source.resizeMode?: string`

Determines how to resize the image:

cover: Scale the image uniformly (maintain the image's aspect ratio) so that both dimensions (width and height) of the image will be equal to or larger than the corresponding dimension of the view (minus padding).

contain(Default): Scale the image uniformly (maintain the image's aspect ratio) so that both dimensions (width and height) of the image will be equal to or less than the corresponding dimension of the view (minus padding).

---

### `source.skipMemoryCache?: boolean`

 Default value -> false

 Allows the loaded resource to skip the memory cache.  
 Note - this is not a guarantee. If a request is already pending for this resource and that request is not also skipping the memory cache, the resource will be cached in memory.

---

### `source.diskCacheStrategy?: string`

 Default value -> "automatic"

automatic 
none
all
data
resource

---

### `scaleType?: string`

 Controls how the image should be displayed.

 Default value -> "contain"

cover   
contain   

---

### `onLoadStart?: () => void`

Called when the image starts to load.

---

### `onLoadSuccess?: (event) => void`

Called on a successful image fetch. Called with the width and height of the loaded image.

e.g. `onLoadSuccess={e => console.log(e.nativeEvent.width, e.nativeEvent.height)}`

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
