<template>
<div class="ui-btn-new-chat">
    <v-menu
        :close-on-content-click="false"
    >
        <template v-slot:activator="{ on, attrs }">
            <v-icon
                small
                v-bind="attrs"
                v-on="on"
                color="btns"
            >
                mdi-menu
            </v-icon>
        </template>
        <Cards
            color="inyand"
            :ma="'ma-0'"
        >
            <template #cards>
                <DialogNewAssigment
                    text="МЕНЮ"
                    class="ui-btn-new-chat___dialognewassigment"
                    :text_height="'text-caption'"
                    :pa="'pa-0'"
                    mycolor="'main_theme'"
                >
                    <template #textarea>
                        <v-list
                            dense
                        >
                            <v-list-item-group        
                               
                            >  
                                <v-list-item
                                    v-for="(item, i) in creatormenu"
                                    :key="i"
                                    @click="dialogger(i)"
                                >
                                    <v-list-item-icon class="ma-0 my-1 mr-2 ml-1">
                                        <MyIco
                                            :icons = item.icon
                                        />
                                    </v-list-item-icon >
                                    <v-list-item-content>
                                        <v-list-item-title>
                                            {{item.text}}
                                        </v-list-item-title>
                                    </v-list-item-content>
                                </v-list-item>
                            </v-list-item-group>
                        </v-list>
                  </template>
                </DialogNewAssigment>
            </template>
        </Cards>
    </v-menu>
    <v-dialog v-model="dialog"
        max-width="500"
        hide-overlay
    >
        <ui-m-dialog-global-search
            v-if='dialogtype==0'
            @createchat="createchat"
            ref="usersearch"
        />
        <ui-m-dialog-gruppa
         v-if='dialogtype==1'
            @createchat="createchat"
            ref="usersearch"
        />
    </v-dialog>
</div>
   

                                
</template>

<script>
import { createNamespacedHelpers } from "vuex";
import UiMDialogGlobalSearch from '@/components/supogramm/mess_components/UI/ui-m-dialog-global-search.vue';
import UiMDialogGruppa from '@/components/supogramm/mess_components/UI/ui-m-dialog-gruppa.vue';

const auth = createNamespacedHelpers('auth')

export default {

    name: "ui-btn-new-chat",

    components: {
        UiMDialogGlobalSearch,
        UiMDialogGruppa
    },


data() {
        return{
            creatormenu:[{text:"Начать разговор",icon:"mdi-chat-plus-outline"},{text:"Новая группа",icon:"mdi-forum-outline"}],      
            dialog:false,
            dialogtype:0
        }  
    },
   
    methods: {

        ...auth.mapGetters(["getUser"]),
        dialogger(it){
            this.dialogtype=it
            this.dialog=true

        },


        createchat(val){
            this.dialog=false
            this.$refs.usersearch.users=[]
            this.$refs.usersearch.groupName=""
            this.$emit("createchat",val)
        },


    },

}
</script>

<style>

</style>