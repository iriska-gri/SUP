<template>
  <v-list-item-group>
    <div
      v-for="(item, i) in items"
      :key="i"
    >
      <lists
        v-if="!item.sub"
        :icon="item.icon"
        :title="item.title"
        :links="item.link"
        :mini="mini"
      />
      <v-divider v-if="!item.sub"></v-divider>
        <v-list
          dense
          v-else
        >
          <v-list-group                                                 
            :prepend-icon="item.icon"
            :value="true"
            ref="collapsibleclose"
          >
            <v-icon
              slot="appendIcon"
              x-small
              color="btns"
            >
              fas fa-chevron-down
            </v-icon>
            <template v-slot:activator>
              <v-list-item-title
                class="text_menus--text"
                :class="mini?'pl-2 text-button font-weight-black':'text-caption font-weight-normal'"
              >
                {{
                  mini?item.title.split(" ").map((e)=>{return e.length>1?e[0].toUpperCase():""}).join(""):item.title
                }}
              </v-list-item-title>
            </template>
            <div
              v-for="(item2, i) in item.sub"
              :key="i"
            >
              <lists
                v-if="!item2.sub"
                :icon="item2.icon"
                :title="item2.title"
                :links="item2.link"
                :mini="mini"
                @messengerview="messengerview"
              />
              <ListsGroup
                v-else
                :item="item2"
                :mini="mini"
                :i="i"
                @collapselist="collapselist"
              />
            </div>
          </v-list-group>
        </v-list>
    </div>
    <v-divider></v-divider>
    <lists
      :mini="mini"
      :icon="'mdi-forum'"
      title="ВатСУП"
      :link=false
      @messengerviews="messengerviews"
      :messengertotal="messengertotal"
    />
  </v-list-item-group>
</template>

<script>
import Lists from '@/components/UI//Lists.vue'
import ListsGroup from '@/components/UI/lists-group.vue'


export default {

  components: {
    Lists,
    ListsGroup

  },



  props: {
    messengertotal:{
      type:Number,
      default:0
    },
    items: {
        type: Array,
        default: ()=>[]
    },
    mini: {
      type:Boolean,
      default:false
    },
    messengerview:{
      type:Boolean,
      default:false
    
    }

},

    methods: {
      collapselist(datas) {
        this.$emit("collapselist", datas)
      },
      
      messengerviews() {        
        this.$emit("messengervi", this.messengerview)
      }



    }

}
</script>

<style>




</style>