<template>
<div>
  <div  style="position: relative" 
      @click.stop="tooglevis">
     <slot />
  </div>
    <v-card v-show="visible"
      @mouseleave="visible?tooglevis():''" 
      @click.stop=""         
      :class="visible?'anim-show':'anim-hide'"
                
               >
                    <div v-for="it, id in content"
                    
                    style="whitespace: nowrap"
                    v-bind:key="id"
                    >{{it}}</div>                    
                </v-card>
               
</div>
</template>

<script>
import * as moment from "moment";

export default {
  name: "custom-tooltip",
  props: {
      content: [],
      
  },
  data(){
      return{
        visible:false
      }
  } ,
 
  methods: {
      tooglevis(){
            this.visible= !this.visible
        }  

  },
   mounted() {
      moment.locale('ru')
      
     
   
  }, 
     
  
}

</script>


<style lang="scss" scoped>
@import '@/utils/colors.scss';

    .tooltipp{
        
         max-height: 50vh  !important;
         overflow-y:scroll !important;
         position: absolute !important;
         top:35px;
        //  width: 200px !important;
         
         background-color: #28282bab;
         color: aliceblue;
         
    }
    .anim-show{
    // display: none;
    top:35px;
    min-width: 100px;
    z-index: 9999999999999 !important;
    max-height: 50vh  !important;
    overflow-y:scroll !important;
    position: absolute !important;
    background-color: #28282bab;
    color: aliceblue;  
    opacity:0; /*Элемент полностью прозрачный (невидимый)*/
    transition: .5s; /*Скорость перехода состояния элемента*/
    animation: show .5s 1; /* Указываем название анимации, её время и количество повторов*/
    animation-fill-mode: forwards; /* Чтобы элемент оставался в конечном состоянии анимации */
    // animation-delay: 1s; /* Задержка перед началом */
    }
 

@keyframes show{
0%{
opacity:0;
}
100% {
opacity:1;
display: block;
}
}

</style>