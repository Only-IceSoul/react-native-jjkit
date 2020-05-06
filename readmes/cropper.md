# Cropper

Image cropping  for React Native.


## Freatures

- [x] scale
- [x] scroll
- [ ] rotation




## Objects

**Crop data**

| key | description | type |
| --- | --- | --- |
| image | Base64 String or Static image uri | String | 
| rect | Image rect , relative to container | Rect | 
| cw |  Container width | Number | 
| ch | Container height | Number | 
| crop | rect for crop, relative to container | Rect | 
| width | The width for resize in pixels (fit center)  | Number |
| height | The height for resize in pixels (fit center) | Number |
| quality | The quality 0 to 1, png will ignore the quality | Number |
| format |The format of the compressed image Cropper.jpeg(0) or Cropper.png(1)  | Number |

If you don't want to resize the image cropped , set width -1 and height -1

**Rect** 


| key | type |
| --- | --- |
| left | Number | 
| top |  Number | 
| right |  Number | 
| bottom |  Number | 



## Usage

Everything is with logical numbers, like when you define width and height in a view

```javascript
import { Cropper , Rect } from 'react-native-jjkit'

//define ur container size
let cw = 814 //width
let ch = 414 //height
// image size in pixels
let imageWidth = 1200
let imageHeight = 460
//create a rect for image centered in the container
let imageRect = Rect.fitCenterRect(imageWidth,imageHeight,cw,ch)
// create a rect for crop centered in the container
let crop = Rect.centerRect(100,100,cw,ch)
//validate rect
//return true if first rect contains second rect
 if (Rect.contains(imageRect,crop)){

        let dataForCrop = {
            image : myImage, //static uri or base64 string
            rect: imageRect,
            cw: cw,
            ch: ch,
            crop: crop,
            quality: 1,
            format: Cropper.jpeg,
            width: -1, //without resize
            height: -1  //without resize
        }

        //if base64 string
        Cropper.makeCrop64(dataForCrop).then(image64String => {
            console.log("result ",image64String)
           
        })
        // if static
        Cropper.makeCropStatic(dataForCrop).then(image64String => {
            console.log("result ",image64String)
           
        })
}


```

## Transform Rect

When you transform view, you have to update also in the rect.

cropView -> cropRect  
imageView -> imageRect

You can use ur own functions for transform the rect(scale and scroll).

```javascript

import { Rect } from 'react-native-jjkit'

// create rect for crop centered in the container
let crop = Rect.centerRect(100,100,cw,ch)

//logical points
let scX = getDistanceSrollGestureX()
let scY = getDistanceSrollGestureY()

//moving rect
crop = Rect.offset(crop,scX,scY)

//resize rect
crop = Rect.inset(crop,scX,scY)
//Top left
let h = sqr(scX * scX , scY * scY)
crop = Rect.insetTl(crop,h)
//Top right ....


//scale - pivot is center.
let scale = 2
 imageRect = Rect.scale(imageRect,scale)

//scrolling Image scaled
imageRect = Rect.offset(imageRect,scX,scY)


```

# Example

[demo](https://github.com/Only-IceSoul/canal/tree/master/demos/RNCropper)
