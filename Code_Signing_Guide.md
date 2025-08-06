# 代码签名和证书配置指南

## 📋 前提条件

### 🍎 Apple Developer Account
- [ ] 已注册Apple Developer Program ($99/年)
- [ ] 账户状态正常，无违规记录
- [ ] 已同意最新的开发者协议

### 💻 开发环境
- [x] Xcode 15.0+ 已安装
- [x] macOS 最新版本
- [x] 项目配置正确

## 🔐 证书管理

### 1. 创建发布证书 (Distribution Certificate)

#### 在Keychain中创建证书请求
```bash
# 打开Keychain Access
# 菜单: Keychain Access > Certificate Assistant > Request a Certificate From a Certificate Authority
# 填写信息:
# - User Email Address: 你的Apple ID邮箱
# - Common Name: 你的姓名
# - CA Email Address: 留空
# - Request is: Saved to disk
# - Let me specify key pair information: 勾选
```

#### 在Apple Developer Portal创建证书
1. 登录 [Apple Developer Portal](https://developer.apple.com/account/)
2. 进入 **Certificates, Identifiers & Profiles**
3. 点击 **Certificates** > **+** 创建新证书
4. 选择 **iOS Distribution (App Store and Ad Hoc)**
5. 上传刚才创建的 `.certSigningRequest` 文件
6. 下载生成的 `.cer` 文件
7. 双击安装到Keychain

### 2. 配置App ID

#### 检查现有App ID
- Bundle ID: `com.chiimagnus.JETJETJET`
- 确保已启用以下服务:
  - [x] CloudKit
  - [x] Push Notifications (如果需要)

#### 如果需要创建新的App ID
1. 在Developer Portal中选择 **Identifiers**
2. 点击 **+** 创建新的App ID
3. 选择 **App IDs** > **App**
4. 填写信息:
   - Description: `JETJETJET Flight Recorder`
   - Bundle ID: `com.chiimagnus.JETJETJET` (Explicit)
5. 启用需要的服务:
   - CloudKit
   - Push Notifications (可选)

### 3. 创建Provisioning Profile

#### App Store Distribution Profile
1. 在Developer Portal中选择 **Profiles**
2. 点击 **+** 创建新Profile
3. 选择 **App Store** (Distribution)
4. 选择App ID: `com.chiimagnus.JETJETJET`
5. 选择Distribution Certificate
6. 命名: `JETJETJET App Store Distribution`
7. 下载并双击安装

## ⚙️ Xcode配置

### 1. 项目设置

#### Signing & Capabilities
```
Target: JETJETJET
├── Signing & Capabilities
│   ├── Automatically manage signing: ❌ (关闭)
│   ├── Team: [你的开发团队]
│   ├── Provisioning Profile: JETJETJET App Store Distribution
│   └── Signing Certificate: iOS Distribution
```

#### Build Settings
```
Code Signing Style: Manual
Code Signing Identity: iOS Distribution
Provisioning Profile: JETJETJET App Store Distribution
```

### 2. 更新项目配置

检查当前配置是否正确：

<function_calls>
<invoke name="view">
<parameter name="path">JETJETJET.xcodeproj/project.pbxproj
