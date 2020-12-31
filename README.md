# pheweb-data-puddle
data puddle for Pheweb

# usage
build.sh --bucket <bucket> --subdomain <subdomain> --mount <mount>

arguments :
- bucket : bucket to download data from e.g. gs://r6_data_green/pheweb/78157cf4-d56f-431a-99fb-3b2bae4e494b_out
- subdomain : finngen subdomain hosting site :
  right now  : bstaging | bdev
  are the only domains supported as 
- mount : nfs mount directory e.g. /mnt/nfs_dev


# acceptance test
  
  prerequisites

  - helm
  - kubectl
  - gsutils
  
  tear everything down
```
  gcloud container clusters get-credentials staging-pheweb
  helm delete bstaging
  rm -rf /mnt/nfs_dev/pheweb/bstaging
``` 

  bring everything up
  > ./build.sh
  
