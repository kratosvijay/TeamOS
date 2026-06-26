import { Injectable } from '@nestjs/common';

@Injectable()
export class ClusterService {
  async getClusterDetails() {
    return {
      clusterName: 'teamos-gke-cluster',
      provider: 'GCP',
      region: 'us-central1',
      version: 'v1.28.2-gke.100',
      status: 'HEALTHY',
    };
  }

  async getNodes() {
    return [
      { name: 'gke-node-1', status: 'Ready', role: 'worker', cpu: '8 vCPU', memory: '32 GiB' },
      { name: 'gke-node-2', status: 'Ready', role: 'worker', cpu: '8 vCPU', memory: '32 GiB' },
      { name: 'gke-node-3', status: 'Ready', role: 'worker', cpu: '8 vCPU', memory: '32 GiB' },
    ];
  }

  async getPods(namespace = 'teamos') {
    return [
      { name: 'teamos-backend-849fd', status: 'Running', restarts: 0, ip: '10.244.0.12' },
      { name: 'teamos-backend-93d1a', status: 'Running', restarts: 0, ip: '10.244.1.45' },
      { name: 'teamos-frontend-7f91a', status: 'Running', restarts: 2, ip: '10.244.2.19' },
      { name: 'redis-master-0', status: 'Running', restarts: 0, ip: '10.244.1.2' },
      { name: 'postgres-0', status: 'Running', restarts: 0, ip: '10.244.2.5' },
    ];
  }

  async getDeployments(namespace = 'teamos') {
    return [
      { name: 'teamos-backend', replicas: '3/3', available: 3, strategy: 'Canary (10% weight)' },
      { name: 'teamos-frontend', replicas: '2/2', available: 2, strategy: 'RollingUpdate' },
    ];
  }

  async getServices(namespace = 'teamos') {
    return [
      { name: 'teamos-backend', type: 'ClusterIP', port: '3000/TCP' },
      { name: 'teamos-frontend', type: 'LoadBalancer', port: '80:31289/TCP', externalIp: '34.120.45.98' },
    ];
  }

  async getNamespaces() {
    return ['default', 'kube-system', 'istio-system', 'teamos', 'argocd'];
  }
}
