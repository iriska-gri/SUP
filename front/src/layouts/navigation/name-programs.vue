<template>
    <v-list>
      <v-list-item
     
        :class="mini?'pl-3':''"
      >
        <v-list-item-avatar
          @click.stop=" $emit('minis')"
          size="30"
        >
          <img
            style="cursor:pointer"
            :src="require('@/assets/FNS-logo-header.png')"
          />
        </v-list-item-avatar>
        <!-- class="logo-title flex-row flex-nowrap" -->
        <v-list-item-title  class="logo-title flex-row flex-nowrap justify-center">
        
          <div
            :class= "!$vuetify.theme.dark?'font-weight-medium':''"
            class="mr-1 text_menus--text"
          >
            СУП
          </div>
          <div
            class="text-caption text_menus--text"
            :class= "!$vuetify.theme.dark?'font-weight-medium':''"
          >
            {{ $store.getters.appVersion }}
          </div>
        </v-list-item-title>
        <v-btn
          :rounded="false"
          icon
          @click.stop=" $emit('minis')"
          x-small
        >
          <MyIco
            size="x-small"
            icons = 'fa-angle-double-left'
          />
        </v-btn>
        
      </v-list-item>
    </v-list>
</template>

<script>
export default {
  props:{
    mini: {
        type:Boolean,
        default:false},
  }


}
</script>

<style>
.logo-title :first-child {
  font-size: 1.5rem;
  font-weight: bold;
}
.logo-title :first-child, .logo-title :nth-child(2), .logo-title :nth-child(3)  {
   
  color: var(--v-btns-base)!important;
}
.logo-title :nth-child(2) {
  font-size: 0.5em!important;

    line-height: 0.9rem;
}
</style>