# **Automated Deployment with GitHub Actions and PM2 🚀**

This repository provides an automated CI/CD pipeline for deploying a **Node.js** application using **PM2** and **GitHub Actions**.  

## **🚀 Features**
- Automatic deployment on every push to the `main` branch
- Secure deployment via SSH using GitHub Actions
- Dependency installation, build process, and PM2 restart

---

## **🔧 Prerequisites**
- **Deployment Server** with SSH access and **PM2** installed
- GitHub repository with **GitHub Actions** enabled

---

## **🚀 Setup Instructions**

### **1. Generate SSH Key on Deployment Server**
Create a new SSH key for GitHub Actions:
```bash
sudo ssh-keygen -t rsa -b 4096 -C "github-actions"
```

### **2. Authorize SSH Key**
Add the public key to the `authorized_keys` file:
```bash
sudo cat /root/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```

### **3. Copy Public SSH Key**
Retrieve the public key:
```bash
sudo cat /root/.ssh/id_rsa.pub
```
Save this key; it will be used in the next step.

### **4. Add SSH Key to GitHub Secrets**
- Go to your repository on GitHub.
- Navigate to **Settings → Secrets and variables → Actions → New repository secret**.
- Create a secret named `SSH_PRIVATE_KEY` and paste the **private key** content.

### **5. GitHub Workflow Configuration**
GitHub Actions will use the SSH key for secure deployment. Example snippet:
```yaml
run: |
  mkdir -p ~/.ssh
  echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
  chmod 600 ~/.ssh/id_rsa
  ssh-keyscan -H your-server-ip >> ~/.ssh/known_hosts
```

---

## **📂 GitHub Actions Workflow**
Below is an example workflow file for automated deployment:

```yaml
name: Redeploying PM2 Server

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    container:
      image: node:20

    steps:
      - name: Checkout repository
        uses: actions/checkout@v3

      - name: Setup SSH Key
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_PRIVATE_KEY }}" > ~/.ssh/id_rsa
          chmod 600 ~/.ssh/id_rsa
          ssh-keyscan -H ${{ secrets.SSH_HOST }} >> ~/.ssh/known_hosts

      - name: Deploy via SSH
        run: |
          ssh ${{ secrets.USER }}@${{ secrets.SSH_HOST }} << 'EOF'
            cd ${{ secrets.WORKDIR }}
            git pull origin main
            npm install --production
            npm run build
            pm2 restart ${{ secrets.PROCESS_ID }}
            echo 'Deployment Successful! 🎉'
          EOF
```

---

## **🎯 Usage**
1. Push your changes to the `main` branch.
2. GitHub Actions will automatically:
   - Connect to your server.
   - Pull the latest code.
   - Install dependencies.
   - Build the project.
   - Restart the PM2 process.

---

## **📢 Troubleshooting**
- Ensure your server allows SSH connections from GitHub's IP range.
- Verify your **GitHub Secrets** are correctly set:
  - `SSH_PRIVATE_KEY`
  - `SSH_HOST`
  - `USER`
  - `WORKDIR`
  - `PROCESS_ID`

---

## **📜 License**
This project is licensed under the **MIT License**.

---

## **👏 Contributions**
Feel free to **fork** this project, open **issues**, and submit **pull requests**!

---

Deploy smarter, not harder! 🚀