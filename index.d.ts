import { ImageStyle, StyleProp, ViewStyle } from 'react-native'

import React, { Ref } from 'react'



type ResizeMode = "contain" | "cover"

type CompressFormat = "jpeg" | "png"

type ScaleType = "contain" | "cover"

type Orientation = "vertical" | "horizontal"

type Priority = "low" | "normal" | "high"

type DiskCacheStrategy = "automatic" | "all" | "none" | "data" | "resource"

type Gravity = "left" | "top" | "right" | "bottom"

type LineCap = "butt" | "round" | "square"

export type ImageSource = {
    uri?:string| null,
    asGif?:boolean | null,
    headers?:Object | null,
    priority?:Priority,
    placeholder?:string | null,
    width?:number | null,
    height?:number | null,
    resizeMode?: ResizeMode,
    skipMemoryCache?:boolean | null,
    diskCacheStrategy?:DiskCacheStrategy,
}


type ImageError = {
    error?:string | null
}
type ImageSuccess = {
    width?:number,
    height?:number
}
type EventImageError = {
    nativeEvent?:ImageError | null,
}

type EventImageSuccess = {
    nativeEvent?:ImageSuccess | null,
}

export interface ImageProps {
    style?: StyleProp<ImageStyle>;
    source:ImageSource | null;
    scaleType?:ScaleType;
    onLoadStart?:() => void | null;
    onLoadEnd?:() => void | null;
    onLoadError?:(event:EventImageError) => void | null;
    onLoadSuccess?:(event:EventImageSuccess) => void | null;
}



export class Image extends React.Component<ImageProps> { 

}



type PhotoKitRequestimage = {
    uri?: string | null,
    width?: number,  
    height?: number,  
    resizeMode?:ResizeMode 
    quality?: number, 
    format?: CompressFormat 
}


type MediaQuery = "all" | "gif" | "image" | "photo" | "video" | "video_photo" | "video_gif" 

type PhotoKitQuery = {
    query?:MediaQuery,
    limit?:number | null,
    offset?:number | null,
    names?:string[] | null

}

export type Media ={
    albumId: number,
    albumName: string,
    displayName:string,
    uri:string,
    mediaType:string,
    date:number,
    duration:number,
    height:number,
    width:number
}

export type Album = {
    id: number,
    name:string,
    count:number,
    uri:string,
    mediaType:string,

}

type PhotoKitResult ={
    albums: Album[],
    media: Media[]
}

export class PhotoKit { 


    static AUTHORIZED:number
    static UNDETERMINED:number
    static DENIED:number

    static fetch(query:PhotoKitQuery | null): Promise<PhotoKitResult>
    static requestRaw(uri?:string | null):Promise<string>
    static requestImage(request:PhotoKitRequestimage):Promise<string>
    static isPermissionGranted():Promise<boolean>
    static requestPermission():Promise<number>
    static clearMemoryCache():Promise<boolean>
    static fetchAlbums(query:string): Promise<Album[]>
    static requestImageByRef(ref:Image | undefined | null,format?:CompressFormat,quality?:number): Promise<string>
    static clearImage(ref: Image | undefined | null): void
}


type ImageListViewOptions = {
    spanCount?: number | null,
    orientation?: Orientation,
    selectable?:boolean | null,
    selectableColor?:string| null,
    selectableIconSize?:number| null,
    threshold?: number | null,
    videoIconVisible?:boolean | null,
    videoIconSize?:number | null,
    durationVisible?:boolean | null,
    durationTextSize?:number | null,
    progressVisible?:boolean | null,
    progressSize?: number | null,
    progressCellSize?:number | null,
    progressColor?:string| null,
    allowGif?:boolean | null
}

type ImageListViewResize = {
    width?: number | null,
    heigth?: number | null,
    mode?: ResizeMode
}


type Margin = {
    left?:number,
    right?:number,
    top?:number,
    bottom?:number
}

type ImageListViewCell = {
    size?: number | null,
    backgroundColor?: string | null,
    margin?: Margin | null,
    scaleType?: ScaleType
}

type ImageListViewSource = {
    data?: Object[] | null,
    options?:ImageListViewOptions,
    resize?:ImageListViewResize,
    cell?:ImageListViewCell 
}



type ImageListViewItem = {
    uri?: string | null,
    mediaType?: string | null
}

export type ImageListViewResultItemClicked = {
    item?:ImageListViewItem | null
}

 export type EventImageListViewItemClicked = {
    nativeEvent:ImageListViewResultItemClicked
}

export interface ImageListViewProps{
    style?: StyleProp<ViewStyle>
    source?: ImageListViewSource | null
    onEndReached?:()=>void
    onItemClicked?:(event:EventImageListViewItemClicked)=> void

}

export class ImageListView extends  React.Component<ImageListViewProps>  {


      addItems(arr:Object[]):void
      getSelectedItems():Promise<Object[]>
    

}


export interface BadgeProps {
    style?: StyleProp<ViewStyle>
    text?:String | null
    textSize?:number | null
    font?:string | null
    textColor?:string | null
    strokeColor?:string | null
    strokeWidth?:number | null
    isTextHidden?:boolean| null
    textOffsetX?:number | null
    textOffsetY?:number | null
    insetX?:number | null
    insetY?:number | null
}

export class Badge extends React.Component<BadgeProps>{

}

type Output = {
    quality?: number
    format?: number
    width?: number
    height?: number  
}

type CropperTransform = {
    image?: string | null
    rotate: number
    flipVertically: boolean
    flipHorizontally: boolean
    output?: Output
}

type Rect = {
    left:number
    top:number
    right:number
    bottom:number
}

type CropperCrop = {
    image?: string | null
    rect: Rect
    crop: Rect
    rotate: number
    flipVertically: boolean
    flipHorizontally: boolean
    output?: Output 
}

export class Cropper { 
  

    static jpeg:number
    static png:number
    

    static transform(t:CropperTransform): Promise<string>
    static makeCrop(c:CropperCrop): Promise<string>
   
}


export class Toast {

    static SHORT:number  
    static LONG:number

    static show(msg:string,lenght:number): Promise<string>
}



export interface ClipRectProps {
   gravity?:Gravity
   inset?:number
   progress?:number
}

export class ClipRectView extends React.Component<ClipRectProps> {

}

export interface CircleProgressProps {
    strokeWidth?:number
    colors?: string[] | null
    positions?: number[] | null
    backColors?: string[] | null
    backPositions?: number[] | null
    cap?: LineCap | null
    progress?:number
}

export class CircleProgressView extends React.Component<CircleProgressProps>{

}