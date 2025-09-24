terraform {
    source = "../../../modules//global"
}

include "root" {
   path   = find_in_parent_folders("root.hcl")
   expose = true
}

inputs = {
   resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
   name_prefix = "ScSc-CIO_ECT_Infra"
   tenant_id = "d05bc194-94bf-4ad6-ae2e-1db0f2e38f5e"  #this should be elsewhere
}