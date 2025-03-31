# Kubernetes Custom Service Deployments.

In development of services, Kubernetes deployments leverage both Helm and Kubernetes YAML files for optimal efficiency. Helm manages complex application deployments, while Kubernetes YAML files offer simplicity for rapid prototyping, testing, and debugging. Combining these tools balances structured deployment with the flexibility needed for agile development.

Deploying Helm resources alongside separate Kubernetes YAML files often leads to a disorganized and fragmented environment. This complexity arises because Helm charts use their own templating and versioning systems, while standalone Kubernetes YAML files follow a different structure and update process. Managing both formats simultaneously increases complexity, making it difficult to track resource versions, apply updates consistently, and troubleshoot issues across the cluster.

For improved clarity and control, it's recommended to use a unified approach, such as Kubernetes YAML files for all resources. This is where Kustomize comes in handy. Kustomize is a tool that:

* Deploys Kubernetes YAML files and resources (including Helm charts by converting them to standard YAML manifests).
* Allows the creation of reusable packages for different teams or environments.

Benefits of Using Kustomize:

- **Declarative Configuration:** Kustomize follows a declarative approach, aligning with Kubernetes' native configuration model. It enables you to manage Kubernetes resources without modifying the original YAML files. By applying overlays and patches, you can create variations for different environments.
- **Overlay Configurations:** One of Kustomize’s key features is its ability to overlay configurations. This allows you to customize YAML files for different environments (e.g., development, staging, production) without duplicating the original files.
- **Integration with Terraform:** Kustomize works particularly well when paired with Terraform for infrastructure management. The Kustomize Terraform provider ensures that resources are managed in the correct order (e.g., creating namespaces before deployments, services, or other dependent resources), ensuring a smooth and predictable deployment process.
- **Efficient Resource Management:** Kustomize's **Terraform provider** allows for the tracking, application, and removal of Kubernetes resources in the specific order required by Kubernetes. This capability ensures that resources are deployed correctly and consistently.
- **Challenges:** While Kustomize offers many benefits, it can be challenging to learn, particularly for those new to Kubernetes or declarative configuration management. However, once understood, Kustomize provides a powerful and flexible way to manage Kubernetes resources.

#### Kustomize Provider

Kustomize is used by Kubestack Framework, refer to the [Kubestack Kustomize Guide](https://www.kubestack.com/guides/catalog-using-kubestack-catalog-modules-standalone/).
Kubestack has created Terrafrom module for the Kustomize [Kustomize Provider](https://registry.terraform.io/providers/kbst/kustomization/latest/docs)
