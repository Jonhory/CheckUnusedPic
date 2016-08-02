###已写好的脚本链接
<https://github.com/JonHory/CheckUnusedPic>
###使用脚本清除项目中未使用的图片资源
打开终端，输入以下命令安装：

`brew install ack`

若安装失败，则

`ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

然后再次`brew install ack`

###写一个shell脚本findUnusedPic.sh
作用是查询目录下未使用的图片资源并导出该图片资源的文件目录到当前目录下`UnusedPic.txt`文件内

    #! /bin/bash

    echo "" > UnusedPic.txt
    for i in `find . -name "*.png" -o -name "*.jpg"`; do
        file=`basename -s .jpg "$i" | xargs basename -s .png | xargs basename -s @2x | xargs basename -s @3x`
        result=`ack -i "$file"`
        if [ -z "$result" ]; then
            echo "$i" >> UnusedPic.txt
        fi
    done

###写一个shell脚本DelUnusedPic.sh
作用是读取当前目录下 UnusedPic.txt文件的每行内容，即未使用的图片资源目录，并做删除处理。

    if [ ! -f UnusedPic.txt ]; then
        echo UnusedPic.txt not found
        exit 0
    fi

    for i in `cat UnusedPic.txt`
    do
       if [ '' != '$i' ]; then
        echo rm $i
            rm -f $i
       fi 
    done

###偶尔使用一次的方法
* 写这两个脚本，或者从github链接中copy这两个脚本至需要检测的项目文件目录下,若使用cocoaPods,则建议copy至项目文件名称的目录。
* 打开终端，cd至脚本所在目录
* 先执行findUnusedPic.sh脚本   `sh findUnusedPic.sh`
* 等待执行完毕后，打开UnusedPic.txt查看查询结果，并将一些实际使用到但仍然查出来的图片资源目录删除。或者将需要保留的图片资源目录删除。

 如

  `./Expand/OtherResources/pic/chat_animation1.png`
  `./Expand/OtherResources/pic/chat_animation2.png`
  `./Expand/OtherResources/pic/chat_animation3.png`

因为代码也许是这样的：

    for (int i = 1; i <= 3; ++i) {
      NSString *imageName = [NSString stringWithFormat:@"chat_animation%d", i];
      UIImage *image = [UIImage imageNamed:imageName];
      ......
    }
* 执行DelUnusedPic.sh脚本 `sh DelUnusedPic.sh`
* 删除完毕。打开项目，将图片资源文件夹重新导入，以快速解决删除图片文件后报错`No such file or directory`

###觉得好用，保存起来长期使用的方法
###脚本执行环境变量`~/.bash_profile`
若没有该文件，则创建`vim ~/.bash_profile` 

`export PATH=/Users/rhcf_ios/Bin:$PATH`

`wq`保存并退出

这里是创建一个文件夹执行脚本，将搜索路径加入环境变量

将`shell.sh`文件放入`/Users/yourUserName/Bin`文件夹下

`mkdir Bin`创建文件夹

第一次创建时可以`source ~/.bash_profile`执行一次

然后`echo $PATH`

查看一下搜索路径是否添加成功

这样，每次打开终端的时候cd至需要使用的项目目录下都能使用

`findUnusedPic.sh 和 DelUnusedPic.sh`脚本了