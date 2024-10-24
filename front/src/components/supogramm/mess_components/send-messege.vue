<template>
    <div class="rounded inputpad flex-grow-1 flex-col">
        <v-row class="overflow-auto pr-3 ">
            <v-col id="enterAmessage" class="pr-0">
                <v-textarea
                    id="sendmessage"
                    @keypress.enter.prevent="sendmessage"
                    v-model="textmessage"
                    class="py-0 my-0 overflow-auto inputext"
                    background-color= "inyand"
                    auto-grow
                    rows="0"
                    solo
                    flat
                    hide-details
                    placeholder="Введите сообщение"
                >
                </v-textarea>
            </v-col>
            <v-col class="flex-grow-0 pl-1 pr-2 align-self-center">
                <MyIco
                    @click="sendmessage"
                    icons = 'mdi-send'
                    color ="btns"
                    :disabled="textmessage==null || textmessage.length==0"
                />
            </v-col>
        </v-row>
    </div>
</template>

<script>
import { bus } from "@/main";

export default {

    name:"sendMessege",
    
    data(){
        return{
            textmessage:null
        }
    },

    props:{
        chat:{
            type: Object,
            default: ()=> {return {users:[{id:''}],admin:{id:0}}}
        }
    },

    methods:{

        sendmessage(){    
            if (this.textmessage!=null || this.textmessage.length>0) {
                bus.$emit("sendmessage",{message:this.textmessage,id:this.chat.id})
                this.textmessage=null
            }
        },
    },
}
</script>

<style>

#sendmessage {
    max-height: 80px;
    overflow: auto;
}

#sendmessage .v-textarea :nth-child(1) {
    padding-top:7px;
}

#enterAmessage > .v-text-field.v-text-field--solo .v-input__control {
    min-height: 33px;
}

#enterAmessage > .v-textarea.v-text-field--enclosed.v-text-field--single-line:not(.v-input--dense) textarea {
    margin-top: 2px;
}

.inputpad {
    border: 1px solid var(--v-scrollbar-base);
}

</style>