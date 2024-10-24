<template>
    <v-btn 
       
        @click ="$emit('click')"
        :color='colora'
        class="inyand--text"
        :block='block'
        :outlined='outlined'
        :disabled='disabled'
        :height="icon?heighti:height"
        :width="icon?widthi:width"
        :icon='icon'
        :text="text"
    >
    <slot name="icons"></slot>
    <span  v-if="!getLoad()"
        :class='textbtn'
    >
        {{title}}
   </span>
        <v-skeleton-loader v-else
            class="namebtn"
            type="table-cell"
            
        ></v-skeleton-loader>
       
    </v-btn>

     <!-- <v-skeleton-loader v-else
          
            type="button"
        
        ></v-skeleton-loader>  -->
</template>

<script>
import { createNamespacedHelpers } from "vuex";
const globalstore=createNamespacedHelpers("globalstore");
export default {
    name:"BtnsOut",

    props: {
        title: {
            type: String,
            default:''
        },
        disabled: {
            type: Boolean,
            default: false
        },
        block: {
            type: Boolean,
            default: false
        },
        outlined: {
            type: Boolean,
            default: false
        },
        text: {
            type: Boolean,
            default: false
        },
        height: {
            type: Number,
            default:36
        },
        width: {
            type: Number,
            default:120
        },
        heighti: {
            type: Number,
            default:0
        },
        widthi: {
            type: Number,
            default:0
        },
        icon: {
            type: Boolean,
            default: false
        },
        textbtn: {
            type: String,
            default: "text-sizeBTN text-capitalize"
        },

        colora: {
            type: String,
            default: "btns"
        }
    }
,
        methods:{
        ...globalstore.mapGetters(["getLoad"]),
    }



}
</script>

<style lang="scss">

.namebtn {
  .v-skeleton-loader__table-cell {
    width: 73px;
    height: 50px;
  }  
  .v-skeleton-loader__text {
    height: 20px;
  }
}

.text-sizeBTN {
    font-size: 0.75rem;
}

</style>