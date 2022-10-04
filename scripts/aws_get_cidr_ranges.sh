jq '.prefixes[] | select(.region=="us-east-1") | .ip_prefix' < ./../files/aws_ip_ranges.json  >> ./../files/curated_aws_ip_ranges.json
cat ./../files/curated_aws_ip_ranges.json
