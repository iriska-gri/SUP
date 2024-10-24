<template>
    <porject-stepper-pattern
        :name="newproject.name"
        @create_or_update="create_or_update"
        @closes="closes"
    >
 

      
        <template #1>
              <div class="pa-3 pt-0 flex-grow-1 flex-col overflow-auto overflow-x-hidden stepper" 
                                           
                                                >
            <row-pirow title="Название:"
                class="mt-1 "
                myclass="pb-4 align-self-center"
            >
                <template #leftcol>
                    <v-textarea
                        v-model="newproject.longname"
                        auto-grow
                        rows="0"
                        class="my-0 pt-0 pb-0 textsize"
                        :rules="newproject_rules.longname"
                    >
                    </v-textarea>
                </template>
            </row-pirow>
            <row-pirow title="Краткое название:"  
                myclass="pt-2"
             >
                <template #leftcol>
                    <v-textarea
                        v-model="newproject.name"
                        auto-grow
                        rows="0"
                        class="mt-0 pt-0 pb-0 textsize"
                        flat
                        dense
                        :rules="newproject_rules.name"
                    />
                </template>
            </row-pirow>
            <row-pirow title="Период:" myclass="pt-3" rowclass="px-1">
                                        <template #leftcol>
                                            <v-row class="flex-grow-0">
                                                <v-col  class="py-0">
                                                    
                                                    <v-menu
                                                        v-model="menu_project_dates[0]"
                                                        :close-on-content-click="false"
                                                        :nudge-right="40"
                                                        transition="scale-transition"
                                                        offset-y
                                                        min-width="auto"
                                                    >
                                                        <template v-slot:activator="{ on, attrs }">
                                                            <v-text-field
                                                                :value ='formatDate(newproject.datestart)'
                                                               :rules="newproject_rules.datestart"
                                                                
                                                                
                                                                v-bind="attrs"
                                                                v-on="on"
                                                            ></v-text-field>
                                                        </template>
                                                        <v-date-picker
                                                            v-model="newproject.datestart"
                                                            @input="menu_project_dates[0] = false"                                                       

                                                        ></v-date-picker>
                                                    </v-menu>
                                                </v-col>
                                                <v-col class="py-0">
                                                    <v-menu
                                                        v-model="menu_project_dates[1]"
                                                        :close-on-content-click="false"
                                                        :nudge-right="40"
                                                        transition="scale-transition"
                                                        offset-y
                                                        min-width="auto"
                                                    >
                                                        <template v-slot:activator="{ on, attrs }">
                                                            <v-text-field
                                                                :value ='formatDate(newproject.dateend)'                                                             
                                                                
                                                                v-bind="attrs"
                                                                v-on="on"
                                                            ></v-text-field>
                                                        </template>
                                                        <v-date-picker
                                                            v-model="newproject.dateend"
                                                            @input="menu_project_dates[1] = false"
                                                          
                                                        ></v-date-picker>
                                                    </v-menu>
                                                </v-col>
                                            </v-row>
                                        </template>  
                                    </row-pirow>
            <row-pirow title="Сложность проекта:"  
                class="pt-1" 
            >
                <template #leftcol>
                    <div class=" ml-n2">
                        <v-rating
                            v-model="newproject.difficult"
                            color="warning"
                            empty-icon="mdi-star-outline"
                            full-icon="mdi-star"
                            half-icon="mdi-star-half-full"
                            hover
                            length="5"
                            size="16"
                        />
                    </div>
                </template>
            </row-pirow>
            <row-pirow title="Тип:"      
                class="py-2"           
            >
                <template #leftcol>
                    <v-autocomplete
                        dense
                        class="inputext pointer mt-n1 iconsh "
                        v-model="newproject.ptype"
                        :items="$store.getters[`filterslogic/mult/mult_project__type`]"
                        return-object
                        item-text="name"
                        item-value="id"
                        
                        hide-no-data
                        item-color="open_icons"
                        color="primaryicons"
                        :rules="newproject_rules.ptype"
                    />
                </template>
            </row-pirow>
            <row-pirow title="Сфера организации Проекта:"
                class="pt-6"
                myclass="pb-5 align-self-center"
            >
                <template #leftcol>
                    <v-textarea
                        v-model="newproject.info.project_sphere"
                        auto-grow
                        rows="0"
                        class="pt-0 pb-2 textsize"
                        flat
                        dense
                        required
                    />
                </template>
            </row-pirow>  
            <row-pirow title="Дата утверждения паспорта Проекта:"
            class="pt-3"
                myclass="pt-0"
            >
                <template #leftcol>
                    <div class=" mt-n3 ">
                        <v-menu
                            v-model="menupassport_last_date"
                            :close-on-content-click="false"
                            :nudge-right="40"
                            transition="scale-transition"
                            offset-y
                            min-width="auto"
                        >
                            <template v-slot:activator="{ on, attrs }">
                                <!-- v-model="newproject.info.passport_last_date" -->
                                <v-text-field
                                    type="date-local"   
                                    readonly
                                    v-bind="attrs"
                                    placeholder="дд.мм.гггг"
                                    v-on="on"
                                    flat
                                    dense
                                    auto-grow
                                    rows="0"
                                    :value="formatDate(newproject.info.passport_last_date)" 
                                ></v-text-field>
                            </template>
                            <v-date-picker
                                v-model="newproject.info.passport_last_date"
                                @input="menupassport_last_date = false"
                                placeholder="дд.мм.гггг"
                                
                                :min='getProject.datestart'
                                :max='getProject.dateend'
                            />
                        </v-menu>  
                    </div>               
                </template>
            </row-pirow>
            <row-pirow title="Дополнительная информация:"
            myclass="pb-6 align-self-center"
            class="pt-4"
            >
                <template #leftcol>
                    <v-textarea
                        v-model="newproject.info.dop_info"
                        auto-grow
                        rows="0"
                        class="mt-n1 pt-0 pb-2 textsize"
                        flat
                        dense
                    />
                </template>
            </row-pirow>
            <row-pirow title="Финансовое обеспечение расходных обязательств, связанных с реализацией настоящего приказа:" 
          myclass="align-self-center pb-4"
            > 
                <template #leftcol>
                    <v-textarea
                        v-model="newproject.info.financial_support"
                        hide-details
                        auto-grow
                        rows="0"
                        class="mt-0 pt-2 pb-0"
                        flat
                        dense
                    />
                </template>
            </row-pirow>
            <row-pirow title="Основания для инициализации проекта:" class="pt-4" myclass="pb-0 align-self-center">
                <template #leftcol>
                    <v-textarea 
                        v-model="newproject.info.grounds"
                        auto-grow
                        rows=0
                        dense
                        flat
                        class="mt-0 pt-0 pb-0"
                        hide-details
                    />
                </template>
            </row-pirow>
              </div>
        </template>

        <template #2>
            

              <div class="pa-3 pt-0 flex-grow-1 flex-col  overflow-x-hidden stepper" 
                                           
                                                >
            <v-row class="mb-2 mt-0  flex-grow-0 font-weight-bold text-overline main_theme">
                <v-col lg=4 class="py-0" >Роли</v-col>
                <v-col lg=4 class="py-0">Сотрудники</v-col>
                <v-col class="py-0">Процент занятости</v-col>
                <v-col class="text-end py-0">Добавить/удалить</v-col>
            </v-row>
             <v-divider class="mb-3 mt-1"/>
            <roles-single
                :show= true
                @showuserinfo="showuserinfo"
            />
            <v-divider class="my-2"/>
            <roles-many
                :roles="5"
                :show="true"
                @showuserinfo="showuserinfo"
            />
             <v-divider class="mt-5"/>
            <roles-many
                :show="true"
                @showuserinfo="showuserinfo"
            />
            <v-divider class="mt-5"/>
          
        
              </div>
        </template>

        <template #3>
  <div class="pa-3 pt-0 flex-grow-1 flex-col  overflow-auto overflow-x-hidden stepper" 
                                           
                                                >
            <exp-panel
                :completion="true"
                :addremrow="addremrow"
                :newproject="newproject"
                @remove="remove"
                @addRows="addRows"
            />

    

  </div>
        </template>  

        <template #4>
       
            
            
            
                <v-container style="height:100%">
    
    <v-row style="height:100%">
      <v-col class="flex-col justify-space-between">
        <v-treeview
          :active.sync="selection"
          :items="newproject.tasks"
          :selection-type="'independent'"
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
        :class="!selection.length?'justify-space-around':'justify-space-between'"
        cols="6"
      >
        <template v-if="!selection.length">
         <div class="align-self-center "> Ничего не выбрано</div>
        </template>
        <template         
        v-else>
            <v-form
            lazy-validation
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
                                                            :min="findMinMaxdate(node.id, 'datestart')"
                                                            :max="findMinMaxdate(node.id,'dateend')"

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
                                                            :min="findMinMaxdate(node.id, 'datestart')"
                                                            :max="findMinMaxdate(node.id,'dateend')"
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
                    <row-pirow title="Описание:" rowclass="px-1"
                    class="pt-2"
                    myclass="pt-3">
                                        <template #leftcol>
                                            <v-textarea 
                                                v-model="node.description"
                                                auto-grow
                                                rows=0
                                                dense
                                                flat
                                                class="mt-0 pt-0 pb-2"
                                                hide-details
                                            ></v-textarea>
                                        </template>
                                    </row-pirow>
            </div>
                <v-btn
                v-if="'task_work' in selection[0]"
                        @click="addwork"
                        >Добавить работу</v-btn>
          </v-form>
          
        </template>
      </v-col>
    </v-row>
   
  </v-container>



 







   
    </template>

        
        <template #5>
    
<v-row  class="flex-grow-1 justify-content-center">
    <v-col class="flex-col" lg=4>
<v-row class="flex-grow-0 ">
    <v-col class="flex-col mt-4 text-center">
        <strong>Дата отчета о статусе проекта</strong>
    </v-col>
</v-row>
<v-divider class="my-5"/>
<v-row>
        <v-col class=" flex-col align-self-center">
            <v-date-picker
        v-model="newproject.project_checkpoint"
        multiple
        no-title
        :min='getProject.datestart'
        :max='getProject.dateend'
        first-day-of-week=1
        scrollable
        show-adjacent-months
        class="chekpoin"

      ></v-date-picker>
    </v-col>
</v-row>
<v-divider class="mt-5"/>

<v-row  class="flex-grow-0">
        <v-col class=" flex-col pa-0">


      <v-radio-group
      v-model="frequency"
      row
      class="flex-col"
    >
    <v-row class=" inyand">
                          <v-col
                          v-for="x in frequencyf" :key= x.v
                            xl="6"
                            lg=6
                            md=6
                            sm=6
                            cols=6
                            class="caption text-nowrap pa-0"
                          >
    <v-row class="pa-2  align-items-center inyand">
      <v-col class="flex-grow-0  ">
        


  <v-radio
  class="radios"
           color="btns"
            :label="x.name"
            :value= x.v
            />
 
        
  
      </v-col>

    </v-row>
    
                          </v-col>
    </v-row>
  </v-radio-group>


       
    </v-col>
</v-row>
<v-row>
    <!-- <v-divider vertical/> -->
        <v-col class="flex-col pa-0"   v-for="(x, indx) in weeks"
                                :key= indx>
                                    <v-chip
                              outlined
                                class="ma-2 justify-content-center inyand--text"
                                color="btns"
                                @click="month(indx+1)"
                            >
                            {{x}} 
                            </v-chip>
    </v-col>
    <!-- <v-divider vertical/> -->
</v-row>


    </v-col>
                
       
                   
                        </v-row>


 </template>

    </porject-stepper-pattern>
</template>

<script>
import moment from "moment";
import rowPirow from '@/components/carddetails/pattern/row-pirow.vue';
import RolesSingle from '@/components/assignments/UI/roles-single.vue';
import rolesMany from '@/components/assignments/UI/roles-many.vue';
import RowsAddremove from '@/components/carddetails/pattern/rows-addremove.vue';
import { createNamespacedHelpers } from "vuex";
import uf from '@/utils/universal_functions'


import PorjectStepperPattern from '@/views/pattern/porject-stepper-pattern.vue';
import ExpPanel from '../assignments/UI/exp-panel.vue';
const projectstate = createNamespacedHelpers("projectstate");

// -----------
export default {

components: { rowPirow, RolesSingle, rolesMany, RowsAddremove, PorjectStepperPattern, ExpPanel },

mixins:[uf],

data: () => ({
// -----------
    
    active: [],
    activework:[],
    open: [],
    openwork: [],
// -----------
    frequency: 1,
    longn:'',
    addremrow: [{field: 'target', text: "Цель (цели) проекта"},
                {field: 'result', text: "Результат (результаты) проекта"},
                {field: 'criteria', text: "Критерии успеха проекта"},
                {field: 'risks', text: "Риски реализации проекта"},
                {field: 'interactions', text: "Взаимосвязи с другими проектами и программами"},
                ],
    selectUpdate: [],
    indx: -1, 
    indexwork:-1, 
    workon: false,
    dialogdelete: false,

        deletion: {
            deltasks: [],
            delworks: []
        },
        errortext: {
            longname: {
                required : 'Поле обязательно для заполнения', 
                minLength: 'Минимальная длина 4 символа'
            },
            name: {
                required : 'Поле обязательно для заполнения', 
            },
        
    },
    selection:[],
    selection_rules:{name:[ v => !!v || 'Обязательно для заполнения',],
                    datestart:[ v => !!v || 'Обязательно для заполнения',
                                // v => moment(v,"DD.MM.YYYY").isValid()==true || 'Что-то не то с датой',
                                ],
                    responsible:[ v => !!v || 'Обязательно для заполнения',]


    },
    newproject_rules:{
                name:[ v => !!v || 'Обязательно для заполнения',],
                longname:[ v => !!v || 'Обязательно для заполнения',
                           v => v.length>4 || 'Полное название должно содержать в себе более 4х символов'
                ],
                datestart:[ v => !!v || 'Обязательно для заполнения',
                            v => moment(v, "DD.MM.YYYY").isValid() || 'Дата указана неверно',
                ],
                dateend:[ v => !!v || 'Обязательно для заполнения',
                        v => moment(v, "DD.MM.YYYY").isValid() || 'Дата указана неверно',              
                ],
                ptype:[ v => !!v || 'Обязательно для заполнения',],



    },





    selectedItem:0,
    menudatestart: false,
    menudateend: false,
    
    menuproject_checkpoint: false,
    alldate: [],
    menu: false,
    selectedDate: null,
    dateFormat: 'dd-MM-yyyy',
    weeks: ['пн', 'вт', 'ср', 'чт', 'пт'],
    frequencyf: [
        {name: 'Еженедельно', v: 1},
        {name: 'Раз в две недели', v: 2},
        {name: 'Раз в три недели', v: 3},
        {name: 'Ежемесячно', v: 4},
    ]
}),

   


 methods: {  
findMinMaxdate(id,key){
    if ("task_work" in this.selection[0]){
        return this.newproject[key]

    }
    else{
        let elm=this.newproject.tasks.find(e=>e.id==this.selection[0].parent)
        return elm[key]
    }

},


    closes() {
        
        this.$emit('closes')
    },
    
    showuserinfo(id){
        this.$emit("showuserinfo",id)
    },

    month(indxWeek) {
     
        let start = new Date(this.newproject.datestart)
        let end = new Date(this.newproject.dateend)

        if (!this.selectUpdate.includes(indxWeek)) {
            this.newproject.project_checkpoint = new Set(this.newproject.project_checkpoint)
                for ( let i = 0; i <7; i ++) {
                   
                    if (start.getDay() == indxWeek) {
                       
                        this.newproject.project_checkpoint.add(this.currentDaytvo(start))
                        this.selectUpdate.push(indxWeek)
                        break  
                    }
                   
                    start.setDate(start.getDate()+1)
                   
                  }
                   while (start<=end) {
                     this.newproject.project_checkpoint.add(this.currentDaytvo(start))
                     start.setDate(start.getDate()+(7*this.frequency))

                   }
                  
                   this.newproject.project_checkpoint = Array.from(this.newproject.project_checkpoint)
                
                }
            else{
                    this.newproject.project_checkpoint= this.newproject.project_checkpoint.filter(e=>new Date(e).getDay()!=indxWeek)
                    this.selectUpdate = this.selectUpdate.filter(e=>e!=indxWeek)
                }
                    
            },

           


   

        create_or_update() {          
            console.log(this.newproject,"newproject");
             // this.$emit('newproject', {project: this.newproject, delete:this.deletion} )
       
        },


        deleteTask(key) {
            this.newproject.tasks.splice(key, 1)
        },

        addRows(row) {     
            this.newproject.info[row].push('')
        },

       

        addtask() {
        if (this.selection && !this.$refs.selection.validate()){
            return
        }
        this.newproject.tasks.push({id: -1*(this.newproject.tasks.length), longname: "", name:"Новая задача", description: "", datestart: null, dateend: null, responsible: null, task_work:[]})
        this.selection[0]=this.newproject.tasks[this.newproject.tasks.length-1]
        },

        addwork() {
            if (this.selection && !this.$refs.selection.validate()){
            return
        }
            this.selection[0].task_work.push({id: -1*(this.selection[0].task_work.length),parent:this.selection[0].id, longname: "", name:"Новая работа", description: "", datestart: "", dateend: "", responsible: ""})
           this.selection[0]= this.selection[0].task_work[this.selection[0].task_work.length-1] 
        },

        deltasksworks() {
            let arr = []
            let delarr = []
            let selectid = ""
            
           if (this.activework.length > 0){
                arr = this.selected.task_work,
                delarr = this.deletion.delworks,
                selectid = this.activework[0]
           }
           else{
                arr = this.newproject.tasks,
                    delarr = this.deletion.deltasks,
                    selectid = this.selected.id
                    this.selected.task_work.forEach(e=>this.deletion.delworks.push(e.id));
           }
                            
            if (selectid >= 0) {
                delarr.push(selectid)
            }
            let delinx = arr.findIndex(e=>e.id==selectid)
            if(arr == this.selected.task_work) {
                    this.activework = []  
            }
            arr.splice(delinx, 1)
            this.dialogdelete = false

            console.log(`this.newproject.tasks`, this.deletion, this.newproject.tasks);
        }

          
 },

       computed:{
            ...projectstate.mapGetters(["getProject", "getprojectuniqueusers",'getprojectuniquePersons']),


      selected () {
        
        if (!this.active.length) return undefined
        this.activework=[]
        const id = this.active[0]
        console.log(`id`, id, this.newproject.tasks);
        return this.newproject.tasks.find(e => e.id === id)
                
        
      },

      workselected() {
        if (!this.activework.length) return undefined
        const id = this.activework[0]
        return this.selected.task_work.find(e => e.id === id)
                
      },
    //   ------------------------
 

    


       },

      

}
</script>

<style>
.rama {
    min-width: 15px;
}

/* .radios .v-input--selection-controls__ripple {
    border-radius: 50% !important;
} */

.radios  .v-input--selection-controls__ripple {
    border-radius: 50%!important;
    cursor: pointer;
    height: 20px;
    position: absolute;
    transition: inherit;
    width: 20px;
    left: -5px;
    top: calc(50% - 17px);
    margin: 7px;
}

/* .chekpoin .v-btn--icon.v-size--default .v-icon, .v-btn--fab.v-size--default .v-icon {

    font-size: 11px!important;

}  */

  .chekpoin i {

    font-size: 13px!important;
    }
</style>