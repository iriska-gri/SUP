<template>
    <v-tooltip bottom v-if="tooltip">
        <template v-slot:activator="{ on, attrs }">
            <div
                v-bind="attrs"
                v-on="on"
            >   
                <v-icon v-if="!getLoad()"
                    @click="$emit('click')"
                    :size='size'
                    :dense='dense'
                    :color='color'
                    :disabled="disabled"
                    :class="cursor?'':'noncursor'"
                >
            
                    {{icons}}                         
                </v-icon>
                <v-skeleton-loader v-else
                    class="mr-1"
                    type="button"
                    height="20"
                    width="20"    
                />
            </div>
        </template>
           {{text_tool}}
    </v-tooltip>
    <div v-else>
        <v-icon
            v-if="!getLoad()"
            @click="$emit('click')"
            :size='size'
            :dense='dense'
            :color='color'
            :disabled="disabled"
        >
            {{icons}}                         
        </v-icon>
        <v-skeleton-loader v-else
            class="mr-1"
            type="button"
            height="20"
            width="20"   
        />
    </div>
</template>

<script>
import { createNamespacedHelpers } from "vuex";
const globalstore=createNamespacedHelpers("globalstore");
export default {
    
    name:"MyIco",

    props: {

        size: {
            type: String,
            default:''
        },

        text_tool: {
            type: String,
            default:'Не исользуется'
        },
        tooltip : {
            type: Boolean,
            default: false
        },

        cursor: {
            type: Boolean,
            default: true
        },

        icons: {
            type: String,
            default:'mdi-connection'
        },

        color: {
            type: String,
            default:'btns'
        },




        dense: {
            type: Boolean,
            default: false
        },
        

        disabled:{
            type:Boolean,
            default:false
        }
    },
        methods:{
        ...globalstore.mapGetters(["getLoad"]),
    }
}
</script>

<style lang="scss">
.v-icon.v-icon::after {
    border-radius: 0!important;
    height: 85%!important;
    left: 10%!important;
    top: 10%!important;
    width: 80%!important;
}

  .noncursor  {
    cursor: auto!important;
  }
</style>