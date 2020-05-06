
const centerRect = (width,height,cw,ch) => {
    if(width == cw && height == ch){
        return { left: 0, top: 0, right:left + cw, bottom: top + ch }
    }
    
    let l = cw / 2 - width/2
    let t = ch / 2 - height/2

    return { left: l, top: t, right: l + width, bottom: t + height }
}

const fitCenterRect = (width,height,cw,ch)=>{
    if (width > height) {
        let h = height / width  * cw
        let dy = ch / 2 - h/2
        return {left: 0, top: dy, right: cw, bottom: dy + h}
    }else{
        let w = width / height  * ch
        let dx = cw / 2 - w/2
        return {left: dx, top: 0, right:dx + w, bottom: ch}
    }
}

const offset = (rect,dx,dy)=>{
    rect.left += dx
    rect.top += dy
    rect.right += dx
    rect.bottom += dy
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
        rect.left += dx
        rect.top += dy
        rect.right -= dx
        rect.bottom -= dy
    }
}

// const rotate = (rect,degress) => {

// }

const inset = (rect,dx,dy)=>{
    rect.left += dx
    rect.top += dy
    rect.right -= dx
    rect.bottom -= dy
}

const insetBr = (rect,distance) => {
    rect.right -= distance
    rect.bottom -= distance
}
const insetBl = (rect,distance) => {
    rect.left += distance
    rect.bottom -= distance
}

const insetTl = (rect,distance) => {
    rect.left += distance
    rect.top += distance
}
const insetTr = (rect,distance) => {
    rect.right -= distance
    rect.top += distance
}
const insetBlr = (rect,distance) => {
    rect.left += distance
    rect.bottom -= distance
    rect.right -= distance
}
const insetTlr = (rect,distance) => {
    rect.left += distance
    rect.top += distance
    rect.right -= distance
}

const insetLtb = (rect,distance) => {
    rect.left += distance
    rect.top += distance
    rect.bottom -= distance
}

const insetRtb = (rect,distance) => {
    rect.right -= distance
    rect.top += distance
    rect.bottom -= distance
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