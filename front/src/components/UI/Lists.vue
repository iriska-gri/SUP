<template>
  <v-list-item
    :link="link"
    :to="links || ''"
    @click="$emit('messengerviews')"
  >
    <v-list-item-icon>

   

      <v-icon
      slot="appendIcon"
          :small="mini?f:true"
          :class="mini?pl:'pl-5'"
          color="btns_menus"
      >
   
        {{ icon }}
      </v-icon>
    </v-list-item-icon>
    <v-list-item-title
      class="peace text-caption font-weight-medium"
    >
      {{ title }}

      {{messengertotal>0?'('+messengertotal+')':''}}
    </v-list-item-title>
  </v-list-item>    
</template>

<script>
export default {
   
    name:'lists',

    props: {

      messengertotal: {
          type: Number,
          default:0
      },
    
      icon:{
          type: String,
          default:""
      },
      title:{
          type: String,
          default:""
      },

      links:{
          type: String,
          default:""
      },
      
      mini: {
        type:Boolean,
        default:false
      },

      link: {
        type:Boolean,
        default:true
      },
      f: {
        type:Boolean,
        default:false
      },
      pl: {
        type: String,
        default:"pl-2"
      }
    },

}
</script>

<style>

</style>