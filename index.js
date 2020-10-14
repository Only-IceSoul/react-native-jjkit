import { requireNativeComponent } from 'react-native';
import { NativeModules } from 'react-native';
import Rect from './utils/Rect.js'
import ImageListView from './ImageListView'

const { Toast , PhotoKit, Cropper} = NativeModules;

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
    Rect,
    ImageListView
}

