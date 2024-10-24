<template >
    
<v-row  class="d-flex justify-content-center">
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
        :min='newproject.datestart'
        :max='newproject.dateend'
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
   
        <v-col class="flex-col pa-0"   v-for="(x, indx) in weekdays"
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
 </v-row>


    </v-col>
                
       
                   
                        </v-row>


</template>

<script>
import moment from "moment";

export default {
    name:"step-five",
    props:{
        newproject:{type:Object, 
                    default:()=>{}}
    },

 
    data: () => ({
        frequency: 1,
        selectUpdate: [],
        weekdays: ['пн', 'вт', 'ср', 'чт', 'пт'],
        frequencyf: [
        {name: 'Еженедельно', v: 1},
        {name: 'Раз в две недели', v: 2},
        {name: 'Раз в три недели', v: 3},
        {name: 'Ежемесячно', v: 4},
            ]
            }),
    methods:{

        month(indxWeek) {
     
        let start = new Date(this.newproject.datestart)
        let end = new Date(this.newproject.dateend)

        if (!this.selectUpdate.includes(indxWeek)) {
            let project_checkpoint = new Set(this.newproject.project_checkpoint)
                for ( let i = 0; i <7; i ++) {
                   
                    if (start.getDay() == indxWeek) {
                       
                        project_checkpoint.add(moment(start).locale("Ru").format("YYYY-MM-DD"))
                        this.selectUpdate.push(indxWeek)
                        break  
                    }
                   
                    start.setDate(start.getDate()+1)
                   
                  }
                   while (start<=end) {
                     project_checkpoint.add(moment(start).locale("Ru").format("YYYY-MM-DD"))
                     start.setDate(start.getDate()+(7*this.frequency))

                   }
                  
                   this.newproject.project_checkpoint = Array.from(project_checkpoint)
                
                }
            else{
                    this.newproject.project_checkpoint= this.newproject.project_checkpoint.filter(e=>new Date(e).getDay()!=indxWeek)
                    this.selectUpdate = this.selectUpdate.filter(e=>e!=indxWeek)
                }
                    
            },







    }
}
</script>

<style>

</style>