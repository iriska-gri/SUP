<template>
    <v-col class="pb-3 pt-1 px-1">
        <layout-label
            :title="title"
            :disabled="disabled"
            class="text-nowrap "
        >            
            <div ref="mydiv">
            <v-autocomplete
                :items="items"
                :label="label"
                v-model="filt"
                multiple
                small-chips
                :disabled="disabled"
                solo
                dense
                :clearable="values.length > 0 ? true:false "
                hide-details="true"
                ref = "mySelector"
                class="my_auto "
                background-color="inputcolor"
                item-text="name"
            item-value="name"
            return-object
            >
            <template v-slot:prepend-item>
                <v-list-item ripple @click="toggle">
                    <v-list-item-action>
                        <v-icon
                            small
                            :color="values.length > 0 ? 'indigo darken-4' : ''"
                            >{{ icon }}</v-icon
                        >
                    </v-list-item-action>
                    <v-list-item-content>
                        <v-list-item-title>Выбрать все</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>
            </template>
            
            <template v-slot:selection="{ item, index }"
            
           >
                
                <v-chip
                color="primary"
                small
                 v-if="values?index <= aviablecalc(values):''">
                    <span>{{item.name.slice(0, 25)}} </span>
                </v-chip>
                
                
                    <!-- <template v-slot:activator="{ on }"> -->
                <custom-tooltip  v-if="values?index === aviablecalc(values)+1 && index >= 0:''" :content="values" :visible="tooltipvisible" >
                <span 
                                
                class="grey--text caption pointer"
                    >(+{{ values.length - 1 - aviablecalc(values) }} )</span
                >
                </custom-tooltip>
                    <!-- </template> -->
              
                <!-- других -->

            </template>
            
        </v-autocomplete>
        </div>
        </layout-label>
    <div><div class="d-flex px-3" id="counter" ref='counter'></div>
        <div class="d-flex" ref='total' id="total"></div>
        </div>
    </v-col>
    
</template>

<script>

// import CustomTooltip from "@/components/UI/CustomTooltip.vue"
import CustomTooltip from './CustomTooltip.vue';

export default {
    name: "f-multi-select",
    components: {
    CustomTooltip
       
  },
    data() {
        return {
            item: '',
            tooltipvisible:false,
            aviable:0,
        }
    },
    props: {
        label: {
            type: String,
            default: "Выберите...",
        },
        field: {
            type: [String, Number],
        },
        disabled: {
            type: Boolean,
            default: false,
        },
        title: {
            type: String,
        },

    },
    methods: {
         aviablecalc(val){
            // this.selectedletters+=len
           
            let count = 0
            let countold = 0
            this.$refs.total.innerHTML=''
            let blockWidth=this.$refs.mydiv.offsetWidth-70
            this.$refs.counter.innerHTML=''
            
            if(this.$refs.counter){
              
            for (let i=0;i<val.length;i++){
                countold=this.$refs.counter.offsetWidth
                this.$refs.counter.innerHTML += `<span class="mx-2 px-2">${val[i].name.slice(0, 25) }${val[i].name.length > 25? '...': '' }</span>`                
                count=this.$refs.counter.offsetWidth
               
                if (blockWidth<= count ){  
                    this.$refs.total.innerHTML= `<span>(+${ val.length - 1 - i })<span> `
                    
                    if    (blockWidth<= countold + this.$refs.total.offsetWidth + 5  ) {return i-2}              
                    return i-1}
            }
            return val.length-1
        }},
        toggle() {
            this.$nextTick(() => {
            if (this.likesAllEl) {
                this.values = []
            } else {
                this.values = this.items.slice()
            }
            })
        },
       
    },
    
    computed: {
        filt: {
            get() {
                return this.$store.getters[`filterslogic/mult/${this.field}`];
            },
            set(value) {
                this.$store.dispatch("filterslogic/mult/addFilter", { key: this.field, value });
                this.$emit("filterreestr")
            },
        },
        items: {
            get() {
                // return ['Открыт', 'В работе', 'Отложен', 'Отменен', 'Завершен']
                // console.log(this.$store.getters[`filterslogic/mult/mult_${this.field}`] );
                return this.$store.getters[`filterslogic/mult/mult_${this.field}`] ;
            },
            set(value) {
                this.$store.dispatch("filterslogic/mult/addFilter", {
                    key: `filterslogic/mult/mult_${this.field}`,
                    value,
                });
            },
        },
        values: {
            get() {
                return this.$store.getters[`filterslogic/mult/${this.field}`];
            },
            set(value) {
                this.$store.dispatch("filterslogic/mult/addFilter", {
                    key: this.field,
                    value,
                });
            }
        },
        likesAllEl () {
            return this.values.length === this.items.length
        },
        likesSomeEl () {
          
            return this.values.length > 0 && !this.items.length
        },
        icon () {
            if (this.likesAllEl) return 'mdi-close-box'
            if (this.likesSomeEl) return 'mdi-minus-box'
            return 'mdi-checkbox-blank-outline'
        },
    },
    watch: {
        filt(newVal, oldVal) {

            let lastChangedItem;
            if (newVal.length > oldVal.length) {
                lastChangedItem = newVal[newVal.length - 1];
            } else {
                lastChangedItem = oldVal.find(x => !newVal.includes(x));
            }
            const changedListItemIndex = this.items.findIndex(item => item === lastChangedItem);
            this.$nextTick(() => {
                this.$refs.mySelector.setMenuIndex(changedListItemIndex);
            })
            
        }  
    },
    beforeDestroy() {
        this.$store.dispatch("filterslogic/mult/addFilter", {
            key: this.field,
            value: [],
        });
    }
};
</script>

<style lang="scss">
@import "@/utils/colors.scss";
#counter, #total {
    position: absolute;
    visibility: hidden;
    
    height: auto;
    width: auto;
    white-space: nowrap; /* Thanks to Herb Caudill comment */
}
.v-autocomplete.v-select.v-input--is-focused input{
    min-width: 5px;
}

.v-list.v-select-list.v-sheet.theme--light.v-list--dense.theme--light{
    div, i{
     font-size: $filter;
 
}
}
.my_auto.v-autocomplete>.v-input__control>.v-input__slot>.v-select__slot{
            .v-label{
                
                font-size: $filter;                
            }
            .v-input__append-inner{
            .v-input__icon.v-input__icon--clear>button,
            .v-input__icon.v-input__icon--append>i{
                font-size: $filter;     
                           
            }
            }

}

</style>