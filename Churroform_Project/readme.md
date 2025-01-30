Open VS Code in Churroform_project

in Terminal type: 

                - enter Churroform_project folder (cd Churroform_project)

                - terraform init

                - terraform workspace new netflix
                - terraform workspace new meta
                - terraform workspace new rockstar

                -terraform workspace select ("netflix/meta/rockstar")

                -terraform plan -var-file=netflix.tfvars -out netflix.plan
                                          meta.tfvars -out meta.plan
                                          rockstar.tfvars -out rockstar.plan
                
                -terraform apply netflix.plan
                                 meta.plan
                                 rockstar.plan


