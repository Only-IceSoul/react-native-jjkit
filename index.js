import { requireNativeComponent } from 'react-native';
import { NativeModules } from 'react-native';

const { Toast } = NativeModules;

const CircleProgressView = requireNativeComponent('CircleProgressView', null);
const ClipRectView = requireNativeComponent('ClipRectView', null);


export {
    CircleProgressView,
    ClipRectView,
    Toast
}

