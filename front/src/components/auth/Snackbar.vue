<template>
  <v-snackbar
            v-model="statusReg"
            class="pt-15"
            :color='done?"green darken-4":"red lighten-1"'
            top
        >
             {{ message }} 
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
</template>

<script>

export default {

    name: 'Snackbar',

    props: {
        message: {
            type: String,
            default: ""
        },

        done: {
            type: Boolean,
            default: true
        }
        
 
    },

     data() {
        return {
                statusReg : false
        }
     }, 

    computed: {

        statRegResult() {
            this.statusReg = this.$store.getters['auth/getStatusReg']
            this.$store.commit("auth/setStatusReg", false)  
            return this.$store.getters['auth/getStatusReg']
        }
    }

}

    
// computed: {
//   message: {
//     get () {
//       return this.$store.getters['auth/getStatusReg']
//     }

//   }
// }

  
// computed {
//     get statusReg() {
//         console.log('get');
//         return this.statusReg

//     },

//     set statusReg(value) {
//         console.log('set', value);

//     }
// }
   
// methods: {
//           statReg(){
//             this.$emit("statReg")
//         }
// },

          
        // }
    
// }   


</script>

<style>

</style>