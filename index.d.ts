import { ImageStyle, StyleProp, ViewStyle } from 'react-native'

import React from 'react'



    type ResizeMode = "contain" | "cover"

    type CompressFormat = "jpeg" | "png"

    type ScaleType = "contain" | "cover"

    type Orientation = "vertical" | "horizontal"

    type Priority = "low" | "normal" | "high"

    type DiskCacheStrategy = "automatic" | "all" | "none" | "data" | "resource"

    
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
    type ImageEventError = {
        nativeEvent?:ImageError | null,
    }

    type ImageEventSuccess = {

    }

    export interface ImageProps {
        style?: StyleProp<ImageStyle>;
        source:ImageSource | null;
        scaleType?:ScaleType;
        onLoadStart?:() => void | null;
        onLoadEnd?:() => void | null;
        onLoadError?:(event:ImageEventError) => void | null;
        onLoadSuccess?:(event:ImageEventSuccess) => void | null;
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

    export type PhotoKitQuery = {
        query?:MediaQuery,
        limit?:number | null,
        offset?:number | null,
        names?:string[] | null
    
    }

    export class PhotoKit { 

        static gif: string
        static image: string
        static photo: string
        static video: string
        static video_photo: string
        static video_gif: string
        static all: string

        static AUTHORIZED:number
        static UNDETERMINED:number
        static DENIED:number

        static fetch(query:PhotoKitQuery | null): Promise<any>
        static requestRaw(uri?:string | null):Promise<string>
        static requestImage(request:PhotoKitRequestimage):Promise<string>
        static isPermissionGranted():Promise<boolean>
        static requestPermission():Promise<number>
        static clearMemoryCache():Promise<boolean>

        static fetchAlbums(query:string): Promise<any>
    }


    type ImageListViewOptions = {
        spanCount?: number | null,
        orientation?: Orientation,
        selectable?:boolean | null,
        threshold?: number | null,
        selectableColor?:string| null,
        videoIconVisible?:boolean | null,
        durationIconVisible?:boolean | null,
        progressVisible?:boolean | null,
        progressSize?: number | null,
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

    type ImageListViewResultItemClicked = {
        item?:ImageListViewItem | null
    }

    type ImageListViewEventItemClicked = {
        nativeEvent:ImageListViewResultItemClicked
    }
 
    export interface ImageListViewProps{
        style?: StyleProp<ViewStyle>
        source?: ImageListViewSource | null
        onEndReached?:()=>void
        onItemClicked?:(event:ImageListViewEventItemClicked)=> void

    }

    export class ImageListView extends  React.Component<ImageListViewProps>  {


          addItems(arr:Object[]):void
          getSelectedItems():Promise<Object[]>
        
  
    }


    export interface BadgeProps {
        style?: StyleProp<ViewStyle>
        text?:String | null
        textSize?:number | null
        font?:string | null,
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
