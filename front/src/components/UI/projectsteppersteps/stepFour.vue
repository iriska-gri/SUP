   <template>
       
    <v-form  ref="form" lazy-validation class=" d-flex pa-3 pt-0 flex-grow-1 flex-col overflow-auto overflow-x-hidden stepper" 
             style="height:100%"                              
                                                >
    
    <v-row class="d-flex flex-grow-1 " style="height:100%">
      <v-col class="flex-col justify-space-between">
        <v-treeview
          :active.sync="selection"
          :items="newproject.tasks"
          :selection-type="'leaf'"
          item-key="fakeid"
          hoverable
          activatable
          return-object
          item-children="task_work"
          open-all
          
        ></v-treeview>
 <v-btn
 @click="addtask"
 >Добавить задачу</v-btn>
      </v-col>
      <v-divider vertical></v-divider>
      <v-col
        class="flex-col flex-grow-1 justify-space-between"
        style="height:100%"
        :class="!selection.length?'justify-space-around':'justify-space-between'"
        cols="6"
      >
        <template v-if="!selection.length">
         <div class="align-self-center "> Ничего не выбрано</div>
        </template>
        <template         
        v-else>
            <div
             class="d-flex flex-grow-1 flex-col" ref="selection">
            
                <div class="d-flex flex-grow-1 flex-col"

                    v-for="node in selection"
                    :key="node.id"
                >
              <row-pirow title="Название:"
                            myclass="pt-3"
                            rowclass="px-1">
                                <template #leftcol>
                                    <v-textarea 
                                        v-model="node.longname"
                                        auto-grow
                                        rows=0
                                        dense
                                        flat
                                        class="mt-0 pt-0 pb-2"
                                        

                                    />

                                </template>
                    </row-pirow>
                     <row-pirow title="Короткое название:"
                    myclass="pt-2"
                    rowclass="px-1">
                        <template #leftcol>
                            <v-textarea 
                                v-model="node.name"
                                auto-grow
                                rows=0
                                dense
                                flat
                                class="mt-0 pt-0 pb-2"
                                :rules="selection_rules.name"
                            ></v-textarea>
                        </template>
                    </row-pirow>
                      <row-pirow title="Период:" myclass="pt-3" rowclass="px-1">
                                        <template #leftcol>
                                            <v-row class="flex-grow-0">
                                                <v-col  class="py-0">
                                                    
                                                    <v-menu
                                                        v-model="menudatestart"
                                                        :close-on-content-click="false"
                                                        :nudge-right="40"
                                                        transition="scale-transition"
                                                        offset-y
                                                        min-width="auto"
                                                    >
                                                        <template v-slot:activator="{ on, attrs }">
                                                            <v-text-field
                                                                :value ='formatDate(node.datestart)'
                                                                :rules="selection_rules.datestart"
                                                                
                                                                
                                                                v-bind="attrs"
                                                                v-on="on"
                                                            ></v-text-field>
                                                        </template>
                                                        <v-date-picker
                                                            v-model="node.datestart"
                                                            @input="menudatestart = false"
                                                            :min="findStartMinDate"
                                                            :max="findStartMaxdate"

                                                        ></v-date-picker>
                                                    </v-menu>
                                                </v-col>
                                                <v-col class="py-0">
                                                    <v-menu
                                                        v-model="menudateend"
                                                        :close-on-content-click="false"
                                                        :nudge-right="40"
                                                        transition="scale-transition"
                                                        offset-y
                                                        min-width="auto"
                                                    >
                                                        <template v-slot:activator="{ on, attrs }">
                                                            <v-text-field
                                                                :value ='formatDate(node.dateend)'
                                                                :rules="selection_rules.datestart"
                                                                readonly
                                                                v-bind="attrs"
                                                                v-on="on"
                                                            ></v-text-field>
                                                        </template>
                                                        <v-date-picker
                                                            v-model="node.dateend"
                                                            @input="menudateend = false"
                                                            :min="findEndMinDate"
                                                            :max="findEndMaxdate"
                                                        ></v-date-picker>
                                                    </v-menu>
                                                </v-col>
                                            </v-row>
                                        </template>  
                                    </row-pirow>

                    <row-pirow title="Сложность:"  class="mt-2" rowclass="px-1"
                    
                    >
                        <template #leftcol>
                            <v-rating
                                v-model="node.difficult"
                                class=" ml-n3 star"
                                color="warning"
                                empty-icon="mdi-star-outline"
                                full-icon="mdi-star"
                                half-icon="mdi-star-half-full"
                                hover
                                length="5"
                                size="16"
                            />
                        </template>
                    </row-pirow>
                    <row-pirow title="Ответсвенный:" rowclass="px-1"
                    class="pt-2">
                                        <template #leftcol>
                                           
                                            <v-autocomplete
                                                dense
                                                class="inputext pointer mt-n1 iconsh font-weight-medium"
                                                v-model="node.responsible"
                                                :items="getprojectuniquePersons"
                                                return-object
                                                item-text="fullname"
                                                item-value="id"
                                                
                                                item-color="open_icons"
                                                color="primaryicons"
                                                :rules="selection_rules.responsible"
                                            />
                                        </template>
                                    </row-pirow>
                    <strong class="px-1">Описание:</strong> 
                                 
                       <v-textarea 
                                                v-model="node.description"
                                                no-resize
                                                rows=10
                                                solo
                                                
                                                class="mt-0 pt-0 pb-2"
                                                hide-details
                                            ></v-textarea>
            </div>
           <div class="d-felx flex-grow-0">
            <div class="d-felx flex-row justify-space-around">
                <v-btn
                v-if="'task_work' in selection[0]"
                        @click="addwork"
                        >Добавить работу</v-btn>                     
                
                
                <v-btn
                class="white--text"
                        color="red "
                        @click="deltasksworks"
                        >Удалить {{'task_work' in selection[0]?"Задачу": "Работу" }}</v-btn>



            </div>
           </div>
          </div>
          
        </template>
      </v-col>
    </v-row>
   
    </v-form>



 







</template>

<script>
import { createNamespacedHelpers } from "vuex";
const  projectstate =createNamespacedHelpers("projectstate");
import moment from "moment";
import rowPirow from '@/components/carddetails/pattern/row-pirow.vue';
import formatDate from '@/utils/datepiker'
export default {
    name:"step-four",
    mixins:[formatDate],
    components: { rowPirow },
    props:{
        newproject:{type:Object, 
                    default:()=>{}}
    },
    data:()=>{
        return{
            deletion: {
            deltasks: [],
            delworks: []
            },
            menudatestart: false,
            menudateend: false,
             selection:[],
            selection_rules:{name:[ v => !!v || 'Обязательно для заполнения',],
                            datestart:[ v => !!v || 'Обязательно для заполнения',
                                        // v => moment(v,"DD.MM.YYYY").isValid()==true || 'Что-то не то с датой',
                                        ],
                            responsible:[ v => !!v || 'Обязательно для заполнения',]

            },




        }

    

    },
  computed:{
...projectstate.mapGetters(["getProject","getprojectuniquePersons"]),

    findStartMaxdate(){
        if ("task_work" in this.selection[0]){
            // datestart
            
            if(this.selection[0].task_work.length>0){
            let min = this.selection[0].task_work.reduce((prev,curr)=>{
                return  moment(prev.datestart).isBefore(curr.datestart)?prev.datestart : curr.datestart
            })
            
            return moment(this.newproject.dateend).isBefore(min)?this.newproject.dateend : min
            }
            return "dateend" in this.newproject?this.newproject.dateend:undefined


        }
        else{            
            let elm=this.newproject.tasks.find(e=>e.id==this.selection[0].parent.id)
            return elm.dateend
        }

},

    findStartMinDate(){
            if ("task_work" in this.selection[0]){return this.newproject.datestart}
            else{
                let elm=this.newproject.tasks.find(e=>e.id==this.selection[0].parent.id)
                return elm.datestart
            }},

    findEndMinDate(){
        if ("task_work" in this.selection[0]){
            // datestart
            if(this.selection[0].task_work.length>0){
            let min = this.selection[0].task_work.reduce((prev,curr)=>{
                return  moment(prev.dateend).isAfter(curr.dateend)?prev.dateend : curr.dateend
            })
            if(moment(min).isValid()) return moment(this.newproject.datestart).isAfter(min)?this.newproject.datestart : min}
            
            return this.newproject.datestart
            



        }
        else{            
            let elm=this.newproject.tasks.find(e=>e.id==this.selection[0].parent.id)
            return moment(elm.datestart).isValid()?elm.datestart:undefined
        }

    },

    findEndMaxdate(){
         if ("task_work" in this.selection[0]){return this.newproject.dateend}
            else{
                let elm=this.newproject.tasks.find(e=>e.id==this.selection[0].parent.id)
                return elm.dateend
            }

    }

    },
    methods:{
         addtask() {
        if (this.selection && !this.$refs.form.validate()){
            return
        }
        let id = -1*(this.newproject.tasks.length)
        this.newproject.tasks.push({fakeid:`t-${id}` ,id: id, longname: "", name:"Новая задача", description: "", datestart: null, dateend: null, responsible: null, task_work:[]})
        this.selection= [this.newproject.tasks[this.newproject.tasks.length-1]]
        },
        addwork() {
            if (this.selection && !this.$refs.form.validate()){
            return
        }
        let id=-1*(this.selection[0].task_work.length)
            this.selection[0].task_work.push({fakeid:`w-${id}` ,id: id,parent:{id:this.selection[0].id}, longname: "", name:"Новая работа", description: "", datestart: "", dateend: "", responsible: ""})
        //    this.selection[0]= this.selection[0].task_work[this.selection[0].task_work.length-1] 
                this.selection=[this.selection[0].task_work[this.selection[0].task_work.length-1] ]
        },

        deltasksworks() {            
            if (this.selection.length>0){
                if('task_work' in this.selection[0]){
                    if (this.selection[0].id>0)this.deletion.deltasks.push(this.selection[0].id)
                    
                    this.selection[0].task_work.forEach(e=>{if(e.id>0)this.deletion.delworks.push(e.id)});
                    this.newproject.tasks.splice(this.newproject.tasks.findIndex(e=>e.id==this.selection[0].id),1)
                    this.selection=[]

                }
                else{
                    if (this.selection[0].id>0)this.deletion.delworks.push(this.selection[0].id)
                    let taskind = this.newproject.tasks.findIndex(e=>e.id==this.selection[0].parent.id)
                    this.newproject.tasks[taskind].task_work.splice(this.newproject.tasks[taskind].task_work.findIndex(e=>e.id==this.selection[0].id),1)
                    this.selection=[]
                } 
                this.newproject.deletion = this.deletion         
            }
        //    if (this.activework.length > 0){
        //         arr = this.selected.task_work,
        //         delarr = this.deletion.delworks,
        //         selectid = this.activework[0]
        //    }
        //    else{
        //         arr = this.newproject.tasks,
        //             delarr = this.deletion.deltasks,
        //             selectid = this.selected.id
        //             this.selected.task_work.forEach(e=>this.deletion.delworks.push(e.id));
        //    }
                            
        //     if (selectid >= 0) {
        //         delarr.push(selectid)
        //     }
        //     let delinx = arr.findIndex(e=>e.id==selectid)
        //     if(arr == this.selected.task_work) {
        //             this.activework = []  
        //     }
        //     arr.splice(delinx, 1)
        //     this.dialogdelete = false

        //     console.log(`this.newproject.tasks`, this.deletion, this.newproject.tasks);
        },


      


    }
}
</script>

<style>

</style>