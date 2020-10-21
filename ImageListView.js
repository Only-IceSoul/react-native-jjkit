import { NativeModules,requireNativeComponent ,findNodeHandle,Platform} from 'react-native';
import React from 'react'

const ImgLView = requireNativeComponent('ImageListView', null);

const module =  NativeModules.ImageListView



class ImageListView extends React.PureComponent {

    
   refImg = null

  
   getSelectedItems(){
        return new Promise((resolve, reject) => {
                
      
             module.getSelectedItems(findNodeHandle(this.refImg)).then(re => {
                    resolve(re)
                }).catch((e)=>{
                    reject(e)
                })
            
            
        })
    }
    
    addItems(arr){
        module.addItems(findNodeHandle(this.refImg),arr)
    }

    render(){
        return (  
            <ImgLView ref={(r)=> this.refImg = r} style={this.props.style}
             source={this.props.source} onEndReached={this.props.onEndReached} onItemClicked={this.props.onItemClicked} />
        )
    }

}


export default ImageListView

