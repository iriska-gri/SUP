<template>
       
            <v-col
                class="d-flex flex-col"
                >
                <v-row class="align-self-center entrance">
                    <v-col
                        class="align-self-center d-flex flex-col heightvol"
                    >
                    <Form-before
                        v-if="nowView == 'before'"
                        :registr='registrat'
                        :datas='user'
                        @chView="changeView"
                    ></Form-before>
                    <Form-login
                        v-else-if="nowView == 'login'"
                        @chView="changeView"
                        @error="error"
                    ></Form-login>
                    <Form-registration
                        :registr='registrat'
                        v-else-if="nowView == 'register'"
                        @chView="changeView"
                    ></Form-registration>
                    <Form-restore
                        :user='user'
                        :registr='registrat'
                        v-else-if="nowView == 'restore'"
                        @chView="changeView"
                    >
                    </Form-restore>
                     <v-snackbar
            v-model="errorview"
            class="pt-15"
            color="red lighten-1"
            top
            multi-line
        ><h4>
            {{ texterror.header}}
        </h4>
                

            <h5>
                {{ texterror.text}}
            </h5>


       
            
            <template v-slot:action>
                <v-btn
                    color="white"
                    text                  
                    @click="closeit"
                >
                Закрыть
                </v-btn>
            </template>
        </v-snackbar>
                    </v-col>
                </v-row>
            </v-col>
   
</template>

<script>
import FormBefore from "@/components/auth/FormBefore.vue";
import FormLogin from "@/components/auth/FormLogin.vue";
import FormRegistration from "@/components/auth/FormRegistration.vue";
import FormRestore from "@/components/auth/FormRestore.vue";

export default {
    name: 'AuthView',
    components: {
      FormLogin,
      FormRegistration,
      FormBefore,
      FormRestore
    },

    data: () => ({
        errorview:false,
        nowView: "login",
        statusReg: false,
        texterror:{text:"",header:""},
        user:{},
        registrat: []
    }),


    methods: {
        closeit(){
            this.errorview=false
            this.texterror = {text:"",header:""}
        },
        error(val){
            this.errorview=true
            this.texterror = val

        },

        changeView({value, status=false, datas={}} = {}, registrat) {
            this.nowView = value;
            this.statusReg = status;
            this.user=datas;
            this.registrat = registrat

        },
    },
    
};
</script>

<style lang="scss">
.entrance {
    max-width: 550px;
    min-width: 550px;
}

.heightvol {
    min-height: 29.5%;
}

.bord {
    border-bottom: 1px solid var(--v-lines_border-base);
    font-size: 1.25rem!important;
}

.auchlight {

    background: rgb(2,0,36)!important;
    background: linear-gradient(333deg, rgba(2,0,36,1) 0%, rgba(9,9,121,1) 35%, rgba(0,212,255,1) 100%)!important;
}

.auchdark {
// background: rgb(255,254,133)!important;
// background: linear-gradient(143deg, rgba(255,254,133,1) 0%, rgba(119,71,43,1) 50%, rgba(2,0,36,1) 97%)!important;
    background:rgb(162,88,35)!important;
    background: linear-gradient(143deg, rgba(162,88,35) 0%, rgba(119,71,43,1) 27%, rgba(2,0,36,1) 97%)!important;
}

.pinks {
    background: rgb(2,0,36)!important;
    background: linear-gradient(90deg, rgba(2,0,36,1) 0%, rgba(121,9,103,1) 35%, rgba(0,212,255,1) 100%)!important;
}
</style>