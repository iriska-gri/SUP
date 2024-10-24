<template>
<v-card-text class="text_card--text d-flex flex-col px-2" :class='hf'>

    <v-row 
        :class='hf'
    
    >

        <v-col v-if="!getLoad()"
            class=

            "
                pa-md-0
                pa-0
                order-lg-0
                order-0
            "
            :class="position?'align-self-center':'align-self-end'"
            xl=6
            lg=12
            md=2
            sm=6
            cols=12
        >
            {{fieldname}}
        </v-col>
        <v-col v-else
         class=
            "
                pa-0
                order-lg-0
                order-0
            "
            :class="position?'align-self-center':'align-self-end'"
            xl=6
            lg=12
            md=2
            sm=6
            cols=12
        >
            <v-skeleton-loader
            class="pb-1"
            type="table-cell"
        ></v-skeleton-loader> 
        </v-col>
        <v-col v-if="!getLoad()"
            :class="end?'hi':''"
            class="
            d-flex
                flex-col
                pa-0
                order-lg-1
                order-2
                
            "
            
            xl=12
            lg=12
            :md="mod>0?8:10"
            sm=12
            cols=12
            
        >
            <slot name="field"></slot>
            
        </v-col>
        <v-col
            v-else
            :class="end?'hi':''"
            class="
            d-flex
                flex-col
                pa-0
                order-lg-1
                order-2
                
            "
            
            xl=12
            lg=12
            :md="mod>0?8:10"
            sm=12
            cols=12
            
        >
        <v-skeleton-loader
            v-if="fieldname!='Срок'"
            :height='end?120:22'
            type="image"
        ></v-skeleton-loader> 
        <div class="flex-row justify-space-between" v-else>
                             <v-skeleton-loader
             
            height='22'
            width="107"
           
            type="image"
        ></v-skeleton-loader> 
             <v-skeleton-loader
            
            height='23'
            width="107"
         
            type="image"
        ></v-skeleton-loader> 
        </div>
            
        </v-col>
      <!-- v-if='mod && !getLoad() || !mod' -->
        <v-col
            v-if='mod>0'
            class="
                text-xl-end
                text-lg-start
                text-md-center
                text-sm-right
                text-start
                align-self-md-center
                align-self-end
                order-lg-0
                order-md-3
                order-sm-0
                order-1
                pr-0
                pl-0
                py-0
                "
            xl=6
            lg=12
            md=2
            sm=6
            cols=12
            
       
        >
       
        <slot name="buttons"></slot>

        </v-col>
        <!-- <v-col
        
            v-else
            class="
                text-xl-end
                text-lg-start
                text-md-center
                text-sm-right
                text-start
                align-self-md-center
                align-self-end
                order-lg-0
                order-md-3
                order-sm-0
                order-1
                pr-0
                pl-0
                py-0
                "
            xl=6
            lg=12
            md=2
            sm=6
            cols=12
            
       
        >
       
                    <v-skeleton-loader
                class="text-r "
                
            type="table-cell"
        ></v-skeleton-loader> 

        </v-col> -->
    </v-row>
    </v-card-text>

</template>

<script>
import { createNamespacedHelpers } from "vuex";
const globalstore=createNamespacedHelpers("globalstore");
export default {

    name:"Col-Text",



    props:{
        fieldname:{
            type: String,
            default:"0"
        },

        mod:{
            type:Number,
            default:0
        },
        position: {
            type: Boolean,
            default: false
        },
        hf:{
            type: String,
            default:"flex-grow-0"
        },
        end: {
            type: Boolean,
            default: false
        }
    },
    methods:{
        ...globalstore.mapGetters(["getLoad"]),
    }
}
  
</script>

<style>

@media (min-width: 1904px) {
   .hi {
height: 85%;
}
}

.v-skeleton-loader__table-cell {
    height: 22px!important;
}
@media (min-width: 599px) {
.text-r {
        text-align: -webkit-right;
}
}

@media (min-width: 1264px) and (max-width: 1904px) {
    .text-r {
        text-align: start;
        
}
}

</style>