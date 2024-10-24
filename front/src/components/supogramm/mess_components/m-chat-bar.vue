<template>
    <div class="chatBar d-flex pa-1"
    @click="$emit('goChat', chatInf.id)"
    >
        <v-avatar
            :style="`background-color: ${'#' + getcolor()}`"
            size="46"
        >
            <span class="white--text text-h5">{{ getName() }}</span>
        </v-avatar>
        <div class="chatInfo ms-2">
            <div class="chatName">{{ chatInf.name }}</div>
            <!-- <div class="dopInfo overflow-hidden">{{ chatInf.lastmessage[chatInf.lastmessage.length - 1].text }}</div> -->
            <!-- <div class="dopInfo">{{ Array.isArray(chatInf.users)? 'Кол-во участников: ' + chatInf.users.length: 'Последнее посищение: ' + chatInf.last_seen }}</div> -->
        </div>
        <div class="informer ml-auto" v-show="unreadNumer > 0">
            <v-btn
                x-small
                disabled
                fab
                color="primary"
            >
                <span class="white--text">{{ unreadNumer }}</span>
            </v-btn>
        </div>
    </div>
</template>

<script>
export default {
    
    props: {
        chatInf: {
            type: Object,
            default: ()=>{}
        },

        unreadNumer: {
            type: Number,
            default: 0
        }
    },

    data() {
        return {
            chatColor: ''
        }
    },

    methods: {

        getcolor() {
           this.chatColor = Math.floor(Math.random()*16777215).toString(16); 
           return this.chatColor
        },

        getName() {
            let splitted = this.chatInf.name.split(' ')
            let i=0
            let shn=''
            while (i<2 && i<splitted.length) {
                    shn += splitted[i][0]
                    i++
            }

            return shn
        },


    },


}
</script>

<style scoped>

    .chatBar {
        /* border: 1px solid; */
        margin-bottom: .1em;
        cursor: pointer;
    }

</style>