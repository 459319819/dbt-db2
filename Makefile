# ==============================
# 定义全局变量 (请在此处修改参数)
# ==============================
DB2_IMAGE_NAME = icr.io/db2_community/db2:11.5.9.0
DB2_CONTAINER_NAME = ibmdb2_dbt_test
DB2_DBNAME = testdb
DB2_PASSWORD = ibm123 # 默认会创建一个用户：db2inst1
TOX_PARALLEL = 3
# eg：py39,py311,py313
SELECT_PYTHON_ENV_LIST = py311


# ==============================
# 定义任务脚本
# ==============================

# 自动化搭建一个本地的开发环境
install:
# 	在当前项目目录下创建两个文件夹
# 	db2/database：用于持久化存储 DB2 的数据库文件（即使容器删除，数据还在）。
# 	db2/keystore：用于存储 SSL 密钥和证书（用于安全连接）。

# 	@ 符号表示执行时不显示命令本身，只显示输出结果。
# 	-p 表示如果目录已存在则不报错。
	@mkdir -p db2/database
	@mkdir -p db2/keystore
	@echo "🔍 下载并运行 ibmdb2 容器，需要一些时间，请稍等..."
	@sudo docker run \
		-itd \
		--name $(DB2_CONTAINER_NAME) \
		--restart unless-stopped \
		-v ${PWD}/db2/database:/database \
		-v ${PWD}/db2/keystore:/keystore \
		-v ${PWD}/db2/setup_ssl.sh:/resources/setup_ssl.sh \
		-e DBNAME=$(DB2_DBNAME) \
		-e DB2INST1_PASSWORD=$(DB2_PASSWORD) \
		-e LICENSE=accept \
		-p 50000:50000 \
		-p 50002:50002 \
		--privileged=true \
		$(DB2_IMAGE_NAME)
	@echo "🔍 还有一小会，请耐心等待..."
# 	同步等待数据库创建完成，并实时跟踪容器日志，当捕捉到 “Setup has completed.” 则结束
	@sudo docker logs -f $(DB2_CONTAINER_NAME) 2>&1 | grep -m 1 '(*) Setup has completed.'
	@echo "✅ ibmdb2 数据库 启动成功!"
# 	在容器内部运行刚才挂载进去的 setup_ssl.sh 脚本
#   db2inst1 是ibmdb2创建的默认操作系统用户
	@sudo docker exec \
		-d \
		--user db2inst1 \
		$(DB2_CONTAINER_NAME) \
		/bin/bash -c 'cd && source .bashrc && sh /resources/setup_ssl.sh'
# 	安装 Python 依赖（确保linux中已经安装了Python）
	@uv sync

# 重启 dbt-db2 容器
restart-db2:
	@sudo docker restart $(DB2_CONTAINER_NAME)

# 完全卸载开发环境
uninstall:
	@sudo docker rm $(DB2_CONTAINER_NAME) --force || true
# 	--force 是为了停止容器，否则无法正常删除镜像
# 	“|| true” 是为了防止某个镜像不存在时，导致整个make命令报错而中断
#   由于容器挂在卷的权限属于容器内部用户，需要sudo授权删除
	@sudo docker rmi $(DB2_IMAGE_NAME) --force || true
	@sudo rm -rf db2/database/*
	@sudo rm -rf db2/keystore/*
	@rm -rf .tox .venv .pytest_cache logs

# 运行自动化测试
test:
	@rm -rf .tox .pytest_cache logs
	@uv run tox --parallel $(TOX_PARALLEL)

# 选择指定Python环境进行测试
test-select:
	@rm -rf .tox .pytest_cache logs
	@uv run tox -e $(SELECT_PYTHON_ENV_LIST)
