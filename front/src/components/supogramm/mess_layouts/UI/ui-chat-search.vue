<template>
    <v-autocomplete
        dense
        :items="mychats"
        return-object
        item-value="chatTitle(item)"
        :item-text="item=>chatTitle(item)"
        :search-input.sync="searchat"
        clearable                             
    >
  </v-autocomplete>
</template>

<script>
import { createNamespacedHelpers } from "vuex";
import func from '../func'
const { mapGetters } = createNamespacedHelpers("auth");

export default {
  name: "ui-chet-search",
  
  mixins:[func],

  props: {
    mychats: {
      type: Array,
      default: ()=>[]
    },
  },

  data() {
    return{
      searchterm:"",
      searchd:[]
    }
  },



  computed: {

    ...mapGetters(["getUser", ]),

    searchat:{
      get(){
        return this.searchterm    
      },
      set(term) {
        
        if(term!=null && term.length>0){
          this.searchd = this.mychats.filter(e=> this.chatTitle(e).match(term))

        }
        else{
          this.searchd = this.mychats
        }  
         this.$emit('searchdfunc', this.searchd)     
      },
    },
  },
}
</script>

<style>

</style>