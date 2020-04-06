package com.reactjjkit.layoutUtils

class JJPadding(var left: Int = 0, var top: Int = 0, var right: Int = 0, var bottom: Int = 0) {

    companion object {

        fun top(top: Int): JJPadding {
            return JJPadding(0,top,0,0)
        }

        fun left(left: Int): JJPadding {
            return JJPadding(left,0,0,0)
        }

        fun right(right: Int): JJPadding {
            return JJPadding(0,0,right,0)
        }

        fun bottom(bottom: Int): JJPadding {
            return JJPadding(0,0,0,bottom)
        }

        fun horizontal(padding: Int) : JJPadding {
            return JJPadding(padding,0,padding,0)
        }

        fun vertical(padding: Int) : JJPadding {
            return JJPadding(0,padding,0,padding)
        }

        fun all(padding: Int) : JJPadding {
            return JJPadding(padding,padding,padding,padding)
        }
    }

    fun sum(left:Int,top:Int,right: Int,bottom: Int) : JJPadding {
        this.left += left
        this.top += top
        this.right += right
        this.bottom += bottom
        return this
    }

    fun sum(value: Int) : JJPadding {
        left += value
        top += value
        right += value
        bottom += value
        return this
    }

    fun sumHorizontal(value: Int) : JJPadding {
        left += value
        right += value
        return this
    }

    fun sumVertical(value: Int) : JJPadding {
        top += value
        bottom += value
        return this
    }


    fun copyWithSum(sum:Int) : JJPadding {
        return JJPadding(left + sum,top+sum,right+sum,bottom+sum)
    }

    fun copyWithSumVertical(sum:Int) : JJPadding {
        return JJPadding(left,top+sum,right,bottom+sum)
    }

    fun copyWithSumHorizontal(sum:Int) : JJPadding {
        return JJPadding(left + sum,top,right+sum,bottom)
    }

    fun copyWithSum(left:Int,top:Int,right: Int,bottom: Int) : JJPadding {
        return JJPadding(this.left + left,this.top+top,this.right+right,this.bottom+bottom)
    }

    override fun toString(): String {
        return "Left: $left  Top: $top  Right: $right Bottom $bottom"
    }
}