terraform {
    source = "../../../modules//global"
}

include "root" {
   path   = find_in_parent_folders("root.hcl")
   expose = true
}

inputs = {
   resource_group_name = "ScSc-CIO_ECT_Infrastructure-rg"
   name_prefix = "ScSc-CIO-ECT-Infra"
   acr_name = "dtoacr"
   tenant_id = "d05bc194-94bf-4ad6-ae2e-1db0f2e38f5e"  #this should be elsewhere
   subscription_id = "f5fb90f1-6d1e-4a21-8935-6968d811afd8"
}