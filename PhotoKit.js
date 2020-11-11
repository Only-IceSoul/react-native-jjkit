import { findNodeHandle, NativeModules } from 'react-native';

const PhotoKit = NativeModules.PhotoKit
const Image = NativeModules.Image

export default PK = {
     AUTHORIZED: 1,
     UNDETERMINED:0,
     DENIED:2,
      fetch : (query) => {
        return new Promise((resolve, reject) => {
            PhotoKit.fetch(query).then(r=>{
                resolve(r)
            }).catch(e => {
                reject(e)
            })
           
       })
      }, 
      requestRaw : (uri) => {
        return new Promise((resolve, reject) => {
            PhotoKit.requestRaw(uri).then(r=>{
                resolve(r)
            }).catch(e => {
                reject(e)
            })
           
       })
      },
      requestImage:(request) => {
        return new Promise((resolve, reject) => {
            PhotoKit.requestImage(request).then(r=>{
                resolve(r)
            }).catch(e => {
                reject(e)
            })
           
       })
      },
      isPermissionGranted :() => {
        return new Promise((resolve, reject) => {
            PhotoKit.isPermissionGranted().then(r=>{
                resolve(r)
            }).catch(e => {
                reject(e)
            })
           
       })
      },
      requestPermission:()=>{
        return new Promise((resolve, reject) => {
            PhotoKit.requestPermission().then(r=>{
                resolve(r)
            }).catch(e => {
                reject(e)
            })
           
       })
      },
      clearMemoryCache:() => {
        return new Promise((resolve, reject) => {
            PhotoKit.clearMemoryCache().then(r=>{
                resolve(r)
            }).catch(e => {
                reject(e)
            })
           
       })
      },
      fetchAlbums:(query)=> {
        return new Promise((resolve, reject) => {
            PhotoKit.fetchAlbums(query).then(r=>{
                resolve(r)
            }).catch(e => {
                reject(e)
            })
           
       })
      },
      requestImageByRef: (ref,format,quality) =>{
        return new Promise((resolve, reject) => {
            let f = format ? format : 'jpeg'
            let q = quality ? quality : 1
            Image.requestImageByTag(findNodeHandle(ref),f,q).then(r=>{
                resolve(r)
            }).catch(e => {
                reject(e)
            })
           
       })
      } ,
      clearImage: (ref)=>{
          if(ref){
            Image.clear(findNodeHandle(ref))
          }
      } 
}