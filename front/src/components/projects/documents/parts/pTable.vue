<template>
  <tr  >
                        <td  class="font-weight-regular pa-2 w-50" >
                        <p :class="editable?'passiv_text--text':''"><slot></slot></p>
                        </td>
                        <td class="font-weight-regular pa-2" v-if="!Array.isArray(dat.data)">
                           
                            <p :class="editable?'passiv_text--text':''">{{dat.data}}</p>                
                        </td>
                         <td class="font-weight-regular pa-2" v-else>                          
                           
                                    <p :class="editable?'passiv_text--text':''" v-for="(val,key ) in dat.data" :key="key">
                                {{val}}
                            </p>
                             
                                                  
                        
                        </td>

                    </tr>
</template>

<script>
export default {
name:"p-table",
props:{
    dat:{
        type:Object,
        default:()=>{}
    },
    editable:{
        type:Boolean,
        default:false
    }
}
}
</script>

<style>

</style>