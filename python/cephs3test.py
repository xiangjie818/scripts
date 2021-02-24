#!/usr/bin/env python
import boto
import boto.s3.connection

access_key = '123456'
secret_key = '123456'

conn = boto.connect_s3(
    aws_access_key_id = access_key,
    aws_secret_access_key = secret_key,
    host = '172.16.0.10',port = 8080, is_secure = False, calling_format = boto.s3.connection.OrdinaryCallingFormat(),
)

bucket = conn.create_bucket('my-new-bucket')
for bucket in conn.get_all_buckets():
    print "{name} {created}".format(name = bucket.name,created=bucket.creation_date,)