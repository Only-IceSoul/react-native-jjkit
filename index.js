import { requireNativeComponent } from 'react-native';
import { NativeModules } from 'react-native';

const { Toast } = NativeModules;

const CircleProgressView = requireNativeComponent('CircleProgressView', null);
const ClipRectView = requireNativeComponent('ClipRectView', null);
const Badge = requireNativeComponent('Badge', null);


export {
    CircleProgressView,
    ClipRectView,
    Toast,
    Badge
}

