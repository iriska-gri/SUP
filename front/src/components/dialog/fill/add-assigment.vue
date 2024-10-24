<template>
  <div>
    <v-row class="flex-grow-0 px-5">
            <v-col class="pb-0 pt-2">

              <v-text-field
                
                v-model="name"
                label="Введите краткое название"
                required
                class="mb-0 pt-0"
                hide-details
              ></v-text-field>
            </v-col>
          </v-row>
          <v-row class="flex-grow-0 px-5">
            <v-col class="pb-0 pt-2">

              <v-text-field
                
                v-model="longname"
                label="Введите полное название"
                required
                class="mb-0 pt-0"
                hide-details
              ></v-text-field>
            </v-col>
          </v-row>
          <v-row  class="flex-grow-0 px-5">
            <v-col
            class="align-self-center py-0">
              <Datepiker
      
                :mb="'mt-0 pt-1'"
                :min="actionmethod.min"
                :max="actionmethod.max"
                :datestartstore="actionmethod.datestartstore"
                :dateendstore="actionmethod.dateendstore"
               />
            </v-col>

            <v-col class="align-self-end py-0">
              <v-select
              
                v-model="responsible"
                item-text="text"
                item-value="id"
                :items='resources'
                :label="actionmethod.responsible_text"
                required
                return-object
           
              ></v-select>
             
            </v-col>

          </v-row>
          <v-row class="flex-grow-0 px-5">
            <v-col class="pb-0 pt-2 d-flex">  <span class="caption">Сложность:</span> <v-rating
          class="pb-2"
          color="warning"
          empty-icon="mdi-star-outline"
          full-icon="mdi-star"
          half-icon="mdi-star-half-full"
          hover
          length="5"
          
          size="16"
          v-model="difficult"
        ></v-rating>
            </v-col>
            </v-row>
          <v-row class="px-5 mt-0">
            <v-col class="py-0">
              <v-textarea
                class="inputext aa_border"
                v-model="description"
                hide-details
                label="Описание"
                rows="4"
                auto-grow
     
          
            >
            </v-textarea> 
            </v-col>
          </v-row>
  </div>
</template>

<script>
export default {
    name:"AddAssigment",

    props:{
      actionmethod:{
        type: Object,
        default: ()=>{}
      },
      dialoginfo:{
        type:Object,
        default:()=> {return {}}
      },
      resources: {
         type: Array,
        default: ()=>[]      
      },
   
    },

    computed:{
   
        name:{
        get(){
            return this.dialoginfo.name
        },
        set(val){
          
            this.$emit("changeddialog", Object.assign(this.dialoginfo,{name:val}) )
        }
        },
         longname:{
        get(){
            return this.dialoginfo.longname
        },
        set(val){
          
            this.$emit("changeddialog", Object.assign(this.dialoginfo,{longname:val}) )
        }
        },
      
        responsible:{
        get(){
            return this.dialoginfo.responsible
        },
        set(val){
            this.$emit("changeddialog", Object.assign(this.dialoginfo,{responsible:val}) )
        }
        },

        description: {
        get(){
            return this.dialoginfo.description
        },
        set(val){
           this.$emit("changeddialog", Object.assign(this.dialoginfo,{description:val}) )
        }
        },

        difficult: {
        get(){
           
            return this.dialoginfo.difficult
        },
        set(val){        
           this.$emit("changeddialog", Object.assign(this.dialoginfo,{'difficult':val}) )
        }
        }

       
       

        }

}
</script>

<style>
.aa_border textarea {
  border-top: 1px solid grey;
}
</style>