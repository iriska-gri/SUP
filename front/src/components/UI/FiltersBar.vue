<template>
    <v-container
        class="w-100 flex-col shell-filters"
        fluid
    >
     <v-card class="pa-4">
    <v-row class="flex-grow-0">
        <v-col class="flex-row pb-0 pr-5 justify-end">
            
            <v-tooltip
                v-if="helper.length"
                color="primary"
                bottom
            >
                <template
                    v-slot:activator="{ on, attrs }"
                >
                    <v-icon 
                        style="cursor:pointer"
                        v-bind="attrs"
                        v-on="on"
                     
                        
                    >
                        mdi-help
                    </v-icon>
                </template>
                    <span>{{helper}}</span>
            </v-tooltip>
            <v-icon
                color="icons"
                :class="[iconreverse? 'up': '', 'icon-down']"
                @click="reverse"
            >
                mdi-chevron-up-circle-outline
            </v-icon> 
       
        </v-col>
    </v-row>
    <v-row>
        <v-col >
           
<transition
                    name="slide"
                    @afterLeave="endAnimation"
                    @afterEnter="endAnimation"
                >
                    <v-row  class="px-4"
                        v-if="isShow"
                    >
                        <slot name="toptext"></slot>                        
                        <slot name="filterslist"></slot>
                       <v-col
                            class="pt-0 pr-1 flex-row flex-nowrap align-end justify-end col_btn_apply_reset"
                        >
        <BtnsOut
        @click="$emit('sendData')"
        title = "Применить"
        :height= 30
        :width= 120
      />
    <BtnsOut
        @click="$emit('clear')"
        title = "Сбросить"
        :height= 30
        :width= 120
      />

               
                        </v-col> 
                    </v-row>
                </transition>  
           
               
        </v-col>
    </v-row>
     </v-card>
    

    </v-container>


</template>

<script>



    export default {

 
        name: 'filters-bar',
        props:{
            helper:{
                type:String,
                default:""
            },
            header:{
                type: String,
                default: 'ФИЛЬТРЫ'
            }


        },
        data() {
            return {
                iconreverse: false,
                isShow: true,
            }
        },
        methods: {
            reverse() {
                this.iconreverse = !this.iconreverse;
                this.isShow = !this.isShow;
                
                   
            },
            endAnimation() {
                this.$emit("cbArrow");
            }
        },
        beforeDestroy() {
           
            this.$store.commit('filterslogic/filtersClear');
        }
        
    }
</script>shell-filter
<style lang="scss">



</style>
<style lang="scss" scoped>
    @import '@/utils/colors.scss';

.col_btn_apply_reset {
    gap: 15px;
}


    .shell-filters {
        z-index: 12;
        // background: white;
        font-size: .8em;
        

       .labelfilt{
             font-size: .8em;
            }
   

        h4 {
            color: var(--v-inyand-base)!important;
            // font-size: .8rem !important;
        }

        .icon-down {
            color: $bg-purple;
            transition: transform ease-in .2s;
            transform: rotate(0deg);
            font-size: 1rem !important;
        }

        .icon-down.up {
            transform: rotate(180deg);
        }

       .btn-filter {
            background-color: $bg-purple;
            color: white;
        }
        
    }

    .slide-enter-active {
        -moz-transition-duration: 0.3s;
        -webkit-transition-duration: 0.3s;
        -o-transition-duration: 0.3s;
        transition-duration: 0.3s;
        -moz-transition-timing-function: ease-in;
        -webkit-transition-timing-function: ease-in;
        -o-transition-timing-function: ease-in;
        transition-timing-function: ease-in;
    }

    .slide-leave-active {
        -moz-transition-duration: 0.3s;
        -webkit-transition-duration: 0.3s;
        -o-transition-duration: 0.3s;
        transition-duration: 0.3s;
        -moz-transition-timing-function: cubic-bezier(0, 1, 0.5, 1);
        -webkit-transition-timing-function: cubic-bezier(0, 1, 0.5, 1);
        -o-transition-timing-function: cubic-bezier(0, 1, 0.5, 1);
        transition-timing-function: cubic-bezier(0, 1, 0.5, 1);
    }

    .slide-enter-to, .slide-leave {
        max-height: 500px;
        overflow: hidden;
    }

    .slide-enter, .slide-leave-to {
        overflow: hidden;
        max-height: 0;
    }
    
 
</style>