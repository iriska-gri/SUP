<template>
<v-row class="flex-grow-0 pt-4">
   <v-col>
<v-row>
   <v-col class="text-center" :class="editable?'passiv_text--text':''">
      МИНФИН РОССИИ
   </v-col>
</v-row>
<v-row>
   <v-col class="text-center" :class="editable?'passiv_text--text':''">
      ФЕДЕРАЛЬНАЯ НАЛОГОВАЯ СЛУЖБА <br> (ФНС России)
   </v-col>
</v-row>
<v-row>
   <v-col class="text-center" :class="editable?'passiv_text--text':''">
      {{title.toUpperCase()}}
   </v-col>
</v-row>
   </v-col>
</v-row>

</template>

<script>
export default {
 name:"Dockhead",
 props:{
    title:{
    type: String,
    default:"Приказ",
},
        editable: {
        type:Boolean,
        default:false},
    
 }
}
</script>

<style>

</style>