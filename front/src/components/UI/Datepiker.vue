<template>
    <v-row>
    <v-col
        v-for="(value,i) in [datestart,dateend]"
        :key="i"
        :class="pa"
        xl=6
        lg=12
        md=6
    >
  <v-menu 
    v-model="picker[i]"
    :close-on-content-click="false"
    transition="scale-transition"
    offset-y
    min-width="auto"
    >
        <template
            v-slot:activator="{on, attrs}"
             
        >
            <v-text-field
                dense
                :value="formatDate(value)"              
                type="date-local"              
                placeholder="дд.мм.гггг"
                @focus="datekey=i"
               @input="event=>oninput(event, value, storiter[i], min,max)"
                v-bind="attrs"
                hide-details
                v-on="on"
              
                :class="mb"
                color="primaryicons"
            >
            </v-text-field>
            
        </template>
        <v-date-picker v-if="i==0"
            :first-day-of-week="1"                                         
            v-model="datestart"
            :min="minimaxon[0][0]?min:''"
            :max="minimaxon[0][1]?max:''"
            @input="i==1?
            datefrom = false
            :dateto=false"  
        >
        </v-date-picker>
        <v-date-picker v-else
            :first-day-of-week="1"                                         
            v-model="dateend"
            :min="minimaxon[1][0]?min:''"
            :max="minimaxon[1][1]?max:''"
            @input="i==1?
            datefrom = false
            :dateto=false"  
        >
        </v-date-picker>
    </v-menu>
                       </v-col>

                     
                              </v-row>
</template>

<script>
import { createNamespacedHelpers } from "vuex";
import datepicker from "@/utils/datepiker.js"
const  projectstate =createNamespacedHelpers("projectstate");
const taskstate = createNamespacedHelpers("taskstate");
const workstate = createNamespacedHelpers("workstate")
const assignmentstate = createNamespacedHelpers("assignmentstate");
export default {

    name: "Datepiker",

    mixins:[datepicker],
    props:{
        datestartstore:{
            type:String,
            default:""
        },
        dateendstore:{
            type:String,
            default:""
        },
        minimaxon:{
            type: Array,
            default:()=>[[true,true],[true,true]]
        },
        min:{
            type:String,
            default:""
        },
        max:{
            type:String,
            default:""
        },

        mb: {
            type:String,
            default:'mb-2'
        },

        pa: {
            type: String,
            default: 'pt-0 pb-1'
        }
    },

    data(){ return{
        picker:[0,0],
        
        datekey:0,
        // dates:[]
    }   


    },
      
      computed:{
        storiter(){return [this.datestartstore, this.dateendstore]},
        datestart:{
            get()
            {       
                   
             return this[`get${this.datestartstore}`]()

            },
            set(newvalue){             
                this[`set${this.datestartstore}`](newvalue)
            }

        },
           dateend:{
            get()
            {              
             return this[`get${this.dateendstore}`]()

            },
            set(newvalue){             
                this[`set${this.dateendstore}`](newvalue)
            }

        }
    },



    methods:{
        ...projectstate.mapGetters(["getProjectdatestart","getProjectdateend"]),
        ...projectstate.mapMutations(["setProjectdatestart","setProjectdateend"]),
        ...taskstate.mapGetters(["getTaskdatestart","getTaskdateend"]),
        ...taskstate.mapMutations(["setTaskdatestart","setTaskdateend"]),
        ...workstate.mapGetters(["getWorkdatestart","getWorkdateend"]),
        ...workstate.mapMutations(["setWorkdatestart","setWorkdateend"]),
         ...assignmentstate.mapGetters(["getAssignmentdatestart","getAssignmentdateend"]),
        ...assignmentstate.mapMutations(["setAssignmentdatestart","setAssignmentdateend"]),
  
 
    },


}
</script>

<style>

</style>
