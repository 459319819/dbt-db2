# 自动化搭建一个本地的开发环境
install:
# 	在当前项目目录下创建两个文件夹
# 	db2/database：用于持久化存储 DB2 的数据库文件（即使容器删除，数据还在）。
# 	db2/keystore：用于存储 SSL 密钥和证书（用于安全连接）。

# 	@ 符号表示执行时不显示命令本身，只显示输出结果。
# 	-p 表示如果目录已存在则不报错。
	@mkdir -p db2/database
	@mkdir -p db2/keystore
	@echo "🔍 正在启动 ibmdb2 容器，需要一些时间，请稍等..."
	@sudo docker run \
		-itd \
		--name dbt-db2 \
		--restart unless-stopped \
		-v ${PWD}/db2/database:/database \
		-v ${PWD}/db2/keystore:/keystore \
		-v ${PWD}/db2/setup_ssl.sh:/resources/setup_ssl.sh \
		-e DBNAME=testdb \
		-e DB2INST1_PASSWORD=ibm123 \
		-e LICENSE=accept \
		-p 50000:50000 \
		-p 50002:50002 \
		--privileged=true \
		icr.io/db2_community/db2:11.5.9.0
# 	同步等待数据库创建完成，并实时跟踪容器日志，当捕捉到 “Setup has completed.” 则结束
	@sudo docker logs -f dbt-db2 2>&1 | grep -m 1 '(*) Setup has completed.'
	@echo "✅ ibmdb2 数据库 启动成功!"
# 	在容器内部运行刚才挂载进去的 setup_ssl.sh 脚本
	@sudo docker exec \
		-d \
		--user db2inst1 \
		dbt-db2 \
		/bin/bash -c 'cd && source .bashrc && sh /resources/setup_ssl.sh'
# 	安装 Python 依赖（确保linux中已经安装了Python）
	@uv sync

# 重启 dbt-db2 容器
restart-db2:
	@sudo docker restart dbt-db2

# 完全卸载开发环境
uninstall:
	@sudo docker rm dbt-db2 --force
# 	“|| true” 是为了防止某个镜像不存在时，导致整个make命令报错而中断
	@sudo docker rmi icr.io/db2_community/db2:11.5.9.0 --force || true
	@rm -rf db2/database/*
	@rm -rf db2/keystore/*
	@rm -rf .tox .venv .pytest_cache logs

# 运行自动化测试
test:
	@rm -rf .tox .pytest_cache logs
	@uv run tox --parallel 3
