import { requireNativeComponent } from 'react-native';
import { NativeModules } from 'react-native';
import RectUtils from './utils/RectUtils.js'
import ImageListView from './ImageListView'
import PhotoKit from './PhotoKit'

const { Toast , Cropper} = NativeModules;

const CircleProgressView = requireNativeComponent('CircleProgressView', null);
const ClipRectView = requireNativeComponent('ClipRectView', null);
const Badge = requireNativeComponent('Badge', null);
const Image = requireNativeComponent('Image', null);



export {
    CircleProgressView,
    ClipRectView,
    Toast,
    Badge,
    PhotoKit,
    Image,
    Cropper,
    RectUtils,
    ImageListView
}

