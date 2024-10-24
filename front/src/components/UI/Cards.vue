<template>
  <v-card
    :color="color"
    class="flex-col flex-grow-1"
    :min-height="min_height"
 
    :elevation="elevation"
  >
      <div class="flex-col  flex-grow-1" 
      :class="ma"
      >
        <slot name="cards"></slot>
      </div>
  </v-card>
</template>

<script>
export default {
    
    name:"Cards",
     props: {
      
      color:{
        type:String,
        default:'main_theme'
      },
      min_height: {
        type:Number,
        default:0
      },

      ma: {
        type:String,
        default:'ma-3'
      },
      elevation: {
        type:Number,
        default:1
      }
      }
    
}

</script>

<style lang="scss">
@import "@/utils/colors.scss";

</style>