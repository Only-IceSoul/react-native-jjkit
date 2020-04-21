import { requireNativeComponent } from 'react-native';
import { NativeModules } from 'react-native';

const { Toast , PhotoKit} = NativeModules;

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
    Image
}

