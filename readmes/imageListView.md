# ImageListView

Image list using [Glide](https://github.com/bumptech/glide) and [Guiso](https://github.com/Only-IceSoul/Guiso) with native list


## **Usage**

```javascript
  import { ImageListView } from 'react-native-jjkit'
  
  <ImageListView {...props}  />

```



## Properties

### `source?: object`

Data source

---
### `source.data?: Array:Object`

require uri   e.g. `'https://facebook.github.io/react/img/logo_og.png'`.  
require mediaType[image,video,gif](Default: image) : string

---

### `source.options?: Object`

       
| Name | description | type | default |
| --- | --- | --- | --- |
| spanCount | Sets the number of spans to be laid out.| number | 3 |
| orientation | Sets the orientation of the layout. v:1 h:0 | number | 1 |
| selectable | Elements are selectable | boolean | false |
| selectableColor | Set a color , hex6 hex8 | string | "#262626" |
| threshold | Selection limit | number | 2 |
| progressVisible | if you want to render a progressView as footer. Helpful in showing a loader while doing incremental loads | boolean | false |
| progressSize | Sets the size | number | 60 |
| progressColor |  Set a color for the stroke  | string | "#262626" |
| videoIconVisible | show the video icon  | boolean | true |
| durationIconVisible | show the video duration (Requires field duration) | boolean | true |
| allowGif | if the image you load is an animated GIF, Image will display a animated gif  | boolean | false |
---

### `source.resize?: Object`  
    

| Name | description | type | default |
| --- | --- | --- | --- |
| width | The width to be used in the resize, -1 ignore  | number | 300 |
| height | The height to be used in the resize, -1 ignore  | number | 300 |
| mode | Determines how to resize the image [contain(0),cover(1)] | number | 1 |


---

### `source.cell?: Object`


| Name | description | type | default |
| --- | --- | --- | --- |
| size | Sets the size| number | android(window.width / 3) - ios(view.size / 3) |
| backgroundColor |  hex 6, hex8 | string | "#cccccc" |
| scaleType | Controls how the image should be displayed [contain(0),cover(1)] | boolean | false |
| margin | Sets the margin | object | { left: 0,top: 0,right:0,bottom: 0} |

---


### `onEndReached?: () => void`

Callback function executed when the end of the view is hit 

---

### `onItemClicked?: (event) => void`

Callback function executed when the view is clicked 

e.g. `onItemClicked={e => console.log(e.nativeEvent.item)}`

---    



## Methods

### `addItems: (items:Array<Object>) => void`

adds an items to the end of the List


---    

### `getSelectedItems: () => Promise`

e.g  ImageListViewRef.getSelectedItems().then(r => {
    console.log(r)
})


---    