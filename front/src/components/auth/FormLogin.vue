<template>
        <v-card
            class="flex-grow-1"
        >
            <v-card-title class="bord">
                <v-col class="pa-0">
                    Вход    
                </v-col>
                    <ToggleTheme
                        class="flex-grow-0"
                    />
            </v-card-title>
            <v-card-actions class="flex-col d-flex">
                <v-form
                    class="flex-row"
                    lazy-validation
                >
                    <v-col
                        class="pr-0 align-self-center"
                        lg=2
                        sm=12
                    >
                       <span 
                                
                class="grey--text grey--text h6">
                            Логин
                        </span>
                    </v-col>
                    <v-col
                        lg=10
                        sm=12
                    >
                        <v-card
                            outlined
                            light
                            height="40"
                            :color="this.$vuetify.theme.dark?'white':''"
                        >
                            <v-text-field
                            :disabled="loading"
                                background-color='inputcolor'
                                append-icon="mdi-account"
                                v-model="username"
                                @keypress.enter="submitForm"
                                solo
                                flat
                                dense
                                
                                required
                                loader-height="10px"
                                @input="$v.username.$touch()"
                                @blur="$v.username.$touch()"
                                :error-messages="Logins_Errors" 
                            ></v-text-field>
                        </v-card>
                    </v-col>
                    <v-col 
                        class="pr-0 align-self-center "
                        lg=2
                        sm=12
                    >
                                             <span 
                                
                class="grey--text h6">
                            Пароль
                        </span>
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
                            :disabled="loading"
                                background-color='inputcolor'
                                v-model="password"
                                required
                                :append-icon="show ? 'mdi-eye' : 'mdi-eye-off'"
                                :type="show ? 'text' : 'password'"
                                @click:append="show = !show"
                                @keypress.enter="submitForm"
                                solo
                                flat
                                dense
                                @input="$v.password.$touch()"
                                @blur="$v.password.$touch()"
                                :error-messages="PasswordErrors" 
                            ></v-text-field>
                        </v-card>
                    </v-col>
                </v-form>

                <v-col class="pt-4">
                    <v-row class="flex-grow-0  flex-col d-flex">
                        <v-col
                            class="align-self-center"
                            lg=12
                            sm=12
                        >
                  
                    <v-btn
                        block
                        @click="submitForm"
                        color="inyand--text btns"
                        :disabled="loading"
                        title = "Войти"
                    >Войти</v-btn>
                        
                            <!-- <v-btn
                               
                                :dark="!$vuetify.theme.dark?true:false"
                                light
                                block
                                @click.prevent="submitForm"
                            >
                                Войти
                            </v-btn> -->
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
        </v-card>
   
</template>


<script>
import { axiosClear } from '@/utils/api'
import ToggleTheme from '../UI/ToggleTheme.vue';
import { required } from "vuelidate/lib/validators";
import { validationMixin } from "vuelidate";


const logins = (x) => /^([0-9]+[-]{1}[0-9]+[-]{1}[0-9]+)$/i.test(x);
const passwordRule = (x) => /^.*(?=.*\d).*$/.test(x);
const passwordRuleEight  = (x) => /^.*(?=.{8,}).*$/.test(x);
const passwordRuleLatin  = (x) => /^.*(?=.*[a-zA-Z]).*$/.test(x);

export default {

    name: "login",

    mixins: [validationMixin],

    components: {
        ToggleTheme,
  
     },


    data: () => ({
        loading:false,
        username: "",
        password: "",
        show: false,
        message: "",
        done: true,
    }),

    validations: {
        username: { required, logins },
        password: { required, passwordRule, passwordRuleEight, passwordRuleLatin }
      
    },

    computed:{
       Logins_Errors() {
            const errors = [];
            if (!this.$v.username.$dirty) return errors;
            !this.$v.username.required &&
                errors.push("Обязательное поле");    
            !this.$v.username.logins &&
                errors.push("Логин имеет вид 0000-00-000");
            return errors;
       },
        PasswordErrors() {
            const errors = [];
            if (!this.$v.password.$dirty) return errors;
            !this.$v.password.required && errors.push("Обязательное поле");    
            !this.$v.password.passwordRuleLatin &&
                errors.push("Пароль должен содержать латинские символы");        
            // !this.$v.password.passwordRule &&
            //     errors.push("Пароль должен содержать минимум одну цифру");
            // !this.$v.password.passwordRuleEight &&
            //     errors.push("Пароль должен содержать 8 символов"); 
            return errors;
        },
    },
    methods: {
        submitForm() {
                    if(!this.$v.username.required || !this.$v.password.required){
                            this.$v.$touch()
                    }
                        
                    else{
                        this.loading=true

                         axiosClear
                    .post("/auth/login", {
                        username: this.username,
                        password: this.password,
                    })
                    .then((req) => {
                    this.loading=false
                    this.$store.commit("auth/setToken", req.data.access_token)
                    localStorage.setItem("refresh_token", req.data.refresh_token)
                    localStorage.setItem("status_login", true);
                    this.$router.push({name: "Main"});
                    })
                    .catch((error) => {
                        if (error.response.status==404){
                            this.loading=false
                            this.$emit('chView', {value: 'before', datas: {username: this.username, password: this.password, data: error.response.data.detail}},{type:'create'})
                        }
                        else if(error.response.status==401)
                        {
                            this.loading=false
                            this.$emit('error', {header:"Ошибка авторизации", text:"Логин-пароль введены неверно или учетная запись заблокирована"}  
                            )
                        }
                    })



                    }
                   
                
                    

        }

    }
};
</script>

<style lang="scss">


// .login {
//     color: var(--v-spisok-base) ;
//     font-weight: normal;
// }


</style>











