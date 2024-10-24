<template>
              <v-form  ref="form" lazy-validation class="pa-3 pt-0 flex-grow-1 flex-col overflow-auto overflow-x-hidden stepper" 
                                           
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
                                                            :max="newproject.tasks.length>0?projectmaxStartdate:undefined"
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
                                                                :rules="newproject_rules.dateend"
                                                                v-bind="attrs"
                                                                v-on="on"
                                                            ></v-text-field>
                                                        </template>
                                                        <v-date-picker
                                                            v-model="newproject.dateend"
                                                            @input="menu_project_dates[1] = false"
                                                            :min="newproject.tasks.length>0?projectminEnddate:undefined"
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
                                
                                :min='newproject.datestart'
                                :max='newproject.dateend'
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
              </v-form>
</template>

<script>
import moment from "moment";
import rowPirow from '@/components/carddetails/pattern/row-pirow.vue';
import formatDate from '@/utils/datepiker'
export default {
    name:"step-one",
    components: { rowPirow },
    mixins:[formatDate],  
     
    props:{
        newproject:{type:Object, 
                    default:()=>{}}
    },
    data:()=>({
        menupassport_last_date: false,
        menu_project_dates:[false,false],
        newproject_rules:{
                name:[ v => !!v || 'Обязательно для заполнения',],
                longname:[ v => !!v || 'Обязательно для заполнения',
                           v => v.length>4 || 'Полное название должно содержать в себе более 4х символов'
                ],
                datestart:[ v => !!v || 'Обязательно для заполнения',
                            v => moment(v, "DD.MM.YYYY").isValid() || 'Дата указана неверно',
                            // v=> moment(v, "DD.MM.YYYY").isBefore(st)||"Одна из задач начинается раньше этой даты"
                ],
                dateend:[ v => !!v || 'Обязательно для заполнения',
                        v => moment(v, "DD.MM.YYYY").isValid() || 'Дата указана неверно',              
                ],
                ptype:[ v => !!v || 'Обязательно для заполнения',],



    },

        }
    ),
    computed:{
        projectmaxStartdate(){
            let min = this.newproject.tasks.reduce((prev,curr)=>{
                return  moment(prev.datestart).isBefore(curr.datestart)?prev.datestart:curr.datestart
            })
            
            return moment(this.newproject.dateend).isBefore(min)?this.newproject.dateend : min
        },
        projectminEnddate(){
            let min = this.newproject.tasks.reduce((prev,curr)=>{
                return  moment(prev.dateend).isAfter(curr.dateend)?prev.dateend : curr.dateend
            })
            
            return moment(this.newproject.datstart).isAfter(min)?this.newproject.datestart : min
        }





    }
}
</script>

<style>

</style>