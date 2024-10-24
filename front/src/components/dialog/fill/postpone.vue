<template>

  
   
 
    
</template>

<script>
   

export default {

    name:"postpone",

    props: {
        comment: {
            type: String,
            default: ""
        },

    },

    computed:{

        comment1:{
        get(){
            return this.comment
        },
        set(val){
            this.$emit("comm", val )
        }
        }}
}
</script>

<style>

</style>