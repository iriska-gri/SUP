<template>
    <v-alert
        :border="mess.sender.id == getUser.id?'right':'left'"
        colored-border
        :color="mess.sender.id == getUser.id?'chatik':'chatiknotme'"
        elevation="0"
        style="border: 1px solid gainsboro;"
        class="pa-3 rounded m-messege-cloud"  
    >
        <v-row
            class="rounded"
            :class="mess.sender.id == getUser.id?'chatinfo':'chatinfonotme'"
        >
            <v-col
                v-if="mess.sender.id == getUser.id"
                class="flex-grow-0 pt-1 pl-1"
            >
                <MyIco
                  @click="delmessager(mess)"
                  icons ="mdi-close-box"
                  color="chatico"
                /> 
            </v-col>
            <v-col
                class=" card-text pt_date"
                :class="mess.sender.id == getUser.id?'text-end pr-0':'text-start flex-grow-0 order-2 pl-0'"
            >
                {{ getDate(mess.messagetime) }}
            </v-col>
            <v-col
                class="text-end flex-grow-0 text-nowrap pt-1"
                :class="mess.sender.id == getUser.id?'pl-2 pr-4':'pr-2 pl-4'"
            >
                <span
                    class="pointer font-weight-medium card-text"
                    @click="$emit('userclicked', mess.sender.id)"
                >
                    {{ mess.sender.sn }} {{ reNames }}.
                </span>
            </v-col>
        </v-row>
        <v-row class="my-0">
            <v-col class="pa-0 pt-1">
                <v-divider class="chatdevider"></v-divider>
            </v-col>
        </v-row>
        <v-row class="mt-0 chatmess rounded rounded-t-0 card-text">
            <v-col 
                class="messwight"
                :class="mess.sender.id == getUser.id?'pl-2 text-end borderright':'pr-2 borderleft'"
            >
                {{ mess.text }}  
            </v-col>
        </v-row>
    </v-alert>
</template>

<script>
import { bus } from "@/main";
import { createNamespacedHelpers } from "vuex";
const auth = createNamespacedHelpers('auth')
import func from '@/components/supogramm/mess_layouts/func'
import uf from '@/utils/universal_functions'

export default {

    name:"m-messege-cloud",

    mixins:[func, uf],
    
    props: {
        chatid:{
            type:Number,
            default:0
        },
        mess: {
            type: Object,
            default: () => {return {id:0,chat:{id:0}}}
        },
    },

    computed: {

        ...auth.mapGetters(["getUser", ]),

        reNames() {
            let sn = this.mess.sender.givenName.split(' ')
            return sn[0][0]
        },
    },

    methods: {

        delmessager(val){
            bus.$emit("delmessager",{id:val.id,chat:this.chatid})
        },

    }
}
</script>

<style>

.borderleft {
    border-left: 9px solid gainsboro;
    border-radius: 5px;
}

.borderright {
    border-right: 9px solid gainsboro;
    border-radius: 5px;
}

.pt_date {
    padding-top: 6px !important;
}

 .messwight {
    width: 50px;
 }

</style>