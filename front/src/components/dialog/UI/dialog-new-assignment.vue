<template>
  <Cards
    :color="mycolor"
    :elevation= 0
    :ma="ma"
    class="dialog_new_assigment"
    :min_height="min_height"
  >
    <template #cards>
      <v-card-title class="py-0 px-1 mb-2 ">
        <span :class="text_height" class="mwight">
          {{ text }}
          <slot name="texts"></slot>
        </span>
      </v-card-title>
      <v-divider class="mb-1"></v-divider>
      <slot name="pass"></slot>
      <v-row
        class="overflow-auto overflow-x-hidden my-1 px-5"
      >
      <!-- :class="pa" -->
        <v-col
          
          class="d-flex flex-col"
        >
          <slot name="textarea"></slot>
        </v-col>
      </v-row>
      <v-divider class="mb-6 mt-1"></v-divider>
      <v-row class="align-self-end flex-grow-0">
        <v-col class="flex-grow-0 pr-0 pt-0">
          <slot name="btn1"></slot>
        </v-col>
        <v-col class="pt-0">
          <slot name="btn2"></slot>
        </v-col>
      </v-row>
    </template>
  </Cards>
</template>

<script>

export default {

    name:"DialogNewAssigment",

    data() {
      return {
        dialog:false
      }},

  props: {
    text: {
      type: String,
      default: ""
    },

    text_height: {
      type: String,
      default: 'text-h6'
    },

    pa: {
      type:String,
      default:'pa-0'
    },

    mycolor: {
      type:String,
      default:"inyand"
    },

      ma: {
        type:String,
        default:'ma-3'
      },
    min_height:{type:Number,
               default:0 }

  },
}
</script>

<style>
.mwight {
  width: 100%;
}
</style>