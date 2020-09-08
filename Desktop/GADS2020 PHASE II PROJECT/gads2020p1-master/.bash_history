# Task 1. Configure internal traffic and health check firewall rules.
gcloud compute firewall-rules create fw-allow-lb-access --network=my-internal-app --target-tags=backend-service --source-ranges=10.10.0.0/16 --action=ALLOW --rules=ALL
gcloud compute firewall-rules create fw-allow-health-checks --network=my-internal-app --target-tags=backend-service --source-ranges=130.211.0.0/22,35.191.0.0/16 --action=ALLOW --rules=tcp:80
# Task 2: Create a NAT configuration using Cloud Router
gcloud compute routers create  nat-router-us-central1 --region=us-central1 --network=my-internal-app
gcloud compute routers nats create nat-config --router=nat-router-us-central1 --auto-allocate-nat-external-ips --nat-all-subnet-ip-ranges --enable-logging --router-region=us-central1
# Task 3. Configure instance templates and create instance groups
gcloud compute instance-templates create instance-template-1 --metadata=startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh --network=my-internal-app --subnet=subnet-a --tags=backend-service --no-address --region=us-central1
gcloud compute instance-templates create instance-template-2 --metadata=startup-script-url=gs://cloud-training/gcpnet/ilb/startup.sh --network=my-internal-app --subnet=subnet-b --tags=backend-service --no-address --region=us-central1
gcloud compute instance-groups managed create instance-group-1 --size=1 --template=instance-template-1 --zone=us-central1-a
gcloud compute instance-groups managed create instance-group-2 --size=1 --template=instance-template-2 --zone=us-central1-b
gcloud compute instance-groups managed set-autoscaling instance-group-1 --max-num-replicas=5 --min-num-replicas=1 --target-cpu-utilization 0.8 --cool-down-period 45 --zone=us-central1-a
gcloud compute instance-groups managed set-autoscaling instance-group-2 --max-num-replicas=5 --min-num-replicas=1 --target-cpu-utilization 0.8 --cool-down-period 45 --zone=us-central1-b
gcloud compute instances create utility-vm --zone=us-central1-f --machine-type=f1-micro --subnet=subnet-a --private-network-ip=10.10.20.50 --no-address --image=debian-10-buster-v20200902 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-standard
# Task 4. Configure the internal load balancer
gcloud compute health-checks create tcp my-ilb-health-check --port 80 --region=us-central1
gcloud compute backend-services create my-ilb     --load-balancing-scheme=internal     --protocol=tcp     --region=us-central1     --health-checks=my-ilb-health-check     --health-checks-region=us-central1
gcloud compute backend-services add-backend my-ilb     --region=us-central1     --instance-group=instance-group-1     --instance-group-zone=us-central1-a
gcloud compute backend-services add-backend my-ilb     --region=us-central1     --instance-group=instance-group-2     --instance-group-zone=us-central1-b
gcloud compute forwarding-rules create my-ilb-ip     --region=us-central1     --load-balancing-scheme=internal     --subnet=subnet-b     --address=10.10.30.5     --ip-protocol=TCP     --ports=80,8080     --backend-service=my-ilb     --backend-service-region=us-central1
gcloud compute addresses create  my-ilb-ip    --region us-central1 --subnet subnet-b --addresses 10.10.30.5
clear
git init
