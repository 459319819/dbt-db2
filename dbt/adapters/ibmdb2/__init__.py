# 第一行：必须先执行环境补偿脚本！
# 这行代码会立即运行 _env_bootstrap.py 中的所有内容。
# 如果检测到 DLL 缺失，程序会在这里友好地退出，不会执行下面的代码。
from dbt.adapters.ibmdb2 import _env_bootstrap

from dbt.adapters.ibmdb2.connections import IBMDB2ConnectionManager
from dbt.adapters.ibmdb2.connections import IBMDB2Credentials
from dbt.adapters.ibmdb2.impl import IBMDB2Adapter

from dbt.adapters.base import AdapterPlugin
from dbt.include import ibmdb2


Plugin = AdapterPlugin(
    adapter=IBMDB2Adapter,
    credentials=IBMDB2Credentials,
    include_path=ibmdb2.PACKAGE_PATH)
