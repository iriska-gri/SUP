<template>
   <v-row
        class="flex-grow-0  mt-0"
        :class="rowclass"
    >
        <v-col 
            :xl="colls[variant].xl"
            :lg="colls[variant].lg"
            :md="colls[variant].md"
            :sm="colls[variant].sm"
            :cols="colls[variant].cols"
            class="py-1"
            :class="myclass"
        >
            <strong>
                {{title}}
            </strong>
        </v-col>

        <v-col
            class="py-1 text-nowrap flex-grow-1 flex-col"
            :class="leftcol"
            @click="$emit(stroka)"
        >
           
            <slot name='leftcol'/>
        </v-col>
        <v-col
            v-if="rightcolUsed"
            class="text-nowrap  py-1 flex-grow-0 flex-row align-self-center justify-content-end"
        >
            <slot name='rightcol'/>
        </v-col>
    </v-row>
</template>

<script>
export default {

    name: "row-pirow",

    data() { 
        return {
            colls: {
                36: {
                    xl:4, 
                    lg:4,
                    md:6,
                    sm:6,
                    cols:6
                },
                0: {
                    xl:0, 
                    lg:0,
                    md:0,
                    sm:0,
                    cols:0
                },  
                12: {
                    xl:12, 
                    lg:12,
                    md:12,
                    sm:12,
                    cols:12
                },                
            }
        }
    },

    props: {

        rightcolUsed: {
            type: Boolean,
            default: false
        },

        title: {
            type: String,
            default: ""
        },

        leftcol: {
            type: String,
            default: ""
        },

        myclass: {
            type: String,
            default: ""
        },

        rowclass: {
            type: String,
            default: "pb-1"
        },

        variant: {
            type: Number,
            default: 36
        },

        // point: {
        //     type: Boolean,
        //     default: false
        // },

        stroka: {
            type: String,
            default: ""
        },


    }

}
</script>


