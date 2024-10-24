<template>
  
      <v-menu
        v-model="menu"
        :close-on-content-click="false"
        offset-y
        max-width=300
      >
        <template v-slot:activator="{ on, attrs }">
          <div
            v-bind="attrs"
            v-on="on"
          >
            <slot/>
          </div>
        </template>
        <v-card                
          color="inyand"
          class="flex-col flex-grow-1 py-3 pb-1 pl-2"
          elevation-3
        >

          <v-list dense
            v-for="(val, i) in daysrok"
            :key="i"
          >
            <v-list-item dense>
              <v-list-item-icon class="mr-2 my-0">
                <v-icon
                  :color= val.color
                  dense
                >
                  mdi-checkbox-blank
                </v-icon>
              </v-list-item-icon>
              <v-list-item-content class="pb-1 pt-0">
                <v-list-item-title>

                  {{val.text}} 
                </v-list-item-title>
              </v-list-item-content>
            </v-list-item>
          </v-list>       
                    
            

        </v-card>
      </v-menu>
</template>

<script>
   
export default {
    name: "periodInfo",

      props: {
        srok:{
          type: Number,
          requiered:true       
        }
      },

     data: () => ({
        menu: false,
        prinfo: []

     }),

     computed: {
      daysrok() {
        let days= 'дней'
          if ([2, 3, 4].includes(this.srok)) {
                  days=  " дня"
                }
          else if ([1].includes(this.srok)) {
          days= " день"

                }
            this.prinfo = [
                {color: 'prliniarelse', text: 'до окончания более ' + this.srok + ' ' + days},
                {color: 'prliniar85', text: 'до окончания меньше '  + this.srok + ' ' + days},
                {color: 'prliniar100', text: 'срок сегодня или просрочено'},
                {color: 'prliniarstop', text: 'проект приостановлен'},
                ]
                return this.prinfo
      }

     }
}
</script>

<style>

</style>