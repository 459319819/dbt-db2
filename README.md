[![pypi](https://badge.fury.io/py/dbt-ibmdb2.svg)](https://pypi.org/project/dbt-ibmdb2/)
[![python](https://img.shields.io/pypi/pyversions/dbt-ibmdb2)](https://pypi.org/project/dbt-ibmdb2/)

<br/>
<br/>

# language（语言）

[English](#Intro)

[简体中文](#简介)

<br/>
<br/>

# English

## Intro

This plugin ports [dbt](https://getdbt.com) functionality to IBM DB2.

This is an experimental plugin:
- We have not tested it extensively
- Only basic tests are implemented
- Compatibility with other [dbt packages](https://hub.getdbt.com/) (like [dbt_utils](https://hub.getdbt.com/fishtown-analytics/dbt_utils/latest/)) is only partially tested

Please read these docs carefully and use at your own risk. [Issues](https://github.com/aurany/dbt-ibmdb2/issues/new) welcome!

### Installation
This plugin can be installed via pip:

```powershell
$ pip install dbt-ibmdb2
```

### Supported features

| DB2 LUW | DB2 z/OS | Feature |
|:---------:|:---:|---------------------|
| ✅ | 🤷 | Table materialization       |
| ✅ | 🤷 | View materialization        |
| ✅ | 🤷 | Incremental materialization |
| ✅ | 🤷 | Ephemeral materialization   |
| ✅ | 🤷 | Seeds                       |
| ✅ | 🤷 | Sources                     |
| ✅ | 🤷 | Custom data tests           |
| ✅ | 🤷 | Docs generate               |
| ✅ | 🤷 | Snapshots                   |

*Notes:*
- dbt-ibmdb2 is built on the ibm_db python package and there are some known encoding issues related to z/OS.

### Configuring your profile

A dbt profile can be configured to run against DB2 using the following configuration example:

**Example entry for profiles.yml:**

```
your_profile_name:
  target: dev
  outputs:
    dev:
      type: ibmdb2
      schema: analytics
      database: test
      host: localhost
      port: 50000
      protocol: TCPIP
      user: my_username
      password: my_password
      extra_connect_opts: my_extra_config_options
```

| Option          | Description                                                                         | Required?                                                          | Example                                        |
| --------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------------ | ---------------------------------------------- |
| type            | The specific adapter to use                                                         | Required                                                           | `ibmdb2`                                       |
| schema          | Specify the schema (database) to build models into                                  | Required                                                           | `analytics`                                    |
| database        | Specify the database you want to connect to                                         | Required                                                           | `testdb`                                         |
| host            | Hostname or IP-adress                                                               | Required                                                           | `localhost`                                    |
| port            | The port to use                                                                     | Optional                                                           | `50000`                                        |
| protocol        | Protocol to use                                                                     | Optional                                                           | `TCPIP`                                        |
| user            | The username to use to connect to the server                                        | Required                                                           | `my-username`                                  |
| password        | The password to use for authenticating to the server                                | Required                                                           | `my-password`                                  |
| extra_connect_opts        | Extra connection options                                | Optional                                                           | `Security=SSL;SSLClientKeyStoreDB=<path-to-client-keystore>;SSLClientKeyStash=<path-to-client-keystash>`                                  |

### Setup dev environment and run tests

Make sure you have docker and poetry installed globally.

```
make install
make test
make uninstall
```

### Reporting bugs

Want to report a bug or request a feature? Open [an issue](https://github.com/aurany/dbt-ibmdb2/issues/new).

### Credits

dbt-ibmdb2 is heavily inspired by and borrows from [dbt-mysql](https://github.com/dbeatty10/dbt-mysql) and [dbt-oracle](https://github.com/techindicium/dbt-oracle).


<br/>
<br/>
<br/>


## 简介
这是一个 [dbt](https://getdbt.com) 的适配器插件，让 dbt 连接和使用 ibmdb2。

这是一个实验性插件：
- 我们尚未对其进行广泛测试
- 仅实现了基本测试
- 与其他 [dbt packages](https://hub.getdbt.com/) （如 [dbt_utils](https://hub.getdbt.com/fishtown-analytics/dbt_utils/latest/) ）的兼容性仅经过部分测试

请仔细阅读这些文档，并自行承担使用风险。欢迎提交 [Issues](https://github.com/aurany/dbt-ibmdb2/issues/new)！

## 安装

此插件可以通过 pip 进行安装：

```powershell
$ pip install dbt-ibmdb2
```

## 支持的功能

| DB2 LUW | DB2 z/OS | 功能 |
|:---------:|:---:|---------------------|
| ✅ | 🤷 | 表物化 (Table materialization)       |
| ✅ | 🤷 | 视图物化 (View materialization)        |
| ✅ | 🤷 | 增量物化 (Incremental materialization) |
| ✅ | 🤷 | 临时物化 (Ephemeral materialization)   |
| ✅ | 🤷 | 种子数据 (Seeds)                       |
| ✅ | 🤷 | 源数据 (Sources)                     |
| ✅ | 🤷 | 自定义数据测试 (Custom data tests)           |
| ✅ | 🤷 | 文档生成 (Docs generate)               |
| ✅ | 🤷 | 快照 (Snapshots)                   |

> [!Warning]
> dbt-ibmdb2 基于 ibm_db Python 包构建，与 z/OS 相关的一些已知编码问题仍然存在。

## 配置 profile

在 dbt 中使用，需要配置如下内容：

```yaml
your_profile_name:
  target: dev
  outputs:
    dev:
      type: ibmdb2
      schema: analytics
      database: test
      host: localhost
      port: 50000
      protocol: TCPIP
      user: my_username
      password: my_password
      extra_connect_opts: my_extra_config_options
```

| 选项 | 描述 | 是否必填？ | 示例 |
| :--- | :--- | :--- | :--- |
| type | 要使用的特定适配器 | 必填 | `ibmdb2` |
| schema | 指定构建模型的目标模式（数据库） | 必填 | `analytics` |
| database | 指定要连接的数据库 | 必填 | `testdb` |
| host | 主机名或 IP 地址 | 必填 | `localhost` |
| port | 要使用的端口 | 可选 | `50000` |
| protocol | 要使用的协议 | 可选 | `TCPIP` |
| user | 用于连接服务器的用户名 | 必填 | `my-username` |
| password | 用于向服务器进行身份验证的密码 | 必填 | `my-password` |
| extra_connect_opts | 额外连接选项 | 可选 | `Security=SSL;SSLClientKeyStoreDB=<path-to-client-keystore>;SSLClientKeyStash=<path-to-client-keystash>` |


## 开发环境与运行测试

请确保您已在全局范围内安装了 make、 docker.io 和 uv。

### 🛠️ 自动化安装开发环境
```powershell
$ make install
```

### 🛠️ 运行自动化测试
```powershell
$ make test
```

### 🛠️ 卸载开发环境
```powershell
$ make uninstall
```


## 报告错误
想要报告错误或请求新功能？请 提交 [issue](https://github.com/aurany/dbt-ibmdb2/issues/new)。