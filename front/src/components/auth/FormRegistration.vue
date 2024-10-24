<template>
    <div class="grid auth-main Form">
        <v-card
            light
            elevation="10"
            color="#FAFAFA"
            class="px-2 px-md-5 pb-4 ma-5 rounded"
        >
            <v-card-title class="bord pl-0 ">
                Регистрация
            </v-card-title>
            <v-container>
                <v-form class="row pt-2" ref="form" v-model="valid" @submit.prevent="submit">
                    <v-text-field
                        class="col-12 col-md-4 pt-5"
                        v-model="username"
                        :error-messages="usernameErrors"
                        light
                        label="Логин"
                        required
                        @input="$v.username.$touch()"
                        @blur="$v.username.$touch()"
                    ></v-text-field>
                    <v-text-field
                        autocomplete="new-password"
                        class="col-12 col-md-4 pt-5"
                        v-model="password"
                        :append-icon="show1 ? 'mdi-eye' : 'mdi-eye-off'"
                        light
                        :error-messages="passwordErrors"
                        label="Пароль"
                        required
                        :type="show1 ? 'text' : 'password'"
                        counter
                        @input="$v.password.$touch()"
                        @blur="$v.password.$touch()"
                        @click:append="show1 = !show1"
                    ></v-text-field>
                    <v-text-field
                        class="col-12 col-md-4 pt-5"
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
                    <v-text-field
                        class="col-12 col-md-4 pt-5"
                        v-model="first_name"
                        :error-messages="first_nameErrors"
                        light
                        label="Имя"
                        required
                        @input="$v.first_name.$touch()"
                        @blur="$v.first_name.$touch()"
                    ></v-text-field>
                    <v-text-field
                        class="col-12 col-md-4 pt-5"
                        v-model="last_name"
                        :error-messages="last_nameErrors"
                        light
                        label="Фамилия"
                        required
                        @input="$v.last_name.$touch()"
                        @blur="$v.last_name.$touch()"
                    ></v-text-field>
                    <v-text-field
                        class="col-12 col-md-4 pt-5"
                        v-model="middle_name"
                        :error-messages="middle_nameErrors"
                        light
                        label="Отчество"
                        required
                        @input="$v.middle_name.$touch()"
                        @blur="$v.middle_name.$touch()"
                    ></v-text-field>  
                    <v-text-field
                        class="col-12 col-md-6 pt-5"
                        v-model="innerphone"
                        light
                        required
                        :error-messages="innerphoneErrors"                         
                        label="Внутренний номер"
                        @input="$v.innerphone.$touch()"
                        @blur="$v.innerphone.$touch()"
                    ></v-text-field>
                    <v-text-field
                        class="col-12 col-md-6 pt-5"
                        v-model="phone"
                        :error-messages="phoneErrors"
                        light
                        label="Номер телефона"
                        required
                        @input="$v.phone.$touch()"
                        @blur="$v.phone.$touch()"
                    ></v-text-field>
                    <v-select
                        class="col-12 col-md-12 pt-5"
                        v-model="officein"
                        :items="sel_otdel.division"
                        label="Подразделение"
                        dense
                        :rules="[(v) => !!v || 'Выберете значение поля']"
                        @input="dis_otdel=false"
                    ></v-select>
                    <v-select
                        class="col-12 col-md-4 pt-5"
                        v-model="otdelin"
                        :items="sel_otdel.otdel"
                        :label="sel_otdel.label"
                        dense
                        :disabled="dis_otdel"
                        :rules="[(v) => !!v || 'Выберете значение поля']"
                        @input="dis_otdel=false"
                    ></v-select>
                    <v-select
                        class="col-12 col-md-4 pt-5"
                        v-for="[key, val] of Object.entries(sel_filters)"
                        :key="key"
                        :v-model="key"
                        :items="val.spisok"
                        :label="val.label"
                        dense
                        :disabled="dis_otdel"
                        :rules="[(v) => !!v || 'Выберете значение поля']"
                    ></v-select>
                    <div v-if="erroror.length>0" class="col-12"
                        style="position:absolute; bottom: 0; z-index:2; left: 0">
                        <v-alert 
                            dismissible
                            border="bottom"
                            type="error"
                        >
                            {{errtext()}}                         
                        </v-alert>
                    </div>
                    <div class="col-6 pt-0">
                        <v-btn block elevation="3" type="submit">
                            Отправить
                        </v-btn>
                    </div>
                    <div class="col-6 pt-0">
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

const latin = (x) => /^[A-za-z]+$/i.test(x);
const cyrillic = (x) => /^[А-Яа-яЁё]+$/i.test(x);
const passwordRule = (x) => /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).*$/.test(x);
const telephonenub = (x) => /^(\s*)?(\+)?([- _():=+]?\d[- _():=+]?){1,20}(\s*)?$/.test(x);


export default {

    name: "register",
    
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
            valid: false,
            erroror: [],
            show1: false,
            show2: false,
            username: "qwerty",
            password: "PASsw0rd",
            confirmPassword: "PASsw0rd",
            last_name: "",
            first_name: "",
            middle_name: "",
            innerphone: "1",
            phone: "1",
            officein: "",
            sel_division: [],
            otdelin: "",
            sel_otdel: {division:[], otdel: [], label:""}, 
            position: "",
            rank: "",
            sel_filters: {position:{spisok:[], label:"Должность", model:""}, rank:{spisok:[], label:"Чин", model:""}},
            dis_otdel: true,
        
        }
    },
    validations: {
        username: { required, latin },
        password: { required, minLength: minLength(8), passwordRule },
        confirmPassword: {
            required,
            minLength: minLength(8),
            sameAs: sameAs("password"),
        },
        last_name: { required, cyrillic },
        first_name: { required, cyrillic },
        middle_name: { required, cyrillic },
        innerphone: { telephonenub },
        phone: { telephonenub }
            },

    computed: {
        innerphoneErrors() {
            const errors = [];
            if (!this.$v.innerphone.$dirty) return errors;
            !this.$v.innerphone.telephonenub && errors.push("Поле должно содержать номер телефона");
            return errors;
        },
        phoneErrors() {
            const errors = [];
            if (!this.$v.phone.$dirty) return errors;
            !this.$v.phone.telephonenub && errors.push("Поле должно содержать номер телефона");
            return errors;
        },
        usernameErrors() {
            const errors = [];
            if (!this.$v.username.$dirty) return errors;
            !this.$v.username.required && errors.push("Обязательное поле");
            !this.$v.username.latin &&
                errors.push("Поле должно содержать только латинские буквы");
            return errors;
        },

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
        last_nameErrors() {
            const errors = [];
            if (!this.$v.last_name.$dirty) return errors;
            !this.$v.last_name.required && errors.push("Обязательное поле");
            !this.$v.last_name.cyrillic &&
                errors.push("Поле должно содержать только русские буквы");
            return errors;
        },
       Lotus_Errors() {
            const errors = [];
            if (!this.$v.first_name.$dirty) return errors;
            !this.$v.first_name.required && errors.push("Обязательное поле");
            return errors;
       },
        first_nameErrors() {
            const errors = [];
            if (!this.$v.first_name.$dirty) return errors;
            !this.$v.first_name.required && errors.push("Обязательное поле");
            !this.$v.first_name.cyrillic &&
                errors.push("Поле должно содержать только русские буквы");
            return errors;
        },
        middle_nameErrors() {
            const errors = [];
            if (!this.$v.middle_name.$dirty) return errors;
            !this.$v.middle_name.required && errors.push("Обязательное поле");
            !this.$v.middle_name.cyrillic &&
                errors.push("Поле должно содержать только русские буквы");
            return errors;
        },
    },


    async mounted() {
        const res = await axiosClear.post('filters/free',[{
            "division__otdel": {"name": "name", "sort": "name", "related_name":"division__otdel"},
            "position":{"name": "name", "sort": "id"},
            "rank": {"name": "name", "sort": "id"}
        }])
        this.sel_division = res.data.division__otdel
        for (let [key, val] of Object.entries(this.sel_division)) {
            this.sel_otdel.division.push(val.name)
            
        }
        for (let [key, val] of Object.entries(res.data)) {
            if (key != 'division__otdel')
                {
                    this.sel_filters[key].spisok=val 
                }
        }
        const emailreg = this.registr.email.split(" ")
        this.first_name = emailreg[0]
        this.middle_name = emailreg[1]
        const lastregO = emailreg[2].split("/")
        this.last_name = lastregO[0]
    },

    watch: {
        officein(val) {
            this.sel_otdel.otdel = []
            this.sel_otdel.label = ""
            let gg = this.sel_division.find((e)=> e.name==val).otdels
            for (let [key, val] of Object.entries(gg)) {
                this.sel_otdel.otdel.push(val.name)        
            }
            this.sel_otdel.label = val=='ФНС'?"Управление":"Отдел"
        }
    },

    methods: {
        errtext(){
            return this.erroror.map((e)=>{return e}).join(", ")

        },
        submit() {
            // console.log(this.registr.lotus_key);
            this.$refs.form.validate()
            if (this.$v.$error  || this.$v.$invalid || !this.valid) {
                this.$v.$touch();
                return
            }
            else {
                this.erroror=[]
                axiosClear.post(`/auth/register?lotus_key=${this.registr.lotus_key}`, {
                    username: this.username,
                    password: this.password,
                    first_name: this.first_name,
                    last_name: this.last_name,
                    middle_name: this.middle_name,
                    innerphone: this.innerphone,
                    phone: this.phone,
                    email: this.registr.email,
                    otdel: {name: this.otdelin},
                    position: {name: this.position}, 
                    rank: {name: this.rank}

                })
                .then(response => {
                    this.$emit('chView', {value: 'login', status: true},
                    {error: "Регистрация прошла очень успешно, Поздравляем, возьмите с полки пирожок"})
                })
                .catch(error => {
                    this.error = error.response.data.detail
                    this.statusReg = true                  
                })
            }
        },
        clear() {
            this.$v.$reset();
            this.username = "";
            this.email = "";
            this.password = "";
        },
    },
};
</script>

<style lang="scss">

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

.rounded {
    width: 100%;
}

</style>