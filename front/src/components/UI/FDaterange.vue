<template>
   <v-col
              class="pa-0 px-1 align-self-center pb-2"
              xl="1"
              lg="2"
              md="6"
              sm="12"
              
         
            >
              <v-menu 
                v-model="menu"
                :close-on-content-click="false"
                transition="scale-transition"
                offset-y
                min-width="auto"
              >
                <template
                    v-slot:activator="{on, attrs}"
                    class="ma-0 align-self-start"
                >
                  <layout-label
                      :title="title"      
                  />
                    <v-text-field
                        dense
                        solo
                        :value="formatDate(filt)"              
                        type="date-local"              
                        placeholder="дд.мм.гггг"
                        background-color='inputcolor'
                        @input="oninput"
                        v-bind="attrs"
                        hide-details
                        v-on="on"
                        class="pt-0"
                        
                      >
                    </v-text-field>
                </template>
                <v-date-picker
                  :first-day-of-week="1"                
           
                  v-model="filt"
                  
                 
                  
                >
                </v-date-picker>
              </v-menu>
            </v-col>

</template>

<script>
import moment from "moment";
export default {
  name:'f-daterange',
   data() {
        return {
          dates: '2018-03-02',
          dates1: '2018-03-02',
          menu:false
        }},       
     props: {
        field: {
            type: [String],
        },
        type: {
            type: String,
            default: "text",
        },
        title: {
            type: String,
        },
        appendouter:{
            type: String,
            default:""
        },
        disabled: {
            type: Boolean,
            default: false,
        },
    },
    computed: {
        filt: {
            get() {
                return this.$store.getters[`filterslogic/datepicker/${this.field}`];
            },
            set(value) {
                this.$store.dispatch("filterslogic/datepicker/addFilter", { key: this.field, value })
                this.$emit("filterreestr")
                ;
            },
        },
    },
    beforeDestroy() {
        this.$store.dispatch("filterslogic/datepicker/addFilter", { key: this.field, value: '' });
    },
    methods:{
        formatDate (date) {
            try {         
                    // if (!date) return null
                    if (date.split('-').length==3){
                    const [year, month, day] = date.split('-')
                    return `${day}.${month}.${year}`
                    }
                }
            catch{return null}
                
              },
          formatDateRev (date) {
                    
                   
                    if (!date) return null
                    let dspl = date.split('.')
                    
                    if (dspl.length==3 && dspl[2].length>0){
                    const [day, month, year] = dspl                    
                    return `${year}-${month}-${day}`
                    }
                    return false
                },


          oninput(val){
            
            try{
            
            let str=this.formatDateRev(val)
            console.log(str);
            const newdate=moment(str)
            // =newdate.format("YYYY-MM-DD")
            console.log(newdate.isValid());
            if (newdate.isValid()){
              this.dates=str
              this.filt=this.dates              
              
            }
            
            }catch(e){
              console.log(val);
            }
            
          },

    }


}
</script>

<style>

</style>

<style>

</style>