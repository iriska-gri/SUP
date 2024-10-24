<template>
 <div class="pa-0 align-self-center">
    <v-menu
      v-model="menu"
      :close-on-content-click="false"
      :nudge-width="500"
      offset-x
    >
      <template v-slot:activator="{ on, attrs }">
        <div
             v-bind="attrs"
          v-on="on">
        <MyIco
          color="indigo"
            icons ='mdi-owl'
            
     
        />
    
        </div>

    
      </template>

      <v-card
      class="whmy overflow-auto overflow-x-hidden">
      <v-row class="ma-3">
        <v-col >
<pre>
{{pretext}}
</pre>
        </v-col>
      </v-row>
      </v-card>
    </v-menu>
  </div>
</template>

<script>
export default {
    name: "myHelper",

    props: {
      pretext: {
        type:Object,
        default:()=>{}
      }

    },

    data: () => ({
      fav: true,
      menu: false,
      message: false,
      hints: true,
    }),
  
}
</script>

<style>
.whmy {
  height: 80vh;
}
</style>