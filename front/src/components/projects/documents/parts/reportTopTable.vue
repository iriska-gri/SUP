<template>

 <v-card>
    <v-card-title>
     <slot></slot>
      <v-spacer></v-spacer>
      <v-text-field
        v-model="search"
        append-icon="mdi-magnify"
        label="Поиск"
        single-line
        hide-details
      ></v-text-field>
    </v-card-title>
         
                     <v-data-table
                     hide-default-footer
                    :headers="headers"
                    :items="toptable"
                    :item-class="fontweight"
                    dense
                    :search="search"
                    class="elevation-2"
                    >
                    <template v-slot:[`item.dateend`]="props">
                       <span>
                        {{momentext(props.item.dateend,'DD.MM.YYYY')}}</span>
                    </template>
                    <template v-slot:[`item.planning`]="props">
                    <v-menu 
                                            v-model="props.item.picker"
                                            :close-on-content-click="false"
                                            transition="scale-transition"
                                            offset-y
                                            min-width="auto"
                                            >
                                                <template
                                                    v-slot:activator="{on, attrs}"
                                                    
                                                >
                                                    <v-text-field
                                                        :readonly="!editable"
                                                        dense
                                                        :value="formatDate(props.item.planning)"            
                                                        type="date-local"              
                                                        placeholder="дд.мм.гггг"
                                                            flat
                                                            solo
                                                        @input="event=>props.item.planning=oninputnostore(event)"
                                                        v-bind="attrs"
                                                        hide-details
                                                        v-on="on"
                                                        class="ma-0 align-self-center"
                                                    >
                                                    </v-text-field>
                                                    
                                                </template>
                                                <v-date-picker
                                                 v-if="editable"
                                                    :first-day-of-week="1"
                                                    @change="$emit('changepicker',props.item)"                                       
                                                    v-model="props.item.planning"
                                                    :min="momentext(new Date(),'YYYY-MM-DD')"
                                                >
            </v-date-picker>
        
        </v-menu>

    </template>

     <template v-slot:[`item.responsible`]="props">
         {{getPersonShortFromId(props.item.responsible.id)}}
     </template>
      <template v-slot:[`item.comment`]="props">
    <span 
    :class="editable?'text--disabled':''">(Статус - {{props.item.status.name}})</span> 
  
        <v-edit-dialog
       
          :return-value.sync="props.item.name"     
        >   
      <!-- <div class="d-none">{{props.item.comment.text}}</div> -->
    <div style="white-space:pre-wrap">      {{props.item.comment.text}}</div>
      
          <template  v-if="editable" v-slot:input>

            <v-textarea
              v-model="props.item.comment.text"
                auto-grow
                rows="3"
              label="Изменение"
              
              counter
            ></v-textarea>
          </template>
        </v-edit-dialog>

      </template>
      
    </v-data-table>
            </v-card>


</template>

<script>
import moment from "moment";
import { createNamespacedHelpers } from "vuex";

import datepicker from "@/utils/datepiker.js"
const  projectstate =createNamespacedHelpers("projectstate");
import uf from '@/utils/universal_functions'
export default {

    name:"report-top-table",
    mixins:[uf,datepicker,],
    props:{
        toptable:{
            type:Array,
            default:()=>[]
        },
        headers:{
            type:Array,
            default:()=>[]
        },
        editable:{
            type:Boolean,
            default:false
        }

    },
    data(){
        return{
            picker:false,
            search:""



        }},

    computed:{
    ...projectstate.mapGetters(["getProject"]),

    },
    methods:{
        
        oninputnostore(val){
       
        try{
        let str=this.formatDateRev(val)
        console.log(str);
        const newdate=moment(str)
      
        if ((newdate.isValid())){   
              
                return str
           
            }
        }catch(e){
          console.log(e);
        }
        
      },
        fontweight(item){
       
        return String(item.keyy).includes('.')?'':'font-weight-bold'
    },
    }

}
</script>

<style>

</style>