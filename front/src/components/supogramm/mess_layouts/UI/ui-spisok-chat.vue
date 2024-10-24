<template>
<div >
 
    <v-list
        dense
        flat
        class="inyand"
    >
        <template>                
            <div
                v-for="mychat in mychats"
                :key="mychat.id"
            >

            <v-tooltip bottom>
                            <template v-slot:activator="{ on, attrs }">
                <v-list-item
                    @click="$emit('activeChat', mychat.id)"
                    class="px-0"
                    v-bind="attrs"
                                        v-on="on"
                >
                    <v-list-item-avatar
                        class="mx-0 align-self-center"
                        height=20
                        width=20
                    >
                    <!-- :class= -->
                        <v-avatar 
                            :color="lightdark(mychat.level, $vuetify.theme.dark)"
                            size=20
                        >
                            <span class="white--text text-chat">{{ getName(chatTitle(mychat)) }}</span>
                        </v-avatar> 
                    </v-list-item-avatar>
                    <div
                        v-show="unreadNumer[mychat.id] > 0"
                        class="px-2 rounded-circle"
                        style="position:absolute; left:10px; top:30px; background:red; z-index:1000 "
                    > 
                        <span class="text-caption white--text">
                            {{ unreadNumer[mychat.id] }}
                        </span>
                    </div>
                    <v-list-item-content class="align-self-center pa-0">

                                <v-list-item-title class="ma-0">

                                    <span class="text-subtitle-2"
                                     
                                    >
                                        {{ chatTitle(mychat) }}
                                    </span> 
                          
                                </v-list-item-title>

                        <v-list-item-subtitle>
                            <span class="text-caption">
                                {{ mychat.lastmessage.length? mychat.lastmessage[mychat.lastmessage.length - 1].text.slice(0, 20) + (mychat.lastmessage[mychat.lastmessage.length - 1].text.length>20?"...": ''):'' }}
                            </span>               
                        </v-list-item-subtitle>
                    </v-list-item-content>
                </v-list-item>
            </template>
                                <span>{{ chatTitle(mychat) }}</span>
                        </v-tooltip>
                <v-divider></v-divider>
            </div>
        </template>
    </v-list>
</div>
</template>

<script>

import func from '../func'
import { createNamespacedHelpers } from "vuex";
const auth = createNamespacedHelpers('auth')

export default {
    name:"ui-spisok-chat",
    mixins:[func],

    props: {
        mychats: {
            type: Array,
            default: ()=>[]
        },
        unreadNumer: {
            type: Object,
            default: ()=>{}
        },
    },

     computed: {

    ...auth.mapGetters(["getUser", ]),
     },

}
</script>

<style>
.pinkslight {
background: rgb(2,0,36);
background: linear-gradient(90deg, rgba(2,0,36,0.7791491596638656) 0%, rgba(121,9,103,1) 60%, rgba(121,118,9,0.6979166666666667) 100%);
}

.pinksdark {
background: rgb(255, 255, 255);
background: linear-gradient(90deg, rgba(255, 255, 255, 0.779) 0%, rgba(121,9,103,1) 60%, rgba(121,118,9,0.6979166666666667) 100%);
}

.grinlight {
    background: rgb(0,36,1)!important;
    background: linear-gradient(90deg, rgba(101, 167, 101, 0.779) 0%, rgba(9,121,101,1) 60%, rgba(65, 63, 5, 0.698) 100%)!important;
    ;
}

.grinblack {
    background: rgb(204, 221, 205)!important;
    background: linear-gradient(90deg, rgba(187, 207, 188, 0.779) 0%, rgba(9,121,101,1) 60%, rgba(121,118,9,0.6979166666666667) 100%)!important;
    ;
}

.redlight {
    background: rgb(240,37,37)!important;
    background: linear-gradient(90deg, rgba(240,37,37,0.7791491596638656) 0%, rgba(121,54,9,1) 60%, rgba(50,14,4,0.6979166666666667) 100%)!important;
}

.reddark {
    background: rgb(240,37,37)!important;
    background: linear-gradient(90deg, rgba(230, 60, 60, 0.779) 0%, rgb(102, 7, 7) 60%, rgba(136, 77, 60, 0.698) 100%)!important;
}
</style>