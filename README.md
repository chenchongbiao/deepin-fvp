# 介绍

deepin 系统运行 FVP 环境及 FVP 运行 deepin arm系统内容记录。

按照 [用户指南 TC2-2023.10.04]() 官方内容先进行操作。前面拉取代码和配置 Docker 环境不进行重复。

在拉取完官方代码后，需要进行一些额外的代码同步。

# 添加 deepin 支持代码

## build-scripts

在 tc2 项目下执行以下代码。

```bash
pushd build-scripts
git remote add deepin https://github.com/chenchongbiao/arm-reference-solutions-build-scripts.git
git checkout -b deepin
git pull deepin totalcompute --rebase
popd
```

## run-scripts

```bash
pushd run-scripts
git remote add deepin https://github.com/chenchongbiao/arm-reference-solutions-run-scripts.git
git checkout -b deepin
git pull deepin totalcompute --rebase
popd
```

## 制作镜像

TODO 构建镜像

*(临时方案)*

```bash
./build-desktop-img.sh
```

在 tc2 新建目录 `mkdir -p output/deepin/deploy/tc2` 拷贝 deepin.img 镜像到目录下。

## deepin build

对应用户指南 Build variants configuration 部分内容，前面添加了 deepin 代码支持才能使用。

```bash
export PLATFORM=tc2
export FILESYSTEM=deepin
export TC_TARGET_FLAVOR=fvp
cd build-scripts
./setup.sh
```

这里添加了 FILESYSTEM=deepin

## Build command

和官方文档一样执行

```bash
./run_docker.sh ./build-all.sh build
```

## Run scripts

```bash
./run_model.sh -m ~/FVP_TC2/models/Linux64_GCC-9.3/FVP_TC2 -d deepin
```

## 使用 treeland 窗管

```bash
# 设置显示管理器为 sddm
sudo apt install sddm treeland
```
