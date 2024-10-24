<template>
  


    <v-expansion-panels
      v-model="panel"
      multiple
      class="exp_panels"
      flat
        focusable
        accordion


    >



    <v-expansion-panel

        class="align-self-start bord_bot "
        v-for="(x,index) in addremrow"
        :key="index"
    >
        <v-expansion-panel-header  color="exppanel" class="pl-0" >
              <template v-slot:default="{ open }" v-if="completion">
            <v-row no-gutters class="align-center">
                <v-col
                    class="flex-grow-0 pr-2"
                >
                    <v-fade-transition leave-absolute>
                       
                        <v-icon
                            v-if="open"
                            color="open_icons"
                            small
                            @click.stop="$emit('addRows', x.field)"
                        >
                            mdi-plus
                        </v-icon>
                                                <v-icon
                            v-else
                            color="open_icons"
                            small
                            @click="$emit('addRows', x.field)"
                        >
                            mdi-plus
                        </v-icon>
                    </v-fade-transition>
                </v-col>
                <v-col class="font-weight-medium">
                    
                    {{ x.text }}
                </v-col>
            </v-row>
              </template>
              <span v-else>
                <span class=" font-weight-medium">
                {{ x.text }}
                </span>
              </span>
        </v-expansion-panel-header>
        <v-expansion-panel-content :class="completion?'':'expsplo'">
             
             
            <v-row
                v-for="(val, key) in newproject.info[x.field]"
                :key="key"
                class="ma-0 flex-grow-0"
                :class="key>0?'mb-1':''"
            >
                <v-col class="pa-0">
                    <v-textarea 
                
                        v-model="newproject.info[x.field][key]"                                        
                        auto-grow
                        rows=0
                        dense
                        flat
                        :solo="!completion"
                        :readonly="!completion"
                        hide-details
                    />
                
                    <v-divider v-if="!completion && newproject.info[x.field].length>0" :class="key>=1?'my-3':'mb-3'"/>
   
                </v-col>
                
                <v-col v-if="completion" class="pa-0 flex-grow-0 align-self-end">
                    <MyIco
                        @click="$emit('remove', {field:x.field, key})"
                        icons = 'mdi-delete'
                        color="btns"
                        size="small"
                    />
                </v-col>
            </v-row>

        </v-expansion-panel-content>
      </v-expansion-panel>
    </v-expansion-panels>

</template>

<script>
import rowsAddremove from '../../carddetails/pattern/rows-addremove.vue'
 export default {
  components: { rowsAddremove },
    
    name: "expPanel",

    props: {

            completion: {
                type: Boolean,
                default: false
            },

          newproject: {
            type:Object,
            default:()=>{}

            },

          addremrow: {
            type:Array,
            default:[]
          },
        
    },

    data () {
      return {
        panel: [],
        items: 5,
      }
    },

  }
</script>

<style>

.exp_panels .v-icon.v-icon {
    font-size: 12px;
}


.bord_bot {
    border-bottom: solid 2px #e4e4e4;
}
.exp_panels .v-expansion-panel--active > .v-expansion-panel-header, .v-expansion-panel-header {
    max-height: 30px!important;
}

.exp_panels .v-expansion-panel-header {
    min-height: 30px!important;
}

.exp_panels .theme--light.v-expansion-panels.v-expansion-panels--focusable .v-expansion-panel-header--active:hover::before, .theme--light.v-expansion-panels.v-expansion-panels--focusable .v-expansion-panel-header--active::before {

    background-color:#acaeb3;
}

.expsplo .v-expansion-panel-content__wrap{
    padding-bottom: 0!important;
    padding-top: 10px;
} 

</style>