<template>
  <v-row class="flex-grow-0 pt-2 pb-1 mt-0">
      <v-col 
        v-if="textOn"
        xl="4"
        lg="4"
        md="6"
        sm="6"
        cols="6"
        class="py-1"
      >
        <strong>
          {{addrem.text}}
        </strong>

          <v-icon
            color="open_icons"
            class="wicon"
            small
            @click="$emit('addRows', addrem.field)"
          >
            mdi-plus
          </v-icon>
      </v-col>
      <v-col class="flex-col pa-0 d-flex">
        <v-row
          v-for="(val, key) in newproject.info[addrem.field]"
          :key="key"
          class="ma-0"
        >
          <v-col class="py-1">
            <v-textarea 
              v-model="newproject.info[addrem.field][key]"                                        
              auto-grow
              rows=0
              dense
              flat
              class="mt-0 pt-0 pb-2"
              hide-details
            />
          </v-col>
          <v-col class="py-1 px-1 pt-2 flex-grow-0 align-self-center">
            <MyIco
              @click="$emit('remove', {field:addrem.field, key})"
              icons = 'mdi-minus'
              color="close_icons"
              size="small"
            />
          </v-col>
        </v-row>
      </v-col>
    </v-row>
</template>

<script>

export default {
    name: "rowsAddremove",

    props: {
          newproject: {
            type:Object,
            default:()=>{}
          },

          addrem: {
            type:Object,
            default:()=>{return {field: '', text: 'Пусто'}}
          },

          textOn: {
            type:Boolean,
            default:true
          }
        
    },

   
}
</script>

<style>

</style>