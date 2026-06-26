import { Injectable } from '@nestjs/common';

export interface PolicyRule {
  id: string;
  name: string;
  category: 'SECURITY' | 'COMPLIANCE' | 'DEPLOYMENT';
  status: 'ACTIVE' | 'AUDIT' | 'DISABLED';
  description: string;
  check: (target: any) => boolean;
}

@Injectable()
export class PolicyService {
  private rules: PolicyRule[] = [
    {
      id: 'POL-001',
      name: 'Enforce TLS 1.3 Encryption',
      category: 'SECURITY',
      status: 'ACTIVE',
      description: 'Require Ingress and service mesh connections to enforce TLS 1.3 minimum.',
      check: (target) => target.tlsVersion === '1.3',
    },
    {
      id: 'POL-002',
      name: 'Private Image Repository Only',
      category: 'DEPLOYMENT',
      status: 'ACTIVE',
      description: 'Verify GKE/EKS deployments only pull container images from authorized private registries.',
      check: (target) => target.imageUrl && (target.imageUrl.startsWith('teamos.gcr.io/') || target.imageUrl.startsWith('teamos.dkr.ecr.')),
    },
    {
      id: 'POL-003',
      name: 'No Root Containers allowed',
      category: 'SECURITY',
      status: 'ACTIVE',
      description: 'Deployments must run as non-root user and restrict privilege escalation.',
      check: (target) => target.runAsNonRoot === true,
    },
  ];

  async getPolicies(): Promise<PolicyRule[]> {
    return this.rules;
  }

  async validateDeploymentPolicy(deploymentSpecs: { tlsVersion: string; imageUrl: string; runAsNonRoot: boolean }): Promise<{ isValid: boolean; failures: string[] }> {
    const failures: string[] = [];
    for (const rule of this.rules) {
      if (rule.status === 'ACTIVE' && !rule.check(deploymentSpecs)) {
        failures.push(`${rule.name}: ${rule.description}`);
      }
    }
    return {
      isValid: failures.length === 0,
      failures,
    };
  }
}
