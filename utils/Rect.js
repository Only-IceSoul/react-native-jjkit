
const centerRect = (width,height,cw,ch) => {
    if(width == cw && height == ch){
        return { left: 0, top: 0, right: cw, bottom: ch }
    }
    
    let l = cw / 2 - width/2
    let t = ch / 2 - height/2

    return { left: l, top: t, right: l + width, bottom: t + height }
}

const fitCenterRect = (width,height,cw,ch)=>{
    if (cw == width && ch == height) {
        return {left: 0, top: 0, right:width, bottom: height}
    }
    var  widthPercentage = cw /  width
    var  heightPercentage = ch /  height
    var  minPercentage = Math.min(widthPercentage, heightPercentage)

    var targetWidth = Math.round(minPercentage * width)
    var targetHeight = Math.round(minPercentage * height)

    if (width == targetWidth && height == targetHeight) {
         return {left: 0, top: 0, right:width, bottom: height}
    }
    targetWidth = (minPercentage * width) | 0
    targetHeight = (minPercentage * height) | 0
   
    var dx = (cw - targetWidth) / 2
    var dy = (ch - targetHeight) / 2

     return {left: dx, top: dy, right:dx + targetWidth, bottom: dy + targetHeight}
    
}

const offset = (rect,dx,dy)=>{
    let l = rect.left + dx
    let t = rect.top + dy
    let r = rect.right + dx
    let b = rect.bottom + dy
    return { left: l, top: t, right: r, bottom: b}
}

// pivot center
const scale = (rect,scale) => {
    if (scale != 1){
        let w = width(rect)
        let h = height(rect)
        let nw =  w * scale
        let nh = h * scale
        let dx = (w - nw) / 2
        let dy = (h - nh) / 2
        let l = rect.left + dx
        let t = rect.top + dy
        let r = rect.right - dx
        let b = rect.bottom - dy
        return { left: l, top: t, right: r, bottom: b}
    }
}

// const rotate = (rect,degress) => {

// }

const inset = (rect,dx,dy)=>{
    let l = rect.left + dx
    let t = rect.top + dy
    let r = rect.right - dx
    let b = rect.bottom - dy
    return { left: l, top: t, right: r, bottom: b}
}

const insetBr = (rect,distance) => {
    let l = rect.left 
    let t = rect.top 
    let r = rect.right - distance
    let b = rect.bottom - distance 
    return { left: l, top: t, right: r, bottom: b}
}
const insetBl = (rect,distance) => {
    let l = rect.left + distance
    let t = rect.top 
    let r = rect.right 
    let b = rect.bottom - distance
    return { left: l, top: t, right: r, bottom: b}
}

const insetTl = (rect,distance) => {
    let l = rect.left + distance
    let t = rect.top + distance
    let r = rect.right 
    let b = rect.bottom 
    return { left: l, top: t, right: r, bottom: b}
}
const insetTr = (rect,distance) => {
    let l = rect.left 
    let t = rect.top + distance
    let r = rect.right - distance
    let b = rect.bottom 
    return { left: l, top: t, right: r, bottom: b}
}
const insetBlr = (rect,distance) => {
    let l = rect.left + distance
    let t = rect.top 
    let r = rect.right - distance
    let b = rect.bottom - distance
    return { left: l, top: t, right: r, bottom: b}
}
const insetTlr = (rect,distance) => {
    let l = rect.left + distance
    let t = rect.top + distance
    let r = rect.right - distance
    let b = rect.bottom 
    return { left: l, top: t, right: r, bottom: b}
}

const insetLtb = (rect,distance) => {
    let l = rect.left + distance
    let t = rect.top + distance
    let r = rect.right
    let b = rect.bottom - distance
    return { left: l, top: t, right: r, bottom: b}

}

const insetRtb = (rect,distance) => {
    let l = rect.left
    let t = rect.top + distance
    let r = rect.right - distance
    let b = rect.bottom - distance
    return { left: l, top: t, right: r, bottom: b}
 
}


const contains = (rect,rect2) => {
    return rect.left < rect.right && rect.top < rect.bottom
            && rect.left <= rect2.left &&  rect.top <= rect2.top
            && rect.right >= rect2.right && rect.bottom >= rect2.bottom
}

const width = (rect) => {
  return rect.right - rect.left
}
const height = (rect) => {
    return rect.bottom - rect.top
}
export default {
    fitCenterRect,
    centerRect,
    contains,
    insetBl,
    insetBlr,
    insetBr,
    insetLtb,
    insetRtb,
    insetTl,
    insetTlr,
    insetTr,
    inset,
    offset,
    width,
    height,
    scale
}