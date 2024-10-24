<template>
  
            <v-card
            class="mt-3"
            >
            <v-card-title><slot></slot>
            <v-spacer/>
                 <v-btn
                  v-if="editable"
              color="primary"
              dark
              class="mb-2"
           
              @click="$emit('addrows','')"
            >
              Добавить
            </v-btn>
            </v-card-title>
        
            <v-data-table
                hide-default-footer
                :headers="headers"
                :items="items"
                >
                 <template v-slot:[`item.index`]="{ item }">
                {{ items.indexOf(item)+1 }}
                </template>
                <template v-slot:[`item.problem`]="props">
                   <v-edit-dialog       
                        :return-value.sync="props.item.name"     
                        >   
                    <!-- <div class="d-none">{{props.item.comment.text}}</div> -->
                    <div style="white-space:pre-wrap"  v-if="'problem' in props.item && props.item.problem.length>0"> {{props.item.problem}}</div>
                    <div  v-else>Введите текст...</div>
                        <template  v-if="editable" v-slot:input>

                            <v-textarea
                               
                                v-model="props.item.problem"
                                auto-grow
                                rows="3"
                                label="Изменение"
                            
                            counter
                            ></v-textarea>
                        </template>
                        </v-edit-dialog>
                </template>
                <template v-slot:[`item.comment`]="props">
                   <v-edit-dialog       
                        :return-value.sync="props.item.name"     
                        >   
                 
                    <div style="white-space:pre-wrap" v-if="'comment' in props.item && props.item.comment.length>0">      {{props.item.comment}}</div>
                    <div  v-else>Введите текст...</div>
                        <template  v-if="editable" v-slot:input>

                            <v-textarea
                               
                                v-model="props.item.comment"
                                auto-grow
                                rows="3"
                                label="Изменение"
                            
                            counter
                            ></v-textarea>
                        </template>
                        </v-edit-dialog>
                </template>
                <template v-if="editable" v-slot:[`item.actions`]="{ item }">
     
                    <v-icon
                        small
                        @click="$emit('remove',items.indexOf(item))"
                    >
                        mdi-delete
                    </v-icon>
                    </template>

            </v-data-table>
            </v-card>
</template>

<script>
export default {
    name:"report-bot-table",
    props:{
           items:{
            type:Array,
            default:()=>[]
        },
            headers:{
            type:Array,
            default:()=>[]
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