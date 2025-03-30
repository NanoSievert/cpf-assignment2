# Assignment 2

docker tag cpf/assignment1:latest 351251544313.dkr.ecr.us-east-1.amazonaws.com/cpf/assignment1:latest

--------
instead of enabling admin user in 4.2.3 you can also:

You're seeing this error because **Azure Container Registry (ACR)** requires authentication before pulling images, and the **Admin user** is currently disabled for your registry. Here’s how to fix it:

### **Solution 1: Enable Admin User for ACR**
1. **Go to the Azure Portal** ([https://portal.azure.com](https://portal.azure.com)).
2. **Navigate to your ACR**:
   - Search for "Container Registries" and select your registry.
3. **Enable Admin User**:
   - Go to the **Access keys** tab.
   - Toggle **Admin user** to **Enabled**.
   - Copy the **username** and **password**.

4. **Use the credentials to log in**:
   ```sh
   az acr login --name <ACR_NAME> --username <USERNAME> --password <PASSWORD>
   ```
   Or provide them when pulling an image:
   ```sh
   docker login <ACR_LOGIN_SERVER> -u <USERNAME> -p <PASSWORD>
   ```

---

### **Solution 2: Use an Azure Service Principal (Recommended for Security)**
If you don’t want to enable the Admin user, use an **Azure Service Principal** with `AcrPull` permissions:
1. **Create a Service Principal**:
   ```sh
   az ad sp create-for-rbac --name "acr-pull" --role acrpull --scopes $(az acr show --name <ACR_NAME> --query id --output tsv)
   ```
2. **Get the credentials** from the output:
   - `appId` → username
   - `password` → password
   - `tenant` → tenant ID

3. **Login with the service principal**:
   ```sh
   docker login <ACR_LOGIN_SERVER> -u <appId> -p <password>
   ```

This will allow the container instance to pull images without enabling the admin account.

Would you like more details on setting up a service principal?