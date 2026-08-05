# Python 项目（uv）

用 uv 管理项目，不使用 pip / 不手动创建 venv（uv 自动管理环境）。

## 创建

```bash
uv init <项目名> --vcs none
```

- 生成 `pyproject.toml`（含 `[project.scripts]` 入口）、`README.md`、`src/<name>/`
  （`__init__.py` + `main.py`）。
- 默认 `requires-python` 取 uv 当前默认 Python（本机为 `>=3.11`）；需要指定版本时：
  `uv init --python 3.14 <项目名>`（用户已有项目用 `>=3.14`，可据此询问用户）。
- ⚠️ **必须加 `--vcs none`**：uv 默认会 `git init`（实测确认），与"不要 git"约定冲突。

## 添加依赖

```bash
uv add <包名>            # 更新 pyproject.toml + uv.lock
```

## 运行

```bash
uv run <项目名>           # 跑 [project.scripts] 入口（如 demo:main）
uv run python <script>.py # 跑任意脚本
```

## 验证

`uv run <项目名>` 输出正常即成功。生成的 `src/<name>/main.py` 默认实现可直接跑。
