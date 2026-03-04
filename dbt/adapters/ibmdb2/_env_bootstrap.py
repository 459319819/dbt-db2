"""
IBM DB2 Windows 环境引导与 DLL 加载补偿模块。
此模块必须在任何其他 ibm_db 相关导入之前执行。
"""
import os
import sys
from pathlib import Path

# 兼容 Python 3.7 (虽然 dbt 通常要求 3.8+)，优先使用标准库
try:
    from importlib.metadata import version, PackageNotFoundError
except ImportError:
    # Python < 3.8 需要 pip install importlib-metadata
    from importlib_metadata import version, PackageNotFoundError

def get_package_version():
    """
    动态获取当前安装的 dbt-db2 包版本。
    如果无法获取，返回未知版本字符串。
    """
    try:
        # 这里的名称必须与 pyproject.toml 中的 name 字段一致 (通常会自动转为标准化名称，即 - 变 _)
        # pyproject.toml: name = "dbt-db2" -> 查询时使用 "dbt-db2" 或 "dbt_db2" 通常都可以，
        # 但 importlib.metadata 推荐使用标准化名称 (PEP 503)，即 "dbt-db2"
        return version("dbt-db2")
    except PackageNotFoundError:
        return "unknown (dev?)"

def setup_windows_dll_path():
    """
    在 Windows 环境下，自动查找并添加 clidriver/bin 到 DLL 搜索路径。
    如果失败，提供友好的错误提示并退出。
    """
    if os.name == "nt":

        # 获取当前 Python 环境根目录 (虚拟环境或系统环境)
        venv_root = Path(sys.prefix)
        
        # 构建预期的 clidriver/bin 路径
        # 注意：pip install ibm_db 通常会将 clidriver 安装在 site-packages 下
        clidriver_bin = venv_root / "Lib" / "site-packages" / "clidriver" / "bin"

        # 获取项目版本号，用于日志输出
        pkg_version = get_package_version()
        
        # 兼容某些特殊安装情况 (例如直接安装在根目录，虽然少见)
        if not clidriver_bin.exists():
            alt_path = venv_root / "clidriver" / "bin"
            if alt_path.exists():
                clidriver_bin = alt_path

        if clidriver_bin.exists():
            try:
                # Python 3.8+ 推荐方式：显式添加 DLL 搜索目录
                os.add_dll_directory(str(clidriver_bin))
                print(f"[dbt-db2] 🎯 发现基于 dbt-ibmdb2 的定制化版本的 dbt 数据源适配器")
                print(f"[dbt-db2] 🎯 当前修订版本是：{pkg_version}")
                print(f"[dbt-db2] ✅ 已自动添加 DLL 路径: {clidriver_bin}")
            except Exception as e:
                print(f"[dbt-db2] ⚠️ 添加 DLL 路径时发生警告: {e}")
        else:
            # 如果找不到，给出友好提示
            print("❌ [dbt-db2] 启动失败：未找到 IBM DB2 驱动 (clidriver)")
            print(f"检查路径: {clidriver_bin}")
            print("❓可能的原因及解决方案：")
            print("1. 未安装 ibm_db 包:")
            print("   -> 运行: pip install ibm_db")
            print("2. 安装了包但文件缺失 (网络问题导致下载不完整):")
            print("   -> 运行: pip uninstall ibm_db -y && pip install ibm_db --no-cache-dir")
            print("3. 使用了系统级 IBM Client 但未配置 PATH:")
            print("   -> 请将 IBM CLI Driver 的 'bin' 目录添加到系统 PATH 环境变量中。")
            
            # 关键：直接退出进程，阻止后续代码执行导致的 cryptic 报错
            sys.exit(1)
    # TODO: Unix / MacOS

# 立即执行
setup_windows_dll_path()