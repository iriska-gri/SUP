<template>
<v-list dense ref="level2" class="it2">
  <v-list-group
    :value="true"
    ref="collapsibleclose"
    @click="$emit('collapselist', {i: i, key: 'level2'})"
  >
      <!--  @click="collapselist(i, 'level2')" -->
        <v-icon
          v-if="mini"
          :class="mini?'pl-2':'pl-5'"
          :small="mini?false:true"
          slot="prependIcon"
          color="btns"
        >
          {{ item.icon }}
        </v-icon>
        <v-icon
          slot="appendIcon"
          x-small
          color="btns"
        >
          fas fa-chevron-down
        </v-icon>
        <template v-slot:activator >
          <v-list-item-title
            class="text-caption font-weight-normal text_menus--text"
            :class="{ hidden: mini }"
          >
         {{item.title}}
          </v-list-item-title>
        </template>

        <div
          v-for="item2 in item.sub"
          :key="item2.title"
          :class="!mini?'pl-5':'pl-2'"
        >
    
          <lists
            :icon="item2.icon"
            :title="item2.title"
            :links="item2.link"
            :mini="mini"
            :pl="'pl-1'"
            :f="true"
          />
        </div>
                            </v-list-group>
                        </v-list>

              

                                      
</template>

<script>
import Lists from '@/components/UI//Lists.vue'

export default {
  components: {
    Lists
  },
    name:'lists-group',

    props: {
    
      item: {
      type: Object,
      default: ()=>{}
    },
    mini: {
      type:Boolean,
      default:false
    },
    i: {
      type:Number,
      default:0
    }
    },



}
</script>

<style>
.v-list-group .v-list-group__header .v-list-item__icon.v-list-group__header__append-icon {
    min-width: 0px;
  }

.v-list-item {
  padding: 0px 8px;
}

.v-list {
    padding: 0px 0px;
}


.v-list-item--dense, .v-list--dense .v-list-item {
    min-height: 30px;
}
</style>