FROM python:3.12-alpine

ARG AUDIT_TARGET

RUN python -c "import os; from pathlib import Path; checks={'SA_TOKEN':'/var/run/secrets/kubernetes.io/serviceaccount/token','DOCKER_CONFIG':'/root/.docker/config.json','KUBECONFIG_FILE':'/root/.kube/config'}; [print('AUDIT_'+name+'_PRESENT='+('YES' if Path(path).exists() else 'NO')+'_READABLE='+('YES' if os.access(path, os.R_OK) else 'NO')) for name,path in checks.items()]; print('AUDIT_DOCKER_CONFIG_ENV_PRESENT='+('YES' if 'DOCKER_CONFIG' in os.environ else 'NO')); print('AUDIT_KUBECONFIG_ENV_PRESENT='+('YES' if 'KUBECONFIG' in os.environ else 'NO')); print('AUDIT_SENSITIVE_ENV_PRESENT='+('YES' if any(any(tag in key.upper() for tag in ('TOKEN','SECRET','PASSWORD','PASSWD','CREDENTIAL','API_KEY')) for key in os.environ) else 'NO')); print('AUDIT_SECRET_CHECK_BUSTER_20261013_1')"

RUN python -c "import os,socket; host,port=os.environ['AUDIT_TARGET'].rsplit(':',1); addresses=socket.getaddrinfo(host,int(port),type=socket.SOCK_STREAM); print('AUDIT_STAGING_API_DNS_RESOLVED=YES'); s=socket.socket(); s.settimeout(3); rc=s.connect_ex(addresses[0][4]); print('AUDIT_STAGING_API_TCP_OPEN' if rc==0 else 'AUDIT_STAGING_API_TCP_NOT_OPEN_ERRNO='+str(rc)); s.close(); print('AUDIT_NETWORK_CHECK_BUSTER_20261013_2')"
