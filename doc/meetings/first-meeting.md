# CPU设计第一次会议

## 开发环境

### VSCode

需要安装的插件：

+ Tabnine(智能补全)
+ GitLens
+ GitHub Pull Request and Issues
+ koroFileHeader
+ Verilog-HDL/SystemVerilog/Bluespec SystemVerilog
+ Verilog_Testbench
+ (*选择)TerosHDL

VSCode首选项设置-用户片段
```json
	"pin":{
		"prefix": "pin",
		"body": [
			"set_property PACKAGE_PIN $1 [get_ports {$2}]",
			"set_property IOSTANDARD LVCMOS33 [get_ports {$2}]",
			"$0"
		],
		"description": "FPGA PIN"
	}
```
###

[安装地址](https://git-scm.com/)

GitHub账号注册（可能需要翻墙，但设置好SSL之后不需要）

打开git bash，输入

```bash
cd ~
mkdir .ssh
cd .ssh
ssh-keygen -t ed25519 -C "your_email@example.com"
```
密码可以为空

```bash
ls
cat id_rsa.pub
```
将得到的公钥复制下来，到GitHub中设置

回到gitbash
```bash
git config --global user.name "xxxx"
git config --global user.email "xxxxx" 
```

测试连接
```bash
ssh -T git@github.com
```

#### commit规范

feat：新功能（feature）
fix：修补bug
docs：文档（documentation）
style： 格式（不影响代码运行的变动）
refactor：重构（即不是新增功能，也不是修改bug的代码变动）
test：增加测试
chore：构建过程或辅助工具的变动
![](https://upload-images.jianshu.io/upload_images/3827973-fd58eb2b9c5f5ded.png?imageMogr2/auto-orient/strip|imageView2/2/w/700/format/webp)

基本操作：

```bash
git clone https://github.com/0xtaruhi/PlaneWar.git (这个需要翻墙)
git clone git@github.com:0xtaruhi/PlaneWar.git (这个不用，但是要先fork到自己的resporsity里面)
```

