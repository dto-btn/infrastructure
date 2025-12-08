terraform {
    source = "../../../modules//global"
}

include "root" {
   path   = find_in_parent_folders("root.hcl")
   expose = true
}

inputs = {
   resource_group_name = "G3Pc-SSC_CIOAssistant_Project-rg"
   name_prefix = "G3Pc-SSC-CIOAssistant"
   acr_name = "cioassistantacr"
   tenant_id = "7198d08c-c362-4703-9854-53b6f0d8fc44"  #this should be elsewhere.
   subscription_id = "dd7b6f23-7cf4-4598-a0ba-55888cfb1616"
}