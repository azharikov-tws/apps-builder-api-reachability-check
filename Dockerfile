FROM python:3.12-alpine
RUN python -c "import socket; s=socket.socket(); s.settimeout(3); rc=s.connect_ex((\"10.66.0.1\",1234)); print(\"AUDIT_BUILDKIT_TCP_OPEN\" if rc==0 else \"AUDIT_BUILDKIT_TCP_BLOCKED\"); s.close()"
