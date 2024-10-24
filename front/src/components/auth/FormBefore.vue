<template>

        <v-card
        class="flex-grow-1"
        >
            <v-card-title class="bord">
                <v-col class="pa-0">
                    Проверка почты 
                </v-col>
                <v-col
                    class="pa-0 flex-grow-0"
                >
                    <v-btn
                        icon
                        @click.prevent="$emit('chView', {value: 'login'})"
                    >
                        <v-icon
                            class="ml-1"
                            color="icons"
                        >
                            mdi-rotate-45 mdi-plus
                        </v-icon>
                    </v-btn>
                </v-col>
            </v-card-title>
            <v-card-actions class="flex-col">
                <v-form class="flex-row">
                    <v-col
                        class="pr-0 align-self-center"
                        lg=2
                        sm=12
                    >
                        <h6
                            class="login"
                        >
                            Лотус
                        </h6>
                    </v-col>
                    <v-col
                        lg=10
                        sm=12
                    >
                        <v-card
                            outlined
                            light
                            height="40"
                        >
                            <v-text-field
                                v-model="email"
                                :error-messages="Lotus_Errors"                         
                                label="Введите почту Lotus"
                                @input="$v.email.$touch()"
                                @blur="$v.email.$touch()"
                                solo
                                flat
                                dense

                                
                            >
                            </v-text-field>
                            <!-- :hide-details="error-messages?true:false" -->
                        </v-card>
                    </v-col>
                    <v-col 
                        class="pr-0 align-self-center "
                        lg=2
                        sm=12
                    >
                       <h6 class="login ">Код</h6> 
                    </v-col>
                    <v-col
                        lg=10
                        sm=12
                    >
                    <v-card
                            outlined
                            light
                            height="40"
                        >
                        <v-text-field
                            v-model="lotus_password"
                            :error-messages="Numeral_Errors"  
                            label="Введите код"
                            placeholder="Введите код"
                            :disabled="dis_key"
                            @input="$v.lotus_password.$touch()"
                            @blur="$v.lotus_password.$touch()"
                            hide-details="false"
                            solo
                            flat
                            dense
                        ></v-text-field>
                  
                    </v-card>
                    </v-col>
                </v-form>
                <v-col class="pt-4">
                    <v-row class="flex-grow-0 flex-col">
                        <v-col
                            class="align-self-center"
                            lg=6
                            sm=12
                        >
                            <v-btn
                                color="btns"
                                block
                                @click="btnin"
                            >
                            {{dis_key?'Получить код':'Войти на сайт'}}
                            </v-btn>
                        </v-col>
                    </v-row>      
                       <v-progress-linear v-show="loading"
                                                class="mt-2"
                                                height=10
                                indeterminate
                                color="btns"
                                ></v-progress-linear>                     
                </v-col>
            </v-card-actions>
         <v-snackbar
            v-model="statusReg"
            class="pt-15"
            :color='!done?"green darken-4":"red lighten-1"'
            top
        >
             {{ datas.data }}
            <template v-slot:action="{ attrs }">
                <v-btn
                    color="white"
                    text
                    v-bind="attrs"
                >
                Закрыть
                </v-btn>
            </template>
        </v-snackbar>
        </v-card>
</template>

<script>
import { validationMixin } from "vuelidate";
import { axiosClear } from '@/utils/api'

const numeral = (x) => /^[0-9]{6}$/.test(x);
const lotusmail = (x) => /^[^,]+$/i.test(x);
const lotusmaila = (x) => /^([А-Яа-яЁёa-zA-Z0-9\s]+[/]{1}[А-Яа-яЁёa-zA-Z0-9\s]+[/]{1}[А-Яа-яЁёa-zA-Z0-9\s]+)$/i.test(x);

export default {


    name: "before",
    
    mixins: [validationMixin],
    
    props: {
        registr: {
            type: Object,
            default: {
                        type:"",
                        text:[]
            }},
        datas: {
            type: Object,
            default: {
                        username:"",
                        password:"",
                        data:""
            },
        }
    },

     data() {
        return {
            loading:false,
            lotus_key:"",
            erroror: [],
            dis_key: true,
            email: null,
            lotus_password: "",
            done: true,
            message: "",
            username: "",
            password: "",
            message: "",
            statusReg: true
        }
    },

    validations: {
        email: { lotusmail, lotusmaila },
        lotus_password: { numeral }
    },


    mounted() {
        this.snack();
            

    },

    computed:{
       Lotus_Errors() {
            const errors = [];
            if (!this.$v.email.$dirty) return errors;
            !this.$v.email.lotusmail && errors.push("Не должно содержать запятую");
            !this.$v.email.lotusmaila && errors.push("Необходимо два слеша");
            return errors;
       },

        Numeral_Errors() {
            const errors = [];
            if (!this.$v.lotus_password.$dirty) return errors;
            !this.$v.lotus_password.numeral && errors.push("Должно содержать 6 цифр");
            return errors;
       },
    },

    methods: {

        snack() {
            this.message = 'Аккаунта нет в программе СУП. Подтвердите почту лотус'
        },

        async btnin() {
            this.dis_key?this.sendCode():this.sendConfirm()
        },

        async sendCode() {  
            console.log("SENDCODE");
            this.$v.email.$touch();  
            console.log(this.$v.email); 
            if (this.$v.email.$invalid) {
                this.$v.email.$touch();
                this.loading=false
                return
            }
            else {

                try {
                    this.loading=true
                    let key = await axiosClear.post('/auth/conf',{action: this.registr.type, email:this.email})
                    this.dis_key = false
                    console.log(key.data.secret);
                    this.loading=false
                    // this.lotus_password = key.data.secret
                }
                catch (error){
                    this.loading=false
                    this.message = error.response.data.detail 
                    this.$store.commit("auth/setStatusReg", true)               
                }
                
            }
        },
        async sendConfirm() {
            if (this.$v.lotus_password.$invalid) {
                this.$v.lotus_password.$touch();
                return
            }
            else {          
                this.loading=true
                    axiosClear
                    .post(`/auth/login?lotus_key=${this.lotus_password}`, {
                        username: this.datas.username,
                        password: this.datas.password,
                        email:this.email,
                        lotus_password:this.lotus_password
                    })
                    .then((req) => {
                        this.loading=false
                    this.$store.commit("auth/setToken", req.data.access_token)
                    localStorage.setItem("refresh_token", req.data.refresh_token)
                    localStorage.setItem("status_login", true);
                    this.$router.push({name: "Main"});
                    })
                    .catch((error) => {
                        console.log(error);
                        this.loading=false
                    })

                }
    }
        }
};
</script>

<style lang="scss">

.entranceBefor {
    min-width: 38vw;
}




.regform {
    gap:15px;
}

.grid {
    padding: 20%;
}

.v-messages__message {
    position: absolute;
}

@media (max-width: 1200px) {
    .grid {
        padding: 0;
    }

}

.form_before {
    width: 70%;

}

.snackbefor {
    align-items: center!important;
    padding-top: 40vh;
}


</style>