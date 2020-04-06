package com.reactjjkit.layoutUtils

 class JJMargin(var left: Int = 0, var top: Int = 0, var right: Int = 0, var bottom: Int = 0) {

     companion object {

        fun top(top: Int): JJMargin {
            return JJMargin(0,top,0,0)
        }

        fun left(left: Int): JJMargin {
          return JJMargin(left,0,0,0)
        }

        fun right(right: Int): JJMargin {
            return JJMargin(0,0,right,0)
        }

        fun bottom(bottom: Int): JJMargin {
            return JJMargin(0,0,0,bottom)

        }
        fun horizontal(margin : Int): JJMargin {
            return JJMargin(margin,0,margin,0)
        }

        fun vertical(margin : Int): JJMargin {
            return JJMargin(0,margin,0,margin)
        }

        fun all(margin: Int) : JJMargin {
            return JJMargin(margin,margin,margin,margin)
        }
    }

     fun sum(left:Int,top:Int,right: Int,bottom: Int) : JJMargin {
         this.left += left
         this.top += top
         this.right += right
         this.bottom += bottom
         return this
     }

     fun sum(value: Int) : JJMargin {
         left += value
         top += value
         right += value
         bottom += value
         return this
     }

     fun sumHorizontal(value: Int) : JJMargin {
         left += value
         right += value
         return this
     }

     fun sumVertical(value: Int) : JJMargin {
         top += value
         bottom += value
         return this
     }


     fun copyWithSum(sum:Int) : JJMargin {
         return JJMargin(left + sum,top+sum,right+sum,bottom+sum)
     }

     fun copyWithSumVertical(sum:Int) : JJMargin {
         return JJMargin(left,top+sum,right,bottom+sum)
     }

     fun copyWithSumHorizontal(sum:Int) : JJMargin {
         return JJMargin(left + sum,top,right+sum,bottom)
     }

     fun copyWithSum(left:Int,top:Int,right: Int,bottom: Int) : JJMargin {
         return JJMargin(this.left + left,this.top+top,this.right+right,this.bottom+bottom)
     }

     override fun toString(): String {
         return "Left: $left  Top: $top  Right: $right Bottom $bottom"
     }

}