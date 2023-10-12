terraform {
    # replace with tagged version at some point
    source = "git::git@github.com:dto-btn/sscplus-data-fetch.git//terraform?ref=v1.0.0"
}

inputs = {
    project_name = "SSCPlusData"
    project_name_short = "SSCPlusData"
}

 include "root" {
   path   = find_in_parent_folders()
   expose = true
 }