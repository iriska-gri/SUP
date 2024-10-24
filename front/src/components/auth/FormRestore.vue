<template>
    <div class="grid auth-main Form">
        
        <v-card
            light
            elevation="10"
            color="#FAFAFA"
            class="px-2 px-md-5 pb-4 ma-5 rounded-lg"
        >
            <v-card-title class="bord">Восстановление пароля</v-card-title>
          
            <v-container>
                <v-form class="row pt-2">
                
                    
                    <v-text-field
                        autocomplete="new-password"
                        class="col-12 col-md-6"
                        v-model="password"
                        :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                        light
                        :error-messages="passwordErrors"
                        label="Новый Пароль"
                        required
                        :type="show1 ? 'text' : 'password'"
                        counter
                        @input="$v.password.$touch()"
                        @blur="$v.password.$touch()"
                        @click:append="show1 = !show1"
                    ></v-text-field>
                    <v-text-field
                        autocomplete="new-password"
                        class="col-12 col-md-6"
                        v-model="confirmPassword"
                        :append-icon="show2 ? 'mdi-eye' : 'mdi-eye-off'"
                        light
                        :type="show2 ? 'text' : 'password'"
                        counter
                        :error-messages="confirmPasswordErrors"
                        label="Повторите пароль"
                        required
                        @input="$v.confirmPassword.$touch()"
                        @blur="$v.confirmPassword.$touch()"
                        @click:append="show2 = !show2"
                    ></v-text-field>
                    
                   
                    
                    <div v-if="erroror.length>0" class="col-12"
                        style="position:absolute; bottom: 0; z-index:2; left: 0">
                      <v-alert 
                      dismissible
                      border="bottom"
                      type="error">
                        {{errtext()}}                         
                        </v-alert>
                    </div>
                    <div class="col-6">
                        <v-btn block elevation="3" @click="submit">
                            Изменить пароль
                        </v-btn>
                    </div>
                    <div class="col-6">
                        <v-btn
                            block
                            elevation="3"
                            @click.prevent="$emit('chView', {value: 'login'})"
                        >
                            Назад
                        </v-btn>
                    </div>
                </v-form>
                
            </v-container>
           
        </v-card>
    </div>
    
</template>

<script>
import { validationMixin } from "vuelidate";
import { required, minLength, sameAs } from "vuelidate/lib/validators";
import { axiosClear } from '@/utils/api'


const passwordRule = (x) =>
    /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).*$/.test(x);

export default {
    name: "restore",
    
    mixins: [validationMixin],


    props: {
        registr: {
            type: Object,
            default: {
                        lotus_key:"",
                        email:""
            },
        }
    },

     data() {
        return {
            erroror: [],
            show1: false,
            show2: false,
            password: "",
            confirmPassword: "",   
            email: "",    
            lotus_key: "" 
        }
    },

    validations: {
        
        password: { required, minLength: minLength(8), passwordRule },
        confirmPassword: {
            required,
            minLength: minLength(8),
            sameAs: sameAs("password"),
        },
        
    },

    computed: {        
        passwordErrors() {
            const errors = [];
            if (!this.$v.password.$dirty) return errors;
            !this.$v.password.required && errors.push("Обязательное поле");
            !this.$v.password.minLength &&
                errors.push("Пароль должен быть более 8 символов");
            !this.$v.password.passwordRule &&
                errors.push("Cтрочные и прописные латинские буквы, цифры");
            return errors;
        },
        confirmPasswordErrors() {
            const errors = [];
            if (!this.$v.confirmPassword.$dirty) return errors;
            !this.$v.confirmPassword.sameAs &&
                errors.push("Пароли не совпадают");
            return errors;
        },


       
    },
    methods: {
        errtext(){
            return this.erroror.map((e)=>{return e}).join(", ")

        },
        async submit() {
            try {
                let restor = await axiosClear.post('/auth/restore',{
                email: this.registr.email,
                lotus_key: this.registr.lotus_key,
                password: this.password
                })   
                this.$emit('chView', {value: 'login', status: true},
                            {done:"Пароль изменен"})
                }
                catch (error){
                    this.error = error.response.data.detail
                    this.statusReg = true
                        
                }        
        },
        clear() {
            this.$v.$reset();
            this.username = "";
            this.email = "";
        },

        backlog() {
            
        }
    },
};
</script>

<style lang="scss">

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


</style>